class_name Manifest
extends Resource


## We choose more difficult fragments as time goes on.
@export var time_to_max_fragment_difficulty: float = 5 * 60

## The frame rate speeds up as time goes on.
@export var time_to_max_time_scale: float = 20 * 60

## We change the environment (background and sprite textures) as time goes on.
@export var environment_change_interval: float = 5

## This speeds up the frame rate (makes everything faster!).
@export var max_time_scale: float = 3.0

@export var dev_mode := true
@export var skip_main_menu_in_dev_mode := false

@export var pauses_on_focus_out := true

@export_group("Logging")
@export var log_fragment_updates := false
@export var log_time_scale_updates := false
@export var log_mic_debugging := false
@export_group("")

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

@export var start_fragment: FragmentConfig
@export var fragments: Array[FragmentConfig]

@export_group("Obstacle sprites")
@export var obstacle_tree_short: PackedScene
@export var obstacle_tree_tall: PackedScene
@export var obstacle_bird: PackedScene
@export var obstacle_cloud: PackedScene
@export var obstacle_dragonfly: PackedScene
@export_group("")

@export var environment_sequence: Array[Main.EnvironmentType]

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
