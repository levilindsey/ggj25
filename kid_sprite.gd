class_name KidSprite
extends AnimatedSprite2D


func set_floating() -> void:
    play("floating")


func set_standing() -> void:
    play("standing")


func set_crying() -> void:
    play("crying")


func set_rising() -> void:
    play("rising")


func set_rising_progress(progress: float) -> void:
    animation = "rising"
    frame = int(lerpf(0, sprite_frames.get_frame_count("rising") - 1, progress))
