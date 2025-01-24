@icon("res://assets/editor_icons/ClickButton.svg")
class_name ClickButton
extends Button


func _on_pressed() -> void:
    S.audio.play_sfx("widget_click")
    S.log.print("ClickButton pressed: %s" % text)
