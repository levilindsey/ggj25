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

var _lower_threshold: float
var _upper_threshold: float


func _ready() -> void:
    super()
    _throttled_update_magnitude = S.time.throttle(
        _update_magnitude_throttled, 0.2, false)
    %DeviceLabel.text = "(Using \"%s\")" % AudioServer.input_device
    _update_text()

    S.settings.property_changed.connect(_on_property_changed)


func _process(_delta: float) -> void:
    _throttled_update_magnitude.call()


func _update_magnitude_throttled() -> void:
    %Magnitude.text = "%.5f" % G.mic.latest_magnitude


func _update_text() -> void:
    var config := (
        _blow_step_text
        if is_in_blow_step
        else _silence_step_text
    )

    %Title.text = config.title
    %Instructions.text = config.instructions
    %ClickButton.text = config.button

    if is_in_blow_step and G.mic._humming_mode:
        %ClickButton.text = "I'm humming"


func _on_click_button_pressed() -> void:
    %NoSignificantDifferenceLabel.visible = false
    if is_in_blow_step:
        _upper_threshold = G.mic.latest_magnitude
        S.settings.update_property("mic_magnitude_upper_threshold", _upper_threshold)
        is_in_blow_step = false
        _update_text()
    else:
        _lower_threshold = clamp(G.mic.latest_magnitude * 2.0, 0, _upper_threshold)
        S.settings.update_property("mic_magnitude_lower_threshold", _lower_threshold)
        if _upper_threshold < _lower_threshold * 7:
            %NoSignificantDifferenceLabel.visible = true
            is_in_blow_step = true
            _update_text()
        else:
            S.screens.close("blow_calibration_screen")


func _on_property_changed(name: String, new_value: Variant, old_value: Variant) -> void:
    match name:
        "humming_mode":
            _update_text()
        _:
            # Do nothing.
            return
