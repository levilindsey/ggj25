@tool
class_name FloatingObstacle
extends Obstacle


func _ready() -> void:
    super()


func _on_detect_player_collision_body_entered(body: Node2D) -> void:
    _on_body_collided(body)


func _on_detect_player_proximity_body_entered(body: Node2D) -> void:
    _on_body_proximity(body)


func get_type() -> Main.ObstacleType:
    return Main.ObstacleType.FLOATING
