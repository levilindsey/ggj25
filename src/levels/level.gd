class_name Level
extends Node2D


func _init() -> void:
    G.level = self


func start() -> void:
    # TODO: Play a silly level-start sound.
    pass


func pause() -> void:
    if G.screens.is_top_screen("level_screen"):
        G.screens.open("pause_screen")
    get_tree().paused = true


func unpause() -> void:
    if not G.screens.is_top_screen("level_screen"):
        G.screens.close_screens_above("level_screen")
    get_tree().paused = false
