@icon("res://assets/editor_icons/Screen.svg")
class_name Screen
extends PanelContainer


enum ScreenState {
    CLOSED,
    OPEN,
    TOP,
}


var main_theme := preload("res://src/ui/main_theme.tres")

@export var pauses_game_when_open := true

var screen_state := ScreenState.CLOSED:
    set = _set_screen_state


func _ready() -> void:
    process_mode = Node.PROCESS_MODE_ALWAYS
    theme = main_theme


func _set_screen_state(state: ScreenState) -> void:
    screen_state = state
