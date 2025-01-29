class_name SuperGumSprite
extends AnimatedSprite2D


func _ready() -> void:
    %Timer.timeout.connect(_update_color)


func _update_color() -> void:
    modulate = Color.from_hsv(randf(), 0.8, 1.0, 1.0)
