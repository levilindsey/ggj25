class_name MicErrorScreen
extends Screen


func _ready() -> void:
    var detecting_hums := G.mic._consecutive_humming_zero_magnitude_frame_count < 2
    %NoMicErrorContainer.visible = not detecting_hums
    %NoBlowFrequenciesErrorContainer.visible = detecting_hums

    var is_running_in_browser := OS.has_feature("web")
    %RestartInstructions.visible = not is_running_in_browser
    %ReloadInstructions.visible = is_running_in_browser


func _process(_delta: float) -> void:
    # Close this screen once mic input is detected.
    if G.mic.latest_magnitude > 0.0:
        S.screens.close("mic_error_screen")
        if is_instance_valid(S) and is_instance_valid(S.level):
            S.level.unpause()


func _on_click_button_pressed() -> void:
    S.settings.update_property("humming_mode", true)
    S.screens.close("mic_error_screen")
