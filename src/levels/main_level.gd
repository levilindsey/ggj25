class_name MainLevel
extends Level


var horizontal_speed := 200


func _physics_process(delta: float) -> void:
    %Player.position.x += horizontal_speed * delta
