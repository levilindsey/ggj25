class_name Manifest
extends Resource


@export var dev_mode := true
@export var skip_main_menu_in_dev_mode := false

@export var dev_mode_level := preload("res://src/levels/main_level.tscn")
@export var main_level := preload("res://src/levels/main_level.tscn")

@export var screens: Dictionary[String, PackedScene] = {}


func get_screen_scene(name: String) -> PackedScene:
    return screens[name]


func has_screen_scene(name: String) -> bool:
    return screens.has(name)
