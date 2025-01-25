@icon("res://assets/editor_icons/Node.svg")
class_name AudioInputSelector
extends VBoxContainer


const AUDIO_INPUT_CHECKBOX_ROW_SCENE := preload("res://src/ui/audio_input_checkbox_row.tscn")

var button_group: ButtonGroup


func _ready() -> void:
    button_group = ButtonGroup.new()

    var mic: AudioStreamMicrophone
    var input_devices := AudioServer.get_input_device_list()
    for device in input_devices:
        var row := AUDIO_INPUT_CHECKBOX_ROW_SCENE.instantiate()
        row.toggled.connect(_input_selected.bind(device))
        row.button_group = button_group
        #S.settings.update_property(property_name, toggled_on)
    AudioServer.input_device


func _input_selected(device_name: String, toggled_on: bool) -> void:
    pass
