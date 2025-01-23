@icon("res://assets/editor_icons/ClickHSlider.svg")
class_name ClickHSlider
extends HSlider


func _on_drag_ended(value_changed: bool) -> void:
    %AudioStreamPlayer.play()
    G.log.print("ClickHSlider value changed: %s" % value)
