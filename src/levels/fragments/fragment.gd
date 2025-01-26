@tool
@icon("res://assets/editor_icons/Node.svg")
class_name Fragment
extends Node2D


const HEIGHT := 324

const DEBUG_LINE_WIDTH := 6.0
const DEBUG_BORDER_WIDTH := 1.0
const DEBUG_LINE_LENGTH := 40.0
const DEBUG_LINE_COLOR := Color("orange", 0.4)

@export var environment_type := Main.EnvironmentType.NATURE

@export var width := 512:
    set(value):
        width = value
        queue_redraw()


func _ready() -> void:
    queue_redraw()


func _draw() -> void:
    if not Engine.is_editor_hint() and not S.manifest.dev_mode:
        return

    var extents := Vector2(width, HEIGHT) / 2

    var top_left_corner := Vector2(-extents.x, -extents.y)
    var top_right_corner := Vector2(extents.x, -extents.y)
    var bottom_left_corner := Vector2(-extents.x, extents.y)
    var bottom_right_corner := Vector2(extents.x, extents.y)

    var debug_line_vertical_span := Vector2.DOWN * DEBUG_LINE_LENGTH
    var debug_line_horizontal_span := Vector2.RIGHT * DEBUG_LINE_LENGTH

    var corner_points := [
        [
            top_left_corner + debug_line_vertical_span,
            top_left_corner,
            top_left_corner + debug_line_horizontal_span,
        ],
        [
            top_right_corner + debug_line_vertical_span,
            top_right_corner,
            top_right_corner - debug_line_horizontal_span,
        ],
        [
            bottom_left_corner - debug_line_vertical_span,
            bottom_left_corner,
            bottom_left_corner + debug_line_horizontal_span,
        ],
        [
            bottom_right_corner - debug_line_vertical_span,
            bottom_right_corner,
            bottom_right_corner - debug_line_horizontal_span,
        ],
    ]
    for points in corner_points:
        draw_polyline(points, DEBUG_LINE_COLOR, DEBUG_LINE_WIDTH)

    var border_points := [
        top_left_corner,
        top_right_corner,
        bottom_right_corner,
        bottom_left_corner,
        top_left_corner,
    ]
    draw_polyline(border_points, DEBUG_LINE_COLOR, DEBUG_BORDER_WIDTH)
