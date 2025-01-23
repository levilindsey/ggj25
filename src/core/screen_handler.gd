class_name ScreenHandler
extends Node


var _screen_stack: Array[ActiveScreen] = []


func open(screen_name: String) -> void:
    G.log.print("ScreenHandler.open( %s )" % screen_name)

    if !G.manifest.has_screen_scene(screen_name):
        push_error("Invalid screen_name: %s" % screen_name)
        return

    var scene: PackedScene = G.manifest.get_screen_scene(screen_name)
    var screen: Screen = scene.instantiate()
    var stack_entry := ActiveScreen.new(screen_name, screen)

    # Update the screen-state of the old screen.
    var previous_screen := get_top_screen()
    if previous_screen:
        previous_screen.screen.screen_state = Screen.ScreenState.OPEN

    # Open the new screen.
    G.shell.add_child(screen)
    _screen_stack.push_back(stack_entry)
    screen.screen_state = Screen.ScreenState.TOP

    get_tree().paused = _is_a_pausing_screen_open()


func close(screen_node_or_name) -> bool:
    G.log.print("ScreenHandler.close( %s )" % screen_node_or_name)

    var screen_entry: ActiveScreen
    if screen_node_or_name is String:
        screen_entry = _get_active_screen_by_name(screen_node_or_name)
    else:
        screen_entry = _get_active_screen_by_node(screen_node_or_name)

    if is_instance_valid(screen_entry):
        var was_top := screen_entry.screen.screen_state == Screen.ScreenState.TOP

        # Remove the old screen.
        _screen_stack.erase(screen_entry)
        screen_entry.screen.queue_free()

        # Update the screen-state of the new top screen.
        var top_screen := get_top_screen()
        if (is_instance_valid(top_screen) and
                top_screen.screen.screen_state != Screen.ScreenState.TOP):
            top_screen.screen.screen_state = Screen.ScreenState.TOP

        return true

    G.log.print("Screen not open: %s" % screen_node_or_name)

    return false


func get_top_screen() -> ActiveScreen:
    if _screen_stack.is_empty():
        return null
    return _screen_stack.back()


func _get_active_screen_by_name(name: String) -> ActiveScreen:
    if !G.manifest.has_screen_scene(name):
        push_error("Invalid screen_name: %s" % name)
        return null

    var index := _screen_stack.find_custom(
        func(entry: ActiveScreen): return entry.name == name)
    if index < 0:
        return null
    return _screen_stack[index]


func _get_active_screen_by_node(screen: Screen) -> ActiveScreen:
    var index := _screen_stack.find_custom(
        func(entry: ActiveScreen): return entry.screen == screen)
    if index < 0:
        return null
    return _screen_stack[index]


func _is_a_pausing_screen_open() -> bool:
    for entry in _screen_stack:
        if entry.screen.pauses_game_when_open:
            return true
    return false


class ActiveScreen extends RefCounted:
    var name: String
    var screen: Screen

    func _init(name: String, screen: Screen) -> void:
        self.name = name
        self.screen = screen
