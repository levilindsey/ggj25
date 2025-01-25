@icon("res://assets/editor_icons/Node.svg")
class_name AudioInputCheckboxRow
extends HBoxContainer


signal toggled(toggled_on)

@export var button_group: ButtonGroup



func _on_click_check_box_toggled(toggled_on: bool) -> void:
    # Don't call the parent class.
    toggled.emit(toggled_on)
