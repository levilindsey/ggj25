@tool
class_name SidewaysObstacle
extends Obstacle


const DEBUG_LINE_PIXEL_TO_SPEED_RATIO := 4.0
const DEBUG_LINE_WIDTH := 10.0
const DEBUG_LINE_COLOR := Color("purple", 0.4)

@export var speed := 60.0:
    set(value):
        speed = value
        queue_redraw()

@export var start_moving_at_player_distance := 200.0:
    set(value):
        start_moving_at_player_distance = value
        if is_instance_valid(%PlayerInRangeShape):
            %PlayerInRangeShape.shape.size.x = start_moving_at_player_distance * 2

var _is_moving := false


func _ready() -> void:
    super()
    queue_redraw()


func _physics_process(_delta: float) -> void:
    if not _is_moving:
        return
    position.x -= speed * _delta


func _draw() -> void:
    if not Engine.is_editor_hint():
        return

    var line_length := speed * DEBUG_LINE_PIXEL_TO_SPEED_RATIO

    draw_line(
        Vector2.ZERO,
        Vector2.LEFT * line_length,
        DEBUG_LINE_COLOR,
        DEBUG_LINE_WIDTH)


func _on_detect_player_collision_body_entered(body: Node2D) -> void:
    _on_body_collided(body)


func _on_detect_player_in_range_body_entered(body: Node2D) -> void:
    _is_moving = true
