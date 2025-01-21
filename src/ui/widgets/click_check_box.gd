@icon("res://assets/editor_icons/ClickCheckBox.svg")
class_name ClickCheckBox
extends CheckBox


func _on_toggled(toggled_on: bool) -> void:
    %AudioStreamPlayer.play()
    print("ClickCheckBox pressed")
