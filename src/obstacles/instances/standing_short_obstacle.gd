@tool
class_name StandingShortObstacle
extends Obstacle


func _ready() -> void:
    super()
    _snap_to_ground()


func _process(_delta: float) -> void:
    if not Engine.is_editor_hint():
        return
    _snap_to_ground()


func _on_detect_player_collision_body_entered(body: Node2D) -> void:
    _on_body_collided(body)


func _on_detect_player_proximity_body_entered(body: Node2D) -> void:
    _on_body_proximity(body)
