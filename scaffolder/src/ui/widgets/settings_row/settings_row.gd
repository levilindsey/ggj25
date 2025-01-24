@icon("res://assets/editor_icons/Node.svg")
class_name SettingsRow
extends HBoxContainer


var property_name: String


func _ready() -> void:
    size_flags_horizontal = SIZE_EXPAND_FILL
    custom_minimum_size.y = 50


func set_up(property: Dictionary, value_width: float) -> void:
    property_name = property.name
    %Label.text = property.name.capitalize()
