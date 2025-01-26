class_name Level
extends Node2D


var is_game_active := false


func _init() -> void:
    S.level = self


func start() -> void:
    is_game_active = true


func pause() -> void:
    if S.screens.is_top_screen("game_screen"):
        S.screens.open("pause_screen")
    get_tree().paused = true


func unpause() -> void:
    if not S.screens.is_top_screen("game_screen"):
        S.screens.close_screens_above("game_screen")
    get_tree().paused = false
