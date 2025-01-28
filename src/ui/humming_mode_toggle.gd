@tool
@icon("res://assets/editor_icons/Node.svg")
class_name HummingModeToggle
extends HBoxContainer


func _ready() -> void:
    if Engine.is_editor_hint():
        return
    %CheckboxSettingsRow.set_up({name = "humming_mode", type = TYPE_BOOL}, SettingsScreen.SLIDER_WIDTH)
