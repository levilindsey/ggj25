class_name MainLevel
extends Level


signal entered_new_environment(
    new: Main.EnvironmentType,
    old: Main.EnvironmentType)

const TIME_SCALE_UPDATE_INTERVAL := 4.0

const GAME_OVER_SCREEN_DELAY := 2.0

const VIEWPORT_SIZE_BASIS := Vector2(576, 324)

@export var horizontal_speed := 80

@export var player_scene: PackedScene

var _last_background_music_position := 0.0
var _last_ambiance_position := 0.0


func _ready() -> void:
    G.level = self

    _update_zoom()
    get_tree().get_root().size_changed.connect(_update_zoom)

    var fragment_spawner := FragmentSpawner.new()
    add_child(fragment_spawner)

    var environment_scheduler := EnvironmentScheduler.new()
    add_child(environment_scheduler)

    var player := player_scene.instantiate()
    %Anchor.add_child(player)

    fragment_spawner.entered_fragment.connect(_on_entered_fragment)

    _update_time_scale()
    S.time.set_interval(_update_time_scale, TIME_SCALE_UPDATE_INTERVAL)

    G.level_loaded.emit()

func _update_time_scale() -> void:
    var weight := G.session.play_time / S.manifest.time_to_max_time_scale
    weight = clampf(weight, 0, 1)
    var time_scale := lerpf(1.0, S.manifest.max_time_scale, weight) * S.manifest.debug_time_scale
    S.time.time_scale = time_scale
    if S.manifest.log_time_scale_updates:
        S.log.print("Updating time scale: %.3f" % S.time.time_scale)


func _on_entered_fragment() -> void:
    if (G.fragment_spawner.current_fragment_environment !=
            G.fragment_spawner.previous_fragment_environment):
        if S.manifest.log_fragment_updates:
            S.log.print("Entered new environment: %s" %
                G.fragment_spawner.current_fragment_environment)
        entered_new_environment.emit(
            G.fragment_spawner.current_fragment_environment,
            G.fragment_spawner.previous_fragment_environment)


func start() -> void:
    super()
    G.session.reset()
    G.session.start_time = S.time.get_play_time()


func _physics_process(delta: float) -> void:
    if not is_game_active:
        return
    %Anchor.position.x += horizontal_speed * S.time.scale_delta(delta)
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


func update_music() -> void:
    if G.player.is_super:
        _last_background_music_position = %BackgroundMusicPlayer.get_playback_position()
        _last_ambiance_position = %AmbiencePlayer.get_playback_position()
        %BackgroundMusicPlayer.stop()
        %AmbiencePlayer.stop()
        %SuperBubbleMusicPlayer.play()
    else:
        %BackgroundMusicPlayer.play(_last_background_music_position)
        %AmbiencePlayer.play(_last_ambiance_position)
        %SuperBubbleMusicPlayer.stop()


func _show_game_over_screen() -> void:
    S.screens.open("game_over_screen")
    S.screens.close("game_screen")
