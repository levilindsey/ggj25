@icon("res://assets/editor_icons/Node.svg")
class_name InflationTrigger
extends VBoxContainer


signal triggered

@export_range(0.0, 1.0) var trigger_inflation_threshold := 1.0

# Whole-bubble-inflated per second.
@export var max_blow_bubble_inflate_speed := 1.0

# Whole-bubble-inflated per second.
@export var bubble_deflate_speed := -0.5

# [0,1]
var _bubble_inflation := 0.0

var _popped := false
var _triggered := false


func _process(delta: float) -> void:
    if _popped:
        return

    var blow_weight := G.mic.get_blow_weight()

    # Update inflation.
    var inflation_speed: float = lerpf(
        bubble_deflate_speed,
        max_blow_bubble_inflate_speed,
        blow_weight)
    _bubble_inflation += inflation_speed * delta
    _bubble_inflation = clampf(_bubble_inflation, 0, 1)

    %BubbleSprite.set_inflation(_bubble_inflation)

    if _bubble_inflation >= trigger_inflation_threshold:
        _pop()


func _pop() -> void:
    if _popped:
        return
    S.audio.play_sfx("widget_click")
    _popped = true
    %BubbleSprite.pop()
    S.time.set_timeout(_trigger, 0.6)


func _trigger() -> void:
    if _triggered:
        return
    _triggered = true
    S.log.print("InflationTrigger triggered")
    triggered.emit()
