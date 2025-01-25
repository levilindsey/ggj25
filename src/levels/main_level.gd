class_name MainLevel
extends Level


const VIEWPORT_SIZE_BASIS := Vector2(576, 324)

var horizontal_speed := 200


func _ready() -> void:
    var viewport_size: Vector2 = G.main.get_viewport().size
    var viewport_basis_ratio := viewport_size / VIEWPORT_SIZE_BASIS
    var zoom: float = max(viewport_basis_ratio.x, viewport_basis_ratio.y)
    %Camera2D.zoom = Vector2.ONE * zoom


func _physics_process(delta: float) -> void:
    %Player.position.x += horizontal_speed * delta
