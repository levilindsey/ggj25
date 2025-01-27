class_name SuperGumSprite
extends AnimatedSprite2D


func _ready() -> void:
    var duration := (
        G.player.super_blink_duration
        if is_instance_valid(G.player)
        else 0.07
    )
    S.time.set_interval(
        _update_color,
        duration,
        [],
        TimeType.PLAY_PHYSICS_SCALED)


func _update_color() -> void:
    modulate = Color.from_hsv(randf(), 0.8, 1.0, 1.0)
