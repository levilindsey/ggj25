@icon("res://assets/editor_icons/Node.svg")
class_name AudioInputSelector
extends HBoxContainer


var _text_to_index: Dictionary[String, int]


func _ready() -> void:
    # Populate the device options.
    #_add_item("Default")
    var input_devices := AudioServer.get_input_device_list()
    for device_name in input_devices:
        _add_item(device_name)

    # Select the current device.
    var label := (
        S.settings.audio_input
        if _text_to_index.has(S.settings.audio_input)
        else "Default"
    )
    %ClickOptionButton.select(_text_to_index[label])


func _add_item(label: String) -> void:
    _text_to_index[label] = _text_to_index.size()
    %ClickOptionButton.add_item(label)


func _input_selected(device_name: String, toggled_on: bool) -> void:
    S.settings.update_property("audio_input", device_name)
