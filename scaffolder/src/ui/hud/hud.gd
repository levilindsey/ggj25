@icon("res://assets/editor_icons/Node.svg")
class_name Hud
extends MarginContainer


func _ready() -> void:
    S.hud = self


func _process(_delta: float) -> void:
    %Distance.text = "%d" % G.session.score


func _on_pause_pressed() -> void:
    S.level.pause()
