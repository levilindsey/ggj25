class_name Game
extends Node
## G (Game)
##
## -   This is an autoload containing game-specific stuff.
## -   General-purpose reusable features should instead live in S or some other
##     Scaffolder module.


var main: Main
var super_hud: SuperHud
var mic: MicHandler
var session: GameSession
var level: MainLevel
var fragment_spawner: FragmentSpawner
var environment_scheduler: EnvironmentScheduler
var player: Player

signal level_loaded

func _ready() -> void:
    var mic_handler := MicHandler.new()
    add_child(mic_handler)
    mic_handler.process_mode = Node.PROCESS_MODE_ALWAYS

    session = GameSession.new()
