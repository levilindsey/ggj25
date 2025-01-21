class_name Settings
extends Resource


signal property_changed(name: String, new_value: Variant, old_value: Variant)

# FIXME(llindsey): Hook this up to some master volume controls.
@export_range(0.0, 1.0) var music_volume := 0.5
@export_range(0.0, 1.0) var sfx_volume := 0.5
@export var dev_mode := true


func get_settings_properties() -> Array:
    return get_property_list().filter(func(property: Dictionary):
        return property.usage & PROPERTY_USAGE_SCRIPT_VARIABLE)


func update_property(name: String, value: Variant) -> void:
    var old_value: Variant = get(name)
    print("Settings property changed: %s: %s => %s" % [
        name,
        old_value,
        value
    ])
    set(name, value)
    # FIXME(llindsey): LEFT OFF HERE: ------------------- Persist.
    property_changed.emit(name, value, old_value)
