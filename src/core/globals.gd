#class_name Globals
extends Node


var manifest := preload("res://src/config/manifest.tres")
var log: ScaffolderLog
var utils: Utils
var time: ScaffolderTime
var settings: Settings
var audio: Audio
var screens: ScreenHandler
var shell: Shell

var level: Level
var hud: Hud
var player: Player


func _ready() -> void:
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
        G.log.print("Loaded player's previous settings")
    else:
        settings = load(Settings.DEFAULT_SETTINGS_PATH)
        G.log.print("Loaded default settings")

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


func _instantiate_attach_and_record_module(property_name: String, script: Script) -> void:
    var instance: Node = script.new()
    set(property_name, instance)
    add_child(instance)


func _set_up_module(property_name: String) -> void:
    var instance: Object = get(property_name)
    if instance.has_method("set_up"):
        instance.set_up()
