class_name MainMenuScreen
extends Screen


func _unhandled_input(event: InputEvent) -> void:
    if (event.is_released() and
            (event is InputEventMouseButton or event is InputEventKey) and
            screen_state == ScreenState.TOP):
        G.log.print("MainMenuScreen pressed")
        G.screens.open("level_screen")
        G.screens.close(self)
