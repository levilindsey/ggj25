@icon("res://assets/editor_icons/ClickCheckBox.svg")
class_name ClickCheckBox
extends CheckBox


func _on_toggled(toggled_on: bool) -> void:
    S.audio.play_sfx("widget_click")
    S.log.print("ClickCheckBox pressed")
