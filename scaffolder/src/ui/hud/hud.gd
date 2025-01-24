@icon("res://assets/editor_icons/Node.svg")
class_name Hud
extends MarginContainer


func _ready() -> void:
    S.hud = self


func _on_pause_pressed() -> void:
    S.level.pause()
