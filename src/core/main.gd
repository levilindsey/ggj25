@icon("res://assets/editor_icons/Node.svg")
class_name Main
extends Container


# TODO: LEVI'S MASTER LIST:
# - Four types of obstacles:
#   - A: Static, rising from the ground.
#   - B: Static, floating.
#     - With sub types for varying heights.
#   - C: Moves leftward.
#   - D: Moves up and down.
# - Make placeholder art:
#   - Nature:
#     - A: Tree
#     - B: Cloud
#     - C: Dragonfly?
#     - D: Bird
#   - City:
#     - A: House/building
#     - B: Cloud
#     - C: Paper airplane
#     - D: Drone
#   - ...
# - Level, obstacle, and enemy generation / spawning.
#   - For random level spawning, to guarantee survivability:
#     - Hand create a bunch of level fragments.
#     - Annotate each fragment with a type for its start and end seam.
#     - Only spawn adjacent fragments whose seam types match.
#     - Some seam types:
#       - Open
#       - Level along top
#       - Level along bottom
#       - Level in center
#       - And combinations of the last three, with bit flags
#     -
#     - ALSO, annotate each fragment with something about its difficulty and content.
#     - Then, the spawner can think about the piece of difficult fragments.
#     - And the spawner can think about what content for the current phase of the run.
#     - Make some bits of content seriously to support re using fragments across phases?
#   - Moving enemies:
#       - Have then also be hand encoded within fragments.
#       - Have one move straight forward slightly faster than the surrounding blocks.
#       - Have one oscillate up and down at a constant x coordinate.
#       - Is that it?
# - Add a UI widget for clicking a button when they pop the bubble by blowing.
#   - Use this to start a new run from the game-over screen.
#   - Use a shared utility for tracking ballon inflation for the initial
#     take-off when starting a level.


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
