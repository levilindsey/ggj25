class_name GameOverScreen
extends Screen


func _ready() -> void:
    super()
    %Score.text = "%d" % G.session.score


func _on_play_button_pressed() -> void:
    S.screens.open("game_screen")
    S.screens.close(self)
