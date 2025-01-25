@icon("res://assets/editor_icons/ClickButton.svg")
class_name ClickOptionButton
extends OptionButton


func _on_pressed() -> void:
    S.audio.play_sfx("widget_click")
    S.log.print("ClickOptionButton pressed: %s" % text)


func _on_item_selected(index: int) -> void:
    S.audio.play_sfx("widget_click")
    S.log.print("ClickOptionButton item selected: %s %s" % [text, index])
