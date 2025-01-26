@tool
class_name UpAndDownObstacle
extends Obstacle


const DEBUG_LINE_WIDTH := 10.0
const DEBUG_LINE_COLOR := Color("purple", 0.4)

@export var vertical_range := 128:
    set(value):
        vertical_range = value
        queue_redraw()

@export var oscillation_period := 3.0

@export var goes_up_first := true

var _start_position: Vector2
var _start_time: float


func _ready() -> void:
    super()
    queue_redraw()
    _start_position = position
    _start_time = S.time.get_play_time()


func _process(delta: float) -> void:
    if Engine.is_editor_hint():
        return
    var current_time := S.time.get_play_time()
    var progress := fmod(current_time - _start_time, oscillation_period) / oscillation_period
    var vertical_delta := sin(progress * TAU) * vertical_range / 2.0
    position.y = _start_position.y - vertical_delta


func _draw() -> void:
    if not Engine.is_editor_hint():
        return

    var half_vertical_displacement := Vector2.DOWN * vertical_range / 2.0

    draw_line(
        -half_vertical_displacement,
        half_vertical_displacement,
        DEBUG_LINE_COLOR,
        DEBUG_LINE_WIDTH)


func _on_detect_player_collision_body_entered(body: Node2D) -> void:
    _on_body_collided(body)
