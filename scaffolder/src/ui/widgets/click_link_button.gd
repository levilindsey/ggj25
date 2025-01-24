@icon("res://assets/editor_icons/ClickLinkButton.svg")
class_name ClickLinkButton
extends LinkButton


func _on_pressed() -> void:
    S.audio.play_sfx("widget_click")
    S.log.print("ClickLinkButton pressed: %s" % text)
