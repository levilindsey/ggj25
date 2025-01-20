class_name GameOverScreen
extends Screen


func _on_play_button_pressed() -> void:
    ScreenHandler.open("level_screen")
    ScreenHandler.close(self)
