class_name ClickLinkButton
extends LinkButton


func _on_pressed() -> void:
    %AudioStreamPlayer.play()
    print("ClickLinkButton pressed: %" % text)
