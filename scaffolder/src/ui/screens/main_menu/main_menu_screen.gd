class_name MainMenuScreen
extends Screen


func _unhandled_input(event: InputEvent) -> void:
    if (event.is_released() and
            (event is InputEventMouseButton or event is InputEventKey) and
            screen_state == ScreenState.TOP):
        S.log.print("MainMenuScreen pressed")
        S.screens.open("game_screen")
        S.screens.close(self)
