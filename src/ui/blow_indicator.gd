@icon("res://assets/editor_icons/Node.svg")
class_name BlowIndicator
extends Control


@export var bar_count := 16.0
@export var low_color := Color.GREEN
@export var high_color := Color.ORANGE
@export var empty_color := Color.DIM_GRAY
@export var background_color := Color.TRANSPARENT
@export var bar_height := 4.0
@export var gap_height := 4.0
@export var bar_width := 40.0


func _process(_delta: float) -> void:
    queue_redraw()


func _draw() -> void:
    var blow_weight := G.mic.get_blow_weight()
    var filled_bar_count := int(lerp(0.0, bar_count, blow_weight))

    # Background
    var background_width := bar_count * (bar_height + gap_height) + gap_height
    var background_height := bar_count * (bar_height + gap_height) + gap_height
    draw_rect(
        Rect2(0.0, 0.0, background_width, background_height),
        background_color)

    # Bars
    for index in range(bar_count):
        var color: Color = (
            lerp(low_color, high_color, float(index) / bar_count)
            if index < filled_bar_count
            else empty_color
        )
        draw_rect(
            Rect2(
                gap_height,
                background_height - (index * (gap_height + bar_height) + gap_height),
                bar_width,
                bar_height),
            color)
