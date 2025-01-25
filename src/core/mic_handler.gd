class_name MicHandler
extends Node


const CAPTURE_BUS_NAME := "Capture"
const PROCESS_BUS_NAME := "Process"
const PROCESS_EFFECT_INDEX := 0

# Magic value copied from the Godot Audio Spectrum Demo.
# Probably something relating to Fourier something something...
const FREQUENCY_MAX := 100.0
const FREQUENCY_MIN := 00.0

# Levi's mic:
const LOW_MAGNITUDE := 0.001
const HIGH_MAGNITUDE := 0.08

# Alden's mic:
#const LOW_MAGNITUDE := 0.0002
#const HIGH_MAGNITUDE := 0.0

const MIC_SAMPLE_PERIOD := 0.05
const MIC_PRINT_PERIOD := 0.3

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


# TODO: Consider adding a screen at the start for calibrating the light blow and
#       the hard blow levels (or from Settings).


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

    # TODO: Smooth the signal a bit.
    # TODO: Will we need to do something to dynamically tune the min and max
    #       amplitude thresholds based on the player's particular input
    #       (hardware, gain, environment, and voice can probably all differ
    #       wildly in terms of overall amplitude)?
    # TODO: Detect if amplitude is exactly 0.0, and show a mic-must-be-hooked-up-and-allowed screen.
    #       -   Auto-close screen when amplitude becomes >0.
    #       -   Disallow closing the screen otherwise.
    # TODO: Show some sort of amplitude indicator in the hud (show the smoothed signal).
    # TODO: Do something with this signal.

    _in_progress_max_magnitude = max(_in_progress_max_magnitude, magnitude)
    _sample_throttled()
    _print_throttled()


func _sample_throttled() -> void:
    latest_magnitude = _in_progress_max_magnitude
    _in_progress_max_magnitude = 0


func _print_throttled() -> void:
    if log_mic_debugging:
        S.log.print("Current mic magnitude (throttled): %s" % _in_progress_max_magnitude)


# [0,1]
func get_blow_weight() -> float:
    var magnitude: float = clamp(latest_magnitude, LOW_MAGNITUDE, HIGH_MAGNITUDE)
    return (magnitude - LOW_MAGNITUDE) / (HIGH_MAGNITUDE - LOW_MAGNITUDE)
