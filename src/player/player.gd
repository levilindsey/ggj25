class_name Player
extends CharacterBody2D


@export_range(0.0, 1.0) var start_level_bubble_inflation_threshold := 0.8
@export var initial_vertical_velocity := -130.0

# Pixels per second per second.
@export var floaty_max_blow_vertical_acceleration := -125.0
@export var bouncy_max_blow_vertical_acceleration := -2000.0

# Pixels per second per second.
@export var floaty_gravity_acceleration := 125.0
@export var bouncy_gravity_acceleration := 400.0

var max_blow_vertical_acceleration: float:
    get:
        return (
            bouncy_max_blow_vertical_acceleration
            if current_movement_type != BubbleGumPickup.Type.FLOATY
            else floaty_max_blow_vertical_acceleration
        )

var gravity_acceleration: float:
    get:
        return (
            bouncy_gravity_acceleration
            if current_movement_type != BubbleGumPickup.Type.FLOATY
            else floaty_gravity_acceleration
        )

# Whole-bubble-inflated per second.
@export var max_blow_bubble_inflate_speed := 0.8

# Whole-bubble-inflated per second.
@export var bubble_deflate_speed := -0.6

# Pixels per second.
@export var max_vertical_speed := 150.0

@export var ground_bounce_min_speed := 150.0

@export var initial_health: Array[BubbleGumPickup.Type] = [
    BubbleGumPickup.Type.FLOATY,
    BubbleGumPickup.Type.FLOATY,
    BubbleGumPickup.Type.FLOATY,
]

@export var post_damage_invincibility_duration := 1.0
#@export var level_start_invincibility_duration := 3.0

@export var super_duration := 7.0

@export var recovery_blink_duration := 0.07
@export var super_blink_duration := 0.07

@export var recovery_blink_modulation := Color.TRANSPARENT

@export var use_blink_workaround_timer := true

# [0,1]
var _bubble_inflation := 0.0

var _velocity := Vector2.ZERO

var health: Array[BubbleGumPickup.Type]

var ambience

var current_gum_type: BubbleGumPickup.Type:
    get:
        if is_super:
            return BubbleGumPickup.Type.BOUNCY
        elif not health.is_empty():
            return health.back()
        else:
            return BubbleGumPickup.Type.FLOATY

var current_movement_type: BubbleGumPickup.Type:
    get:
        return (
            BubbleGumPickup.Type.BOUNCY
            if current_gum_type != BubbleGumPickup.Type.FLOATY
            else BubbleGumPickup.Type.FLOATY
        )

var is_invincible := false
var is_recovering := false
var is_super := false

var _previous_position: Vector2

var _recovering_blink_interval_id: int
var _end_recovering_timeout_id: int

var _super_blink_interval_id: int
var _end_super_timeout_id: int


func _init() -> void:
    S.player = self
    G.player = self


func _ready() -> void:
    _previous_position = position
    _bubble_inflation = 0.0
    _velocity.y = initial_vertical_velocity
    health = initial_health
    modulate = Color.WHITE

    if use_blink_workaround_timer:
        %RecoveryBlinkWorkaroundTimer.wait_time = recovery_blink_duration
        %RecoveryBlinkWorkaroundTimer.timeout.connect(_toggle_recovering_blink)

        %SuperBlinkWorkaroundTimer.wait_time = super_blink_duration
        %SuperBlinkWorkaroundTimer.timeout.connect(_toggle_super_blink)

    _update_gum_type()
    S.hud.update_health()

    %KidSprite.set_standing()

    _update_inflation_sprite()


func _exit_tree() -> void:
    S.time.clear_timeout(_recovering_blink_interval_id)
    S.time.clear_timeout(_end_recovering_timeout_id)
    S.time.clear_timeout(_super_blink_interval_id)
    S.time.clear_timeout(_end_super_timeout_id)
    modulate = Color.WHITE


func _process(delta: float) -> void:
    var weight := G.mic.get_blow_weight()
    $blowing.volume_linear = lerpf($blowing.volume_linear, weight, 5 * delta)
    if weight > 0.25 and not $blowing.is_playing():
        $blowing.play()
    elif weight < 0.2 and $blowing.is_playing():
        fade_out_and_stop($blowing)


func fade_out_and_stop(player: AudioStreamPlayer) -> void:
    var fade_duration = .1
    var initial_volume = player.volume_linear
    var timer = 0.0

    while timer < fade_duration:
        timer += S.time.scale_delta(get_process_delta_time())
        player.volume_linear = lerpf(initial_volume, 0.0, timer / fade_duration)
        await get_tree().process_frame

    player.stop()
    player.volume_linear = 0


