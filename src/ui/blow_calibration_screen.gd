class_name BlowCalibrationScreen
extends Screen


var _blow_step_text := {
    title = "Blow",
    instructions = "While blowing moderately into your microphone, press the button.",
    button = "I'm blowing",
}

var _silence_step_text := {
    title = "Silence",
    instructions = "While not making any noise or touching the mic, press the button.",
    button = "I'm silent",
}

var is_in_blow_step := true

var _throttled_update_magnitude: Callable


func _ready() -> void:
    super()
    _throttled_update_magnitude = S.time.throttle(
        _update_magnitude_throttled, 0.2, false)
    %DeviceLabel.text = "(Using \"%s\")" % AudioServer.input_device
    _set_text(_blow_step_text)


func _process(_delta: float) -> void:
    _throttled_update_magnitude.call()


func _update_magnitude_throttled() -> void:
    %Magnitude.text = "%.5f" % G.mic.latest_magnitude


func _set_text(config: Dictionary) -> void:
    %Title.text = config.title
    %Instructions.text = config.instructions
    %ClickButton.text = config.button


func _on_click_button_pressed() -> void:
    if is_in_blow_step:
        var upper_threshold := G.mic.latest_magnitude
        S.settings.update_property("mic_magnitude_upper_threshold", upper_threshold)
        is_in_blow_step = false
        _set_text(_silence_step_text)
    else:
        var lower_threshold := G.mic.latest_magnitude * 2.0
        S.settings.update_property("mic_magnitude_lower_threshold", lower_threshold)
        S.screens.close("blow_calibration_screen")
