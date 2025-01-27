class_name BubbleSprite
extends AnimatedSprite2D


func set_inflation(weight: float) -> void:
    animation = "inflate"
    frame = int(lerpf(0, sprite_frames.get_frame_count("inflate") - 1, weight))


func pop() -> void:
    frame = 0
    play("pop")