func _physics_process(delta: float) -> void:
    delta = S.time.scale_delta(delta)
    var blow_weight := G.mic.get_blow_weight() if not is_dead() else 0.0

    # Update inflation.
    var inflation_speed: float = lerpf(
        bubble_deflate_speed,
        max_blow_bubble_inflate_speed,
        blow_weight)
    _bubble_inflation += inflation_speed * delta
    _bubble_inflation = clampf(_bubble_inflation, 0, 1)

    if not G.level.has_started:
        _update_inflation_sprite()
        if _bubble_inflation > start_level_bubble_inflation_threshold:
            G.level.trigger_start()
        velocity = (position - _previous_position) / delta
        _previous_position = position
        return

    # Update speed.
    var acceleration: float = lerpf(
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

    _update_inflation_sprite()


func get_bounds() -> Rect2:
    return %CollisionShape2D.shape.get_rect()


func on_pickup_collided(pickup: Pickup) -> void:
    if S.utils.ensure(pickup is BubbleGumPickup):
        pick_up_bubble_gum(pickup)


func pick_up_bubble_gum(bubble_gum: BubbleGumPickup) -> void:
    $ChewRandom.play()
    S.log.print("Picked up bubble gum: %s" %
        BubbleGumPickup.Type.keys()[bubble_gum.type])
    _pick_up_bubble_gum_helper(bubble_gum, bubble_gum.type)


func _pick_up_bubble_gum_helper(
        bubble_gum: BubbleGumPickup, type: BubbleGumPickup.Type) -> void:
    if type != BubbleGumPickup.Type.RANDOM:
        G.session.pickups += 1

    match type:
        BubbleGumPickup.Type.FLOATY, \
        BubbleGumPickup.Type.BOUNCY:
            _add_gum(type)
        BubbleGumPickup.Type.SUPER:
            _start_super()
        BubbleGumPickup.Type.RANDOM:
            var options := [
                BubbleGumPickup.Type.FLOATY,
                BubbleGumPickup.Type.BOUNCY,
                BubbleGumPickup.Type.SUPER,
            ]
            var selection: BubbleGumPickup.Type = options.pick_random()
            _pick_up_bubble_gum_helper(bubble_gum, selection)
        _:
            S.utils.ensure(false)
    bubble_gum.queue_free()


func _add_gum(type: BubbleGumPickup.Type) -> void:
    health.push_back(type)
    _update_gum_type()
    S.hud.update_health()


func _update_gum_type() -> void:
    if is_dead():
        return

    S.log.print("Updating gum type: %s" %
        BubbleGumPickup.Type.keys()[current_gum_type])

    %BubbleSprite.type = current_gum_type


func on_ground_collided() -> void:
    if is_dead():
        return
    if not is_invincible and not S.manifest.god_mode:
        receive_damage()
    if is_dead():
        return
    var bounce_vertical_speed: float = max(ground_bounce_min_speed, velocity.y)
    _velocity.y = -bounce_vertical_speed


func on_obstacle_collided(obstacle: Obstacle) -> void:
    S.log.print("Obstacle collided: %s %s %s" % [
        S.utils.get_display_text(obstacle),
        Main.ObstacleType.keys()[obstacle.get_type()],
        Main.EnvironmentType.keys()[obstacle.environment_type],
    ])
    if is_dead():
        return
    elif is_super:
        _destroy_obstacle(obstacle)
    elif not is_invincible and not S.manifest.god_mode:
        receive_damage()


func on_obstacle_proximity(obstacle: Obstacle) -> void:
    S.log.print("Obstacle proximity: %s %s %s" % [
        S.utils.get_display_text(obstacle),
        Main.ObstacleType.keys()[obstacle.get_type()],
        Main.EnvironmentType.keys()[obstacle.environment_type],
    ])
    if G.level.current_environment != obstacle.environment_type:
        G.level.current_environment = obstacle.environment_type

        S.log.print("--- NEW ENVIRONMENT: %s ---" % obstacle.environment_type)

        # FIXME: REMOVE ME!
        #S.audio.play_sfx("game_load")

        G.level.entered_new_environment.emit(
            obstacle.environment_type, G.level.current_environment)
        change_ambience(G.fragment_spawner.current_fragment_environment)

func change_ambience(new: Main.EnvironmentType):
    match new:
        Main.EnvironmentType.NATURE:
            ambience = "NATURE"
        Main.EnvironmentType.FOREST:
            ambience = "NATURE"
        Main.EnvironmentType.BEACH:
            ambience = "BEACH"
        Main.EnvironmentType.DESERT:
            ambience = "DESERT"

    var current_ambience = G.level.ambience_player.current_ambience

    S.log.print("change_ambiance: old: %s, new: %s" % [current_ambience, ambience])

    if ambience != current_ambience:
        S.log.print("Changing ambiance: %s" % ambience)
        await get_tree().create_timer(3.0 / S.time.get_combined_scale()).timeout
        G.level.ambience_player.get_stream_playback().switch_to_clip_by_name(ambience)


func _destroy_obstacle(obstacle: Obstacle) -> void:
    S.log.print("Obstacle destroyed: %s %s %s" % [
        S.utils.get_display_text(obstacle),
        Main.ObstacleType.keys()[obstacle.get_type()],
        Main.EnvironmentType.keys()[obstacle.environment_type],
    ])
    $SplatRandom.play()
    obstacle.queue_free()
    G.session.obstacles_destroyed += 1


func receive_damage() -> void:
    S.log.print("Player received damage")
    $Pop.play()
    _bubble_inflation = 0.0
    health.pop_back()
    _update_gum_type()
    S.hud.update_health()
    _update_inflation_sprite()
    if is_dead():
        _on_died()
    else:
        _start_recovering(post_damage_invincibility_duration)
        # TODO: Show a brief animation.


func _update_inflation_sprite() -> void:
    %BubbleSprite.set_inflation(_bubble_inflation)


func start_rise_animation() -> void:
    %KidSprite.set_rising()


func _start_recovering(duration: float) -> void:
    S.utils.ensure(not is_recovering)
    is_recovering = true
    is_invincible = true
    _start_recovering_blink()
    _end_recovering_timeout_id = S.time.set_timeout(_end_recovering, duration)


func _end_recovering() -> void:
    S.utils.ensure(is_recovering)
    S.time.clear_timeout(_end_recovering_timeout_id)
    is_recovering = false
    is_invincible = false
    _stop_recovering_blink()


func _start_super() -> void:
    if is_super:
        _end_super()

    is_super = true
    is_invincible = true
    G.level.update_music()
    _start_super_blink()
    _end_super_timeout_id = S.time.set_timeout(_end_super, super_duration)


func _end_super() -> void:
    S.utils.ensure(is_super)
    S.time.clear_timeout(_end_super_timeout_id)
    is_super = false
    is_invincible = false
    G.level.update_music()
    _stop_super_blink()


func _start_recovering_blink() -> void:
    _toggle_recovering_blink()
    if use_blink_workaround_timer:
        %RecoveryBlinkWorkaroundTimer.start()
    else:
        _recovering_blink_interval_id = S.time.set_interval(
            _toggle_recovering_blink, recovery_blink_duration)


func _stop_recovering_blink() -> void:
    if use_blink_workaround_timer:
        %RecoveryBlinkWorkaroundTimer.stop()
    else:
        S.time.clear_interval(_recovering_blink_interval_id)
    modulate = Color.WHITE


func _toggle_recovering_blink() -> void:
    if modulate == Color.WHITE:
        modulate = recovery_blink_modulation
    else:
        modulate = Color.WHITE


func _start_super_blink() -> void:
    _toggle_super_blink()
    if use_blink_workaround_timer:
        %SuperBlinkWorkaroundTimer.start()
    else:
        _super_blink_interval_id = S.time.set_interval(
            _toggle_super_blink, super_blink_duration)


func _stop_super_blink() -> void:
    if use_blink_workaround_timer:
        %SuperBlinkWorkaroundTimer.stop()
    else:
        S.time.clear_interval(_super_blink_interval_id)
    modulate = Color.WHITE


func _toggle_super_blink() -> void:
    if modulate == Color.WHITE:
        # FIXME: Swap-out for a white+gray version of the player textures.
        modulate = Color.from_hsv(randf(), 1.0, 1.0, 1.0)
    else:
        modulate = Color.WHITE


func _on_died() -> void:
    S.log.print("Player died")
    %KidSprite.set_crying()
    $Crying.play()
    %BubbleSprite.visible = false
    G.level.game_over(false)


func is_dead() -> bool:
    return health.is_empty()
