@icon("res://assets/editor_icons/ClickLinkButton.svg")
class_name ClickLinkButton
extends LinkButton


func _on_pressed() -> void:
    %AudioStreamPlayer.play()
    G.log.print("ClickLinkButton pressed: %s" % text)
