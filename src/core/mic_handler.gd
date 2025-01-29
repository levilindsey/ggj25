class_name MicHandler
extends Node


const CAPTURE_BUS_NAME := "Capture"
const PROCESS_BUS_NAME := "Process"
const PROCESS_EFFECT_INDEX := 0

const BLOWING_MODE_FREQUENCY_MAX := 40.0
const BLOWING_MODE_FREQUENCY_MIN := 0.0

const HUMMING_MODE_FREQUENCY_MAX := 1000.0
const HUMMING_MODE_FREQUENCY_MIN := 100.0

const DEFAULT_LOW_MAGNITUDE := 0.0001
const DEFAULT_HIGH_MAGNITUDE := 0.03

const MIC_SAMPLE_PERIOD := 0.05
const MIC_PRINT_PERIOD := 0.3

const NO_DEVICE_DETECTED_CONSECUTIVE_ZERO_MAGNITUDE_FRAME_COUNT_THRESHOLD := 8

var spectrum: AudioEffectSpectrumAnalyzerInstance

var _throttled_sample: Callable
var _throttled_print: Callable

# -   This value is reset every MIC_SAMPLE_PERIOD seconds.
# -   It represents the max magnitude of the _current_ partial time window.
var _in_progress_max_magnitude := 0.0
var _in_progress_max_blowing_magnitude := 0.0
var _in_progress_max_humming_magnitude := 0.0

# -   This value is updated every MIC_SAMPLE_PERIOD seconds.
# -   It represents the max magnitude of the _previous_ time window.
var latest_magnitude := 0.0

var _consecutive_blowing_zero_magnitude_frame_count := 0
var _consecutive_humming_zero_magnitude_frame_count := 0

var _humming_mode := false


func _ready() -> void:
    G.mic = self

    var process_bus_index := AudioServer.get_bus_index(PROCESS_BUS_NAME)
    spectrum = AudioServer.get_bus_effect_instance(process_bus_index, PROCESS_EFFECT_INDEX)

    _throttled_sample = S.time.throttle(_sample_throttled, MIC_SAMPLE_PERIOD, false)
    _throttled_print = S.time.throttle(_print_throttled, MIC_PRINT_PERIOD, false)

    S.settings.property_changed.connect(_on_property_changed)
    var value: bool = S.settings.get("humming_mode")
    _on_property_changed("humming_mode", value, value)


func _process(_delta: float) -> void:
    var blowing_stereo_magnitude := spectrum.get_magnitude_for_frequency_range(
        BLOWING_MODE_FREQUENCY_MIN,
        BLOWING_MODE_FREQUENCY_MAX,
        AudioEffectSpectrumAnalyzerInstance.MagnitudeMode.MAGNITUDE_MAX)
    var blowing_magnitude: float = lerpf(
        blowing_stereo_magnitude.x, blowing_stereo_magnitude.y, 0.5)

    var humming_stereo_magnitude := spectrum.get_magnitude_for_frequency_range(
        HUMMING_MODE_FREQUENCY_MIN,
        HUMMING_MODE_FREQUENCY_MAX,
        AudioEffectSpectrumAnalyzerInstance.MagnitudeMode.MAGNITUDE_MAX)
    var humming_magnitude: float = lerpf(
        humming_stereo_magnitude.x, humming_stereo_magnitude.y, 0.5)

    # Count consecutive zero-magnitude frames.
    if humming_magnitude == 0.0:
        _consecutive_humming_zero_magnitude_frame_count += 1
    else:
        _consecutive_humming_zero_magnitude_frame_count = 0
    if blowing_magnitude == 0.0:
        _consecutive_blowing_zero_magnitude_frame_count += 1
    else:
        _consecutive_blowing_zero_magnitude_frame_count = 0

    _in_progress_max_blowing_magnitude = max(
        _in_progress_max_blowing_magnitude, blowing_magnitude)
    _in_progress_max_humming_magnitude = max(
        _in_progress_max_humming_magnitude, humming_magnitude)

    _in_progress_max_magnitude = (
        _in_progress_max_humming_magnitude
        if _humming_mode
        else _in_progress_max_blowing_magnitude
    )

    _throttled_sample.call()
    _throttled_print.call()

    if _consecutive_humming_zero_magnitude_frame_count >= NO_DEVICE_DETECTED_CONSECUTIVE_ZERO_MAGNITUDE_FRAME_COUNT_THRESHOLD:
        S.screens.open("mic_error_screen")


func _on_property_changed(name: String, new_value: Variant, old_value: Variant) -> void:
    match name:
        "humming_mode":
            _set_humming_mode(new_value)
        _:
            # Do nothing.
            return


func _set_humming_mode(is_enabled: bool) -> void:
    _humming_mode = is_enabled


func _sample_throttled() -> void:
    latest_magnitude = _in_progress_max_magnitude
    _in_progress_max_magnitude = 0
    _in_progress_max_blowing_magnitude = 0
    _in_progress_max_humming_magnitude = 0

    var debugging_browser_hack := false
    if debugging_browser_hack:
        latest_magnitude = 0.8
        _in_progress_max_magnitude = 0.8
        _in_progress_max_blowing_magnitude = 0.8
        _in_progress_max_humming_magnitude = 0.8
        _consecutive_humming_zero_magnitude_frame_count = 0
        _consecutive_blowing_zero_magnitude_frame_count = 0


func _print_throttled() -> void:
    if M.manifest.log_mic_debugging:
        S.log.print(
            "Current mic magnitude (throttled): %.5f (%.2f); (blowing: %s, humming: %s)" %
            [
                latest_magnitude,
                get_blow_weight(),
                _in_progress_max_blowing_magnitude,
                _in_progress_max_humming_magnitude,
            ])


# [0,1]
func get_blow_weight() -> float:
    var lower_threshold := S.settings.mic_magnitude_lower_threshold
    var upper_threshold := S.settings.mic_magnitude_upper_threshold
    var magnitude: float = clampf(latest_magnitude, lower_threshold, upper_threshold)
    return (magnitude - lower_threshold) / (upper_threshold - lower_threshold)
