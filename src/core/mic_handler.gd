class_name MicHandler
extends Node


const CAPTURE_BUS_NAME := "Capture"
const PROCESS_BUS_NAME := "Process"
const PROCESS_EFFECT_INDEX := 0

const FREQUENCY_MAX := 100.0
const FREQUENCY_MIN := 0.0

const DEFAULT_LOW_MAGNITUDE := 0.0001
const DEFAULT_HIGH_MAGNITUDE := 0.03

const MIC_SAMPLE_PERIOD := 0.05
const MIC_PRINT_PERIOD := 0.3

const NO_DEVICE_DETECTED_CONSECUTIVE_ZERO_MAGNITUDE_FRAME_COUNT_THRESHOLD := 8

var log_mic_debugging := true

var spectrum: AudioEffectSpectrumAnalyzerInstance

var _throttled_sample: Callable
var _throttled_print: Callable

# -   This value is reset every MIC_SAMPLE_PERIOD seconds.
# -   It represents the max magnitude of the _current_ partial time window.
var _in_progress_max_magnitude := 0.0

# -   This value is updated every MIC_SAMPLE_PERIOD seconds.
# -   It represents the max magnitude of the _previous_ time window.
var latest_magnitude := 0.0

var _consecutive_zero_magnitude_frame_count := 0


func _ready() -> void:
    G.mic = self

    var process_bus_index := AudioServer.get_bus_index(PROCESS_BUS_NAME)
    spectrum = AudioServer.get_bus_effect_instance(process_bus_index, PROCESS_EFFECT_INDEX)

    _throttled_sample = S.time.throttle(_sample_throttled, MIC_SAMPLE_PERIOD, false)
    _throttled_print = S.time.throttle(_print_throttled, MIC_PRINT_PERIOD, false)


func _process(_delta: float) -> void:
    var stereo_magnitude := spectrum.get_magnitude_for_frequency_range(
        FREQUENCY_MIN,
        FREQUENCY_MAX,
        AudioEffectSpectrumAnalyzerInstance.MagnitudeMode.MAGNITUDE_MAX)
    var magnitude: float = lerp(stereo_magnitude.x, stereo_magnitude.y, 0.5)

    # Count consecutive zero-magnitude frames.
    if magnitude == 0.0:
        _consecutive_zero_magnitude_frame_count += 1
    else:
        _consecutive_zero_magnitude_frame_count = 0

    _in_progress_max_magnitude = max(_in_progress_max_magnitude, magnitude)
    _throttled_sample.call()
    _throttled_print.call()

    if _consecutive_zero_magnitude_frame_count >= NO_DEVICE_DETECTED_CONSECUTIVE_ZERO_MAGNITUDE_FRAME_COUNT_THRESHOLD:
        S.screens.show("mic_error_screen")


func _sample_throttled() -> void:
    latest_magnitude = _in_progress_max_magnitude
    _in_progress_max_magnitude = 0


func _print_throttled() -> void:
        S.log.print("Current mic magnitude (throttled): %.5f (%.2f)" %
            [latest_magnitude, get_blow_weight()])


# [0,1]
func get_blow_weight() -> float:
    var lower_threshold := S.settings.mic_magnitude_lower_threshold
    var upper_threshold := S.settings.mic_magnitude_upper_threshold
    var magnitude: float = clamp(latest_magnitude, lower_threshold, upper_threshold)
    return (magnitude - lower_threshold) / (upper_threshold - lower_threshold)
