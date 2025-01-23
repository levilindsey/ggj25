class_name Audio
extends Node


func set_up() -> void:
    G.settings.property_changed.connect(_on_property_changed)
    for property_name in ["music_volume", "sfx_volume"]:
        var value: float = G.settings.get(property_name)
        _on_property_changed(property_name, value, value)


func _on_property_changed(name: String, new_value: Variant, old_value: Variant) -> void:
    match name:
        "music_volume":
            # new_value is [0,1].
            set_music_volume(linear_to_db(new_value))
        "sfx_volume":
            # new_value is [0,1].
            set_sfx_volume(linear_to_db(new_value))
        _:
            # Do nothing.
            return


func set_music_volume(volume_db: float) -> void:
    var index := AudioServer.get_bus_index("Music")
    AudioServer.set_bus_volume_db(index, volume_db)


func set_sfx_volume(volume_db: float) -> void:
    var index := AudioServer.get_bus_index("SFX")
    AudioServer.set_bus_volume_db(index, volume_db)
