class_name MainLevel
extends Level


const GAME_OVER_SCREEN_DELAY := 2.0

const VIEWPORT_SIZE_BASIS := Vector2(576, 324)

@export var horizontal_speed := 80


func _ready() -> void:
    G.level = self

    _update_zoom()
    get_tree().get_root().size_changed.connect(_update_zoom)

    var fragment_spawner := FragmentSpawner.new()
    add_child(fragment_spawner)


func start() -> void:
    super()
    G.session.reset()
    G.session.start_time = S.time.get_play_time()


func _physics_process(delta: float) -> void:
    if not is_game_active:
        return
    %Anchor.position.x += horizontal_speed * delta
    G.session.distance = %Anchor.position.x



func _update_zoom() -> void:
    var viewport_size: Vector2 = G.main.get_viewport().size
    var viewport_basis_ratio := viewport_size / VIEWPORT_SIZE_BASIS
    var zoom: float = max(viewport_basis_ratio.x, viewport_basis_ratio.y)
    %Camera2D.zoom = Vector2.ONE * zoom


func get_lower_bound() -> float:
    return %PlayerLowerBound.position.y


func get_upper_bound() -> float:
    return %PlayerUpperBound.position.y


func game_over(success: bool) -> void:
    S.log.print("GAME OVER: %s" % ("success" if success else "failure"))
    is_game_active = false
    G.session.end_time = S.time.get_play_time()
    # TODO: Play a sound.
    S.time.set_timeout(_show_game_over_screen, GAME_OVER_SCREEN_DELAY)


func _show_game_over_screen() -> void:
    S.screens.open("game_over_screen")
    S.screens.close("game_screen")
