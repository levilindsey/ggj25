@tool
@icon("res://assets/edior_icons/Node.svg")
class_name HummingModeToggle
extends HBoxContainer


func _ready() -> void:
    %CheckboxSettingsRow.set_up({name = "humming_mode", type = TYPE_BOOL}, SettingsScreen.SLIDER_WIDTH)
