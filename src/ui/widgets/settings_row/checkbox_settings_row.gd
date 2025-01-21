class_name CheckboxSettingsRow
extends SettingsRow


func set_up(property: Dictionary, value_width: float) -> void:
    super(property, value_width)

    assert(property.type == TYPE_BOOL)

    var value: bool = G.settings.get(property.name)
    %ClickCheckBox.button_pressed = value


func _on_click_check_box_toggled(toggled_on: bool) -> void:
    G.settings.update_property(property_name, toggled_on)
