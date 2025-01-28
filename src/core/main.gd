@icon("res://assets/editor_icons/Node.svg")
class_name Main
extends Container


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
