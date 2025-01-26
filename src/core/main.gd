@icon("res://assets/editor_icons/Node.svg")
class_name Main
extends Container


# TODO: LEVI'S MASTER LIST:
#
# - Add time scaling.
# - Fix player respawn when starting a new run.
# - Implement pickups.
# - Make a couple fragments.
#   - Make them hard.
#   - Remove the others from the manifest, for now.
#
# - ART:
#   - Player:
#     - Player standing at start
#     - Player floating
#     - Bubble at different sizes
#       - Hook-up bubble inflation controls.
#   - Nature:
#     -
#   - Urban:
#     -
#   - Misc:
#     - Bubble inflation widget for restarting level.
#       - Hook-up bubble inflation controls and widget activation.
#         - OLD NOTES: Add a UI widget for clicking a button when they pop the bubble by blowing.
#            - Use this to start a new run from the game-over screen.
#            - Use a shared utility for tracking ballon inflation for the initial
#              take-off when starting a level.
#   - Taken-damage animation.
#   - Death animation.
#   - Intro animation.
#
# - Name ideas:
#   - You Blew It
#   - Blown Away
#   - Blow Me
#   - Blow Up
#   - Windblown
#   - Blow and Go
#   - Blew Through



enum ObstacleType {
    FLOATING,
    SIDEWAYS,
    UP_AND_DOWN,
    STANDING_SHORT,
    STANDING_TALL,
}

enum EnvironmentType {
    NATURE,
    URBAN,
}


const SUPER_HUD_SCENE := preload("res://src/ui/super_hud.tscn")


func _ready() -> void:
    G.main = self

    var super_hud := SUPER_HUD_SCENE.instantiate()
    S.shell.add_to_canvas_layer("top", super_hud)
