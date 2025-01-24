class_name Level
extends Node2D


func _init() -> void:
    S.level = self


func start() -> void:
    # TODO: Play a silly level-start sound.
    pass


func pause() -> void:
    if S.screens.is_top_screen("game_screen"):
        S.screens.open("pause_screen")
    get_tree().paused = true


func unpause() -> void:
    if not S.screens.is_top_screen("game_screen"):
        S.screens.close_screens_above("game_screen")
    get_tree().paused = false
