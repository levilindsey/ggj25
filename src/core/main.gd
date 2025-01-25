@icon("res://assets/editor_icons/Node.svg")
class_name Main
extends Container


# TODO: LEVI'S MASTER LIST:
# - Add a magnitude indicator in the HUD.
# - Detect if amplitude is exactly 0.0, and show a
#   mic-must-be-hooked-up-and-allowed screen.
#   - Auto-close screen when amplitude becomes >0.
#   - Disallow closing the screen otherwise.
# - Add a UI widget for clicking a button when they pop the bubble by blowing.
#   - Use this to start a new run from the game-over screen.
#   - Use a shared utility for tracking ballon inflation for the initial
#     take-off when starting a level.


const SUPER_HUD_SCENE := preload("res://src/ui/super_hud.tscn")


func _ready() -> void:
    G.main = self

    var super_hud := SUPER_HUD_SCENE.instantiate()
    S.shell.add_to_canvas_layer("top", super_hud)
