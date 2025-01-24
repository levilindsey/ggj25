@icon("res://assets/editor_icons/Node.svg")
class_name Shell
extends Container


@export var pauses_on_focus_out := true


func _ready() -> void:
    G.shell = self

    var initial_screen := (
        "level_screen"
        if G.manifest.dev_mode and G.manifest.skip_main_menu_in_dev_mode
        else "main_menu_screen"
    )
    G.screens.open(initial_screen)

    %GameLoadSound.play()


func _notification(notification: int) -> void:
    match notification:
        NOTIFICATION_WM_GO_BACK_REQUEST:
            # Handle the Android back button to navigate within the app instead of
            # quitting the app.
            if G.screens.is_top_screen("main_menu_screen"):
                close_app()
            else:
                # TODO: Close the current screen if it's not level_screen.
                pass
        NOTIFICATION_WM_CLOSE_REQUEST:
            close_app()
        NOTIFICATION_WM_WINDOW_FOCUS_OUT:
            if is_instance_valid(G.level) and pauses_on_focus_out:
                G.level.pause()
        _:
            pass


func _unhandled_input(event: InputEvent) -> void:
    if G.manifest.dev_mode:
        if event is InputEventKey:
            match event.physical_keycode:
                KEY_P:
                    G.utils.take_screenshot()
                KEY_O:
                    G.hud.visible = not G.hud.visible
                    G.log.print(
                        "Toggled HUD visibility: %s" %
                        ("visible" if G.hud.visible else "hidden"))
                KEY_ESCAPE:
                    if is_instance_valid(G.level):
                        G.level.pause()
                _:
                    pass


func close_app() -> void:
    if G.utils.were_screenshots_taken:
        G.utils.open_screenshot_folder()
    G.log.print("Shell.close_app")
    get_tree().call_deferred("quit")
