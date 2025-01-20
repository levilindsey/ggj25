class_name MainMenuScreen
extends Screen


func _unhandled_input(event: InputEvent) -> void:
    if (event.is_released() and
            (event is InputEventMouseButton or event is InputEventKey)):
        print("MainMenuScreen pressed")
        ScreenHandler.open("level_screen")
        ScreenHandler.close(self)
