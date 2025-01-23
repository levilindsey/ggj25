@icon("res://assets/editor_icons/ClickButton.svg")
class_name ClickButton
extends Button


func _on_pressed() -> void:
    %AudioStreamPlayer.play()
    G.log.print("ClickButton pressed: %s" % text)
