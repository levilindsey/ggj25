# class_name G
extends Node
## Game
##
## -   This is an autoload containing game-specific stuff.
## -   General-purpose reusable features should instead live in S or some other
##     Scaffolder module.


var main: Main
var super_hud: SuperHud
var mic: MicHandler


func _ready() -> void:
    var mic_handler := MicHandler.new()
    add_child(mic_handler)
    mic_handler.process_mode = Node.PROCESS_MODE_ALWAYS
