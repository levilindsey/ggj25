@tool
@icon("res://assets/editor_icons/Node.svg")
class_name Fragment
extends Node2D


enum FragmentSeamType {
    OPEN,
    CLOSED_TOP,
    CLOSED_BOTTOM,
}

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

var size: Vector2:
    get:
        return Vector2(width, HEIGHT)

var bounds: Rect2:
    get:
        return Rect2(
            position - size / 2.0,
            size
        )


func _ready() -> void:
    queue_redraw()


func update_content() -> void:
    for child in get_children():
        if child is Obstacle:
            child.environment_type = environment_type
            child.update_content()


func _draw() -> void:
    if not Engine.is_editor_hint() and not S.manifest.render_debug_annotations:
        return

    var extents := size / 2

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
