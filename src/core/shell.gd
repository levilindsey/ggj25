@icon("res://assets/editor_icons/Node.svg")
class_name Shell
extends Container


func _ready() -> void:
    G.shell = self

    var initial_screen := "level_screen" if G.settings.dev_mode else "main_menu"
    G.screens.open(initial_screen)

    %GameLoadSound.play()
