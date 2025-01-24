class_name GameOverScreen
extends Screen


# TODO: Play victory or failure sound.


func _on_play_button_pressed() -> void:
    S.screens.open("game_screen")
    S.screens.close(self)
