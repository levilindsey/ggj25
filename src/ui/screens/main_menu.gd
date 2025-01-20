class_name MainMenu
extends Screen


func _unhandled_input(event: InputEvent) -> void:
    if (event.is_released() and
            (event is InputEventMouseButton or event is InputEventKey)):
        ScreenHandler.open("level_screen")
        ScreenHandler.close("main_menu")
