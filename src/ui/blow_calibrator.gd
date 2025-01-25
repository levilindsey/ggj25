@icon("res://assets/editor_icons/Node.svg")
class_name BlowCalibrator
extends HBoxContainer


func _on_start_button_pressed() -> void:
    S.screens. open("blow_calibration_screen")
