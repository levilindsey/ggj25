class_name ClickButton
extends Button


func _on_pressed() -> void:
    %AudioStreamPlayer.play()
    print("ClickButton pressed: %" % text)
