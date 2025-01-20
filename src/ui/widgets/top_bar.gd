@tool
class_name TopBar
extends MarginContainer


@export var shows_credits := true
@export var shows_settings := true


func _ready() -> void:
    %Credits.visible = shows_credits
    %Settings.visible = shows_settings


func _on_credits_pressed() -> void:
    ScreenHandler.open("credits_screen")


func _on_settings_pressed() -> void:
    ScreenHandler.open("settings_screen")
