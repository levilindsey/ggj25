class_name WindySpot
extends Node2D


@export var range := Vector2(400, 200)
@export var wind_spawn_delay_min := 0.15
@export var wind_spawn_delay_max := 0.3

@export var wind_scenes: Array[PackedScene]


func _ready() -> void:
    _handle_next_spawn()


func _handle_next_spawn() -> void:
    # Spawn wind.
    var wind: Wind = wind_scenes.pick_random().instantiate()
    wind.finished.connect(_on_finished.bind(wind))
    add_child(wind)
    wind.position = Vector2(randf() * range.x, randf() * range.y) - range / 2.0
    wind.scale.x *= -1
    wind.play()

    # Schedule next spawn.
    var delay := randf_range(wind_spawn_delay_min, wind_spawn_delay_max)
    S.time.set_timeout(_handle_next_spawn, delay, [], TimeType.PLAY_PHYSICS_SCALED)


func _on_finished(wind: Wind) -> void:
    wind.queue_free()
