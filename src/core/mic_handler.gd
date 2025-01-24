class_name MicHandler
extends Node


const CAPTURE_BUS_NAME := "Capture"
const PROCESS_BUS_NAME := "Process"
const PROCESS_EFFECT_INDEX := 0

# Magic value copied from the Godot Audio Spectrum Demo.
# Probably something relating to Fourier something something...
const FREQUENCY_MAX = 11050.0
const FREQUENCY_MIN = 0.0

var log_mic_debugging := true

var spectrum: AudioEffectSpectrumAnalyzerInstance

var _throttled_process: Callable

var _latest_max_magnitude := 0.0


func _ready() -> void:
    G.mic = self

    var process_bus_index := AudioServer.get_bus_index(PROCESS_BUS_NAME)
    spectrum = AudioServer.get_bus_effect_instance(process_bus_index, PROCESS_EFFECT_INDEX)

    _throttled_process = S.time.throttle(_process_throttled, 0.3, false)


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
    # TODO: Show some sort of amplitude indicator in the hud (show the smoothed signal).
    # TODO: Do something with this signal.

    _latest_max_magnitude = max(_latest_max_magnitude, magnitude)
    _throttled_process.call()


func _process_throttled() -> void:
    if log_mic_debugging:
        S.log.print("Current mic amplitude (throttled): %s" % _latest_max_magnitude)
    _latest_max_magnitude = 0
