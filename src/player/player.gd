class_name Player
extends CharacterBody2D


@export_range(0.0, 1.0) var initial_bubble_inflation := 0.5
@export var initial_vertical_velocity := -75.0

# Pixels per second per second.
@export var max_blow_vertical_acceleration := -2000.0

# Pixels per second per second.
@export var gravity_acceleration := 400.0

# Whole-bubble-inflated per second.
@export var max_blow_bubble_inflate_speed := 0.3

# Whole-bubble-inflated per second.
@export var bubble_deflate_speed := -0.1

# Pixels per second.
@export var max_vertical_speed := 150.0

@export var ground_bounce_min_speed := 150.0

@export var initial_health := 3

@export var post_damage_invincibility_duration := 1.0

@export var level_start_invincibility_duration := 3.0

@export var invincibility_blink_duration := 0.1

@export var invincibility_blink_modulation := Color.TRANSPARENT

# [0,1]
var _bubble_inflation := 0.0

var _velocity := Vector2.ZERO

var _health: int

var _is_invincible := false

var _invincibility_blink_interval_id: int


func _init() -> void:
    S.player = self
    G.player = self


func _ready() -> void:
    _bubble_inflation = initial_bubble_inflation
    _velocity.y = initial_vertical_velocity
    _health = initial_health
    _start_invincibility(level_start_invincibility_duration)


func _process(delta: float) -> void:
    var weight := G.mic.get_blow_weight()
    $blowing.volume_linear = lerp($blowing.volume_linear, weight, 5 * delta)
    if weight > 0.25 and not $blowing.is_playing():
        $blowing.play()
    elif weight < 0.2 and $blowing.is_playing():
        fade_out_and_stop($blowing)

func fade_out_and_stop(player: AudioStreamPlayer) -> void:
    var fade_duration = .1
    var initial_volume = player.volume_linear
    var timer = 0.0

    while timer < fade_duration:
        timer += get_process_delta_time()
        player.volume_linear = lerp(initial_volume, 0.0, timer / fade_duration)
        await get_tree().process_frame

    player.stop()
    player.volume_linear = 0


func _physics_process(delta: float) -> void:
    var blow_weight := G.mic.get_blow_weight() if not is_dead() else 0.0

    # Update inflation.
    var inflation_speed: float = lerp(
        bubble_deflate_speed,
        max_blow_bubble_inflate_speed,
        blow_weight)
    _bubble_inflation += inflation_speed * delta
    _bubble_inflation = clampf(_bubble_inflation, 0, 1)

    # Update speed.
    var acceleration: float = lerp(
        max_blow_vertical_acceleration,
        gravity_acceleration,
        1 - blow_weight)
    _velocity.y += acceleration * delta
    _velocity.y = clampf(_velocity.y, -max_vertical_speed, max_vertical_speed)

    # Update position.
    position.y += _velocity.y * delta

    var bounds := get_bounds()
    var extents := bounds.size / 2.0
    var min_y := G.level.get_upper_bound() + extents.y
    var max_y := G.level.get_lower_bound() - extents.y
    if position.y < min_y:
        position.y = min_y
        _velocity.y = 0.0
    if position.y > max_y:
        position.y = max_y
        on_ground_collided()


func get_bounds() -> Rect2:
    return %CollisionShape2D.shape.get_rect()


func on_ground_collided() -> void:
    if is_dead():
        return
    if not _is_invincible:
        receive_damage()
    if is_dead():
        return
    var bounce_vertical_speed: float = max(ground_bounce_min_speed, velocity.y)
    _velocity.y = -bounce_vertical_speed


func on_obstacle_collided(obstacle: Obstacle) -> void:
    if not _is_invincible:
        receive_damage()


func receive_damage() -> void:
    $Pop.play()
    _health -= 1
    if is_dead():
        _on_died()
    else:
        _start_invincibility(post_damage_invincibility_duration)
        # TODO: Show a brief animation.
        # TODO: Play a sound.


func _start_invincibility(duration: float) -> void:
    S.utils.ensure(not _is_invincible)
    _is_invincible = true
    _start_invincibility_blink()
    S.time.set_timeout(_end_invincibility, duration)


func _end_invincibility() -> void:
    S.utils.ensure(_is_invincible)
    _is_invincible = false
    _stop_invincibility_blink()


func _start_invincibility_blink() -> void:
    _toggle_invincibility_blink()
    _invincibility_blink_interval_id = S.time.set_interval(
        _toggle_invincibility_blink, invincibility_blink_duration)


func _stop_invincibility_blink() -> void:
    S.time.clear_interval(_invincibility_blink_interval_id)
    modulate = Color.WHITE


func _toggle_invincibility_blink() -> void:
    if modulate == Color.WHITE:
        modulate = invincibility_blink_modulation
    else:
        modulate = Color.WHITE


func _on_died() -> void:
    G.level.game_over(false)
    # TODO: Switch to a crying animation.


func is_dead() -> bool:
    return _health <= 0
