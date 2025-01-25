class_name Manifest
extends Resource


@export var dev_mode := true
@export var skip_main_menu_in_dev_mode := false

@export var pauses_on_focus_out := true

@export var dev_mode_level := preload("res://src/levels/main_level.tscn")
@export var main_level := preload("res://src/levels/main_level.tscn")

@export var main_theme: Theme

@export var screens: Dictionary[String, PackedScene]

@export var canvas_layers: Array[CanvasLayerConfig]

@export var sfxs: Dictionary[String, AudioStream] = {
	game_load = preload("res://scaffolder/assets/sfx/game_load.tres"),
	level_start = preload("res://scaffolder/assets/sfx/level_start.tres"),
	level_success = preload("res://scaffolder/assets/sfx/level_success.tres"),
	level_failure = preload("res://scaffolder/assets/sfx/level_failure.tres"),
	pause = preload("res://scaffolder/assets/sfx/pause.tres"),
	unpause = preload("res://scaffolder/assets/sfx/unpause.tres"),
	widget_click = preload("res://scaffolder/assets/sfx/menu_click.tres"),
}

var initial_screen: String:
	get:
		return (
			"game_screen"
			if dev_mode and skip_main_menu_in_dev_mode
			else "main_menu_screen"
		)


func get_screen_scene(name: String) -> PackedScene:
	return screens[name]


func has_screen_scene(name: String) -> bool:
	return screens.has(name)
