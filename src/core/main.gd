@icon("res://assets/editor_icons/Node.svg")
class_name Main
extends Container


# TODO: LEVI'S MASTER LIST:
#
# - Change blown bubble gum color based on equipped.
# - Make level speed faster when super.
# - Bubble inflation widget for restarting level.
#   - Hook-up bubble inflation controls and widget activation.
#     - OLD NOTES: Add a UI widget for clicking a button when they pop the bubble by blowing.
#       - Use this to start a new run from the game-over screen.
#       - Use a shared utility for tracking ballon inflation for the initial
#          take-off when starting a level.
# - Add wispy wind effect animations.
# - Look at TODOs.
# - MORE ART.
#   - Add simple shading and animation to pickups and hud sprites.
#   - Add shading to all obstacles.
#   - Add bird animation.
#
# - ART:
#   - Nature:
#     -
#   - Urban:
#     -
#   - Misc:
#     -
#
# - Name ideas:
#   - You Blew It
#   - Blown Away
#   - Blow Me
#   - Blow Up
#   - Windblown
#   - Blow and Go
#   - Blew Through
#   - How Blow Can You Go?



enum ObstacleType {
    FLOATING,
    SIDEWAYS,
    UP_AND_DOWN,
    STANDING_SHORT,
    STANDING_TALL,
}

enum EnvironmentType {
    NATURE,
    FOREST,
    BEACH,
    DESERT,
    URBAN,
}


const SUPER_HUD_SCENE := preload("res://src/ui/super_hud.tscn")


func _ready() -> void:
    G.main = self

    var super_hud := SUPER_HUD_SCENE.instantiate()
    S.shell.add_to_canvas_layer("top", super_hud)
