class_name Wind
extends Node2D


signal finished

const FRAMES_PER_SECOND := 30


func _ready() -> void:
    %AnimatedSprite2D.animation_finished.connect(_on_finished)
    %AnimatedSprite2D.sprite_frames.set_animation_speed("default", FRAMES_PER_SECOND)
    %AnimatedSprite2D.sprite_frames.set_animation_loop("default", false)


func play() -> void:
    %AnimatedSprite2D.play("default")


func _on_finished() -> void:
    finished.emit()
