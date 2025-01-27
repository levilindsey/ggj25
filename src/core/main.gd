@icon("res://assets/editor_icons/Node.svg")
class_name Main
extends Container


# TODO: LEVI'S MASTER LIST:
#
# - Add wispy wind effect animations.
# - MORE ART.
#   - Add simple shading and animation to pickups.
#   - Add shading to all obstacles.
#   - Add bird animation.
#
# - ART:
#     - Fix trees
#     - Fix cloud
#     - Fix dragonfly
#     - Fix bird
#     - Fix ufo
#     - Fix pickups
#     - Palmtrees
#     - Beachball
#     - UFO abducting human
#     - Wispy wind effect.
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
#   - Oh, the Places You'll Blow


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
