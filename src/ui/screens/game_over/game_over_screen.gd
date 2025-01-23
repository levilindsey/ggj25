class_name GameOverScreen
extends Screen


func _on_play_button_pressed() -> void:
    G.screens.open("level_screen")
    G.screens.close(self)
