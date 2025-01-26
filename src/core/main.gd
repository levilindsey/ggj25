@icon("res://assets/editor_icons/Node.svg")
class_name Main
extends Container


# TODO: LEVI'S MASTER LIST:
#
# - Intro animation sequence!!!!
# - With placeholder textures.
# - Just apply a small oscillation offset to the inflation sprite index, without actually affecting the underlying inflation value, until lift off threshold happens.
# - Will need to create quite a few sprites for different bubble inflation sizes
# - Add support for popping at too big.
#   - Shade character red before the pop.
# - Cheat and have bubble size directly relate to the vertical speed.
# - Find old desaturate shader! And adjust to also apply tint after.
# - Implement different movement profiles for different bubbles. Super should be bouncy.
# - THEN art
#
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
    URBAN,
}


const SUPER_HUD_SCENE := preload("res://src/ui/super_hud.tscn")


func _ready() -> void:
    G.main = self

    var super_hud := SUPER_HUD_SCENE.instantiate()
    S.shell.add_to_canvas_layer("top", super_hud)
