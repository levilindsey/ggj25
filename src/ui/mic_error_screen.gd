class_name MicErrorScreen
extends Screen


func _process(_delta: float) -> void:
    # Close this screen once mic input is detected.
    if G.mic.latest_magnitude > 0.0:
        S.screens.close("mic_error_screen")
