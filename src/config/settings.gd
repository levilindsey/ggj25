class_name Settings
extends Resource


@export_range(0.0, 1.0) var music_volume := 0.5
@export_range(0.0, 1.0) var sfx_volume := 0.5
@export var dev_mode := true


func get_settings_properties() -> Dictionary:
    var result := {}
    # FIXME(llindsey): LEFT OFF HERE: ----------------------
    print("--- SETTINGS PROPERTIES ---")
    for property in get_property_list():
        print("%s: %s - %s (%s)" % [property.name, property.usage, property.hint, property.hint_string])
    return result
