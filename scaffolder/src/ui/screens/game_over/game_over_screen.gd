class_name GameOverScreen
extends Screen


func _ready() -> void:
    super()
    %Score.text = "%d" % G.session.score
    $EndMusic.play()

func _on_play_button_pressed() -> void:
    _play()


func _on_inflation_trigger_triggered() -> void:
    _play()


func _play() -> void:
    $EndMusic.stop()
    S.screens.open("game_screen")
    S.screens.close(self)
