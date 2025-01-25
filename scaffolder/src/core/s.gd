# class_name S
extends Node
## Scaffolder
##
## -   This is an autoload that holds a bunch of modules for the Scaffolder
##     framework.
## -   These modules provide lots of common functionality that is reusable across
##     many different kinds of games.
##
## Set up:
## -   Register this as an Autoload named S.
## -   Change stuff in manifest.tres.


signal loaded

const MANIFEST_PATH := "res://scaffolder/src/config/manifest.tres"

const SCAFFOLDER_SHELL_SCENE := preload("res://scaffolder/src/core/scaffolder_shell.tscn")

var manifest: Manifest
var log: ScaffolderLog
var utils: Utils
var time: ScaffolderTime
var settings: Settings
var audio: Audio
var screens: ScreenHandler
var shell: ScaffolderShell

var level: Level
var hud: Hud
var player: Node


func _ready() -> void:
    manifest = load(MANIFEST_PATH)

    var node_modules := [
        ["log", ScaffolderLog],
        ["utils", Utils],
        ["time", ScaffolderTime],
        ["audio", Audio],
        ["screens", ScreenHandler],
    ]

    for entry in node_modules:
        _instantiate_attach_and_record_module(entry[0], entry[1])

    # Load the user's custom settings if they exist, otherwise, load the default settings.
    if ResourceLoader.exists(Settings.USER_SETTINGS_PATH):
        settings = load(Settings.USER_SETTINGS_PATH)
        if is_instance_valid(settings):
            S.log.print("Loaded player's previous settings")
        else:
            S.log.warning("An error occurred loading the player's previous settings")
    if not is_instance_valid(settings):
        settings = load(Settings.DEFAULT_SETTINGS_PATH)
        S.log.print("Loaded default settings")

    var set_up_modules := [
        "settings",
        "log",
        "utils",
        "time",
        "audio",
        "screens",
    ]
    for entry in set_up_modules:
        _set_up_module(entry)

    # Inject the ScaffolderShell into the scene root.
    var shell := SCAFFOLDER_SHELL_SCENE.instantiate()
    get_tree().get_current_scene().add_child(shell)

    _on_loaded()


func _instantiate_attach_and_record_module(property_name: String, script: Script) -> void:
    var instance: Node = script.new()
    set(property_name, instance)
    add_child(instance)


func _set_up_module(property_name: String) -> void:
    var instance: Object = get(property_name)
    if instance.has_method("set_up"):
        instance.set_up()


func _on_loaded() -> void:
    if S.log.logs_early_bootstrap_events:
        S.log.print("S.loaded")
    loaded.emit()
    audio.play_sfx("game_load")
