class_name Game
extends Node
## G (Game)
##
## -   This is an autoload containing game-specific stuff.
## -   General-purpose reusable features should instead live in S or some other
##     Scaffolder module.


const OBSTACLE_SPRITE_MANIFEST := preload("res://src/levels/obstacles/obstacle_sprite_manifest.tres")

var main: Main
var super_hud: SuperHud
var mic: MicHandler
var level: MainLevel
var player: Player


func _ready() -> void:
    var mic_handler := MicHandler.new()
    add_child(mic_handler)
    mic_handler.process_mode = Node.PROCESS_MODE_ALWAYS
