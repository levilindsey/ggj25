class_name SettingsScreen
extends Screen


const CheckboxRowScene := preload("res://src/ui/widgets/settings_row/checkbox_settings_row.tscn")
const SliderRowScene := preload("res://src/ui/widgets/settings_row/slider_settings_row.tscn")

const SliderWidth := 200


func _ready() -> void:
    super()
    for property in G.settings.get_settings_properties():
        var row := _create_row(property)
        if row:
            %SettingsRows.add_child(row)


func _create_row(property: Dictionary) -> SettingsRow:
    var is_numeric: bool = property.type == TYPE_INT or property.type == TYPE_FLOAT
    var is_range: bool = is_numeric and property.hint == PropertyHint.PROPERTY_HINT_RANGE

    # Validate the property hint.
    if !G.ensure(property.hint == PROPERTY_HINT_NONE or is_range,
            "Unsupported settings property hint: name: %s, type: %s, hint: %s" % [
                property.name, property.type, property.hint
            ]):
        return
    if !G.ensure(!is_numeric or is_range,
            "Numeric settings properties must be defined with range hints: name: %s, type: %s, hint: %s" % [
                property.name, property.type, property.hint
            ]):
        return

    var row: SettingsRow
    match property.type:
        TYPE_BOOL:
            row = CheckboxRowScene.instantiate()
        TYPE_INT, \
        TYPE_FLOAT:
            row = SliderRowScene.instantiate()
        _:
            G.ensure(false,
                "Unsupported settings property type: name: %s, type: %s, hint: %s" % [
                    property.name, property.type, property.hint
                ])
            return null

    row.set_up(property, SliderWidth)
    return row


func _on_close_button_pressed() -> void:
    ScreenHandler.close(self)
