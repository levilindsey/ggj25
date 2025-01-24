class_name Settings
extends Resource


signal property_changed(name: String, new_value: Variant, old_value: Variant)

@export_range(0.0, 1.0, 0.05) var music_volume := 0.5
@export_range(0.0, 1.0, 0.05) var sfx_volume := 0.5

const USER_SETTINGS_PATH := "user://user_settings.tres"
const DEFAULT_SETTINGS_PATH := "res://src/config/default_settings.tres"

var _throttled_save: Callable


func set_up() -> void:
    _throttled_save = G.time.throttle(_save_throttled, 0.3, false)


func get_settings_properties() -> Array:
    return get_property_list().filter(func(property: Dictionary):
        # - PROPERTY_USAGE_SCRIPT_VARIABLE filters properties of this script.
        # - PROPERTY_USAGE_EDITOR filters @export properties.
        return (
            property.usage & PROPERTY_USAGE_SCRIPT_VARIABLE &&
            property.usage & PROPERTY_USAGE_EDITOR
        ))


func update_property(name: String, value: Variant) -> void:
    var old_value: Variant = get(name)
    G.log.print("Settings property changed: %s: %s => %s" % [
        name,
        old_value,
        value
    ])
    set(name, value)
    _throttled_save.call()
    property_changed.emit(name, value, old_value)


func _save_throttled() -> void:
    G.log.print("Player settings saved")
    var result := ResourceSaver.save(self, USER_SETTINGS_PATH)
    assert(result == OK)
