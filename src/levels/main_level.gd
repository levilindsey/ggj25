class_name MainLevel
extends Level


signal entered_new_environment(
    new: E.EnvironmentType,
    old: E.EnvironmentType)

const TIME_SCALE_UPDATE_INTERVAL := 4.0

const GAME_OVER_SCREEN_DELAY := 2.0

const VIEWPORT_SIZE_BASIS := Vector2(576, 324)

const MAX_ASPECT_RATIO := 16.0/9.0
const MIN_ASPECT_RATIO := 9.0/16.0

@export var horizontal_speed := 80.0
@export var super_horizontal_speed := 160.0

@export var player_scene: PackedScene

@export_group("Intro")
@export var start_zoom := 24.0
@export var start_pan := Vector2(12, -18)
@export var zoom_out_duration := 2.0
@export var zoom_out_delay := 0.9
@export var auto_rise_duration := 2.0
@export var player_auto_rise_distance := 20.0
@export_group("")

var _last_background_music_position := 0.0
var _last_ambiance_position := 0.0
#var ambience

var _default_camera_position: Vector2
var _default_camera_zoom: Vector2
var _default_horizontal_speed: float

var has_started := false

var has_triggered_start := false

var ambience_player: AudioStreamPlayer

var current_environment := E.EnvironmentType.NATURE


func _ready() -> void:
    G.level = self

    _update_zoom()
    get_tree().get_root().size_changed.connect(_update_zoom)

    var environment_scheduler := EnvironmentScheduler.new()
    add_child(environment_scheduler)

    var fragment_spawner := FragmentSpawner.new()
    %Fragments.add_child(fragment_spawner)

    var player := player_scene.instantiate()
    %Anchor.add_child(player)

    fragment_spawner.entered_fragment.connect(_on_entered_fragment)

    _update_time_scale()
    S.time.set_interval(_update_time_scale, TIME_SCALE_UPDATE_INTERVAL)

    _default_camera_position = %Camera2D.position
    %Camera2D.position = start_pan

    _default_camera_zoom = %Camera2D.zoom
    %Camera2D.zoom = Vector2.ONE * start_zoom

    _default_horizontal_speed = horizontal_speed
    horizontal_speed = 0.0

    G.level_loaded.emit()

    await get_tree().create_timer(1.0).timeout

    ambience_player = %AmbiencePlayer
    %AmbiencePlayer.play()
    %BackgroundMusicPlayer.play()


func _update_time_scale() -> void:
    var weight := G.session.play_time / M.manifest.time_to_max_time_scale
    weight = clampf(weight, 0, 1)
    var time_scale := lerpf(1.0, M.manifest.max_time_scale, weight) * M.manifest.debug_time_scale
    S.time.time_scale = time_scale
    if M.manifest.log_time_scale_updates:
        S.log.print("Updating time scale: %.3f" % S.time.time_scale)


func _on_entered_fragment() -> void:
    if (G.fragment_spawner.current_fragment_environment !=
            G.fragment_spawner.previous_fragment_environment):
        if M.manifest.log_fragment_updates:
            S.log.print("Entered new environment: %s" %
                E.EnvironmentType.keys()[G.fragment_spawner.current_fragment_environment])
        #entered_new_environment.emit(
            #G.fragment_spawner.current_fragment_environment,
            #G.fragment_spawner.previous_fragment_environment)
        #change_ambience(G.fragment_spawner.current_fragment_environment)


#func change_ambience(new: E.EnvironmentType):
    #match new:
        #E.EnvironmentType.NATURE:
            #ambience = "NATURE"
            #print("Ambience:", ambience)
        #E.EnvironmentType.FOREST:
            #ambience = "NATURE"
            #print("Ambience:", ambience)
        #E.EnvironmentType.BEACH:
            #ambience = "BEACH"
            #print("Ambience:", ambience)
        #E.EnvironmentType.DESERT:
            #ambience = "DESERT"
            #print("Ambience:", ambience)
#
    #var current_ambience = %AmbiencePlayer.current_ambience
    #print("Current ambience:", current_ambience)
#
    #if ambience != current_ambience:
        #await get_tree().create_timer(3.0 / S.time.get_combined_scale()).timeout
        #%AmbiencePlayer.get_stream_playback().switch_to_clip_by_name(ambience)


func start() -> void:
    super()
    G.session.reset()
    G.session.start_time = S.time.get_play_time()


func _physics_process(delta: float) -> void:
    if not is_game_active:
        return

    if not has_triggered_start:
        return

    var speed := (
        super_horizontal_speed
        if G.player.is_super
        else horizontal_speed
    )
    %Anchor.position.x += speed * S.time.scale_delta(delta)
    G.session.distance = %Anchor.position.x


func _start() -> void:
    S.log.print("Starting level gameplay")

    has_started = true
    G.level_started.emit()


func trigger_start() -> void:
    if has_triggered_start:
        return

    S.log.print("Triggering rise animations")

    has_triggered_start = true

    S.time.tween_property(
        %Camera2D,
        "zoom",
        %Camera2D.zoom,
        _default_camera_zoom,
        zoom_out_duration,
        "ease_in_out",
        zoom_out_delay,
        TimeType.PLAY_PHYSICS_SCALED)

    S.time.tween_property(
        %Camera2D,
        "position",
        %Camera2D.position,
        _default_camera_position,
        zoom_out_duration,
        "ease_in_out",
        zoom_out_delay,
        TimeType.PLAY_PHYSICS_SCALED)

    S.time.tween_property(
        self,
        "horizontal_speed",
        horizontal_speed,
        _default_horizontal_speed,
        auto_rise_duration,
        "ease_in",
        0.0,
        TimeType.PLAY_PHYSICS_SCALED)

    # Rise moves 10 pixels over four frames at 5 frames per second.
    var rise_vertical_distance := 10.0
    var rise_frames_per_second := 5.0
    var rise_time_per_frame := 1.0 / rise_frames_per_second
    var rise_frames_count := 4
    var rise_duration_multiplier := 0.7
    var rise_duration := (rise_time_per_frame * rise_frames_count) * rise_duration_multiplier

    var player_position_start := G.player.position
    var player_rise_animation_position_end := (
        player_position_start + rise_vertical_distance * Vector2.UP)
    var player_other_rise_position_end := (
        player_rise_animation_position_end + rise_vertical_distance * Vector2.UP)

    S.time.tween_property(
        G.player,
        "position",
        player_position_start,
        player_rise_animation_position_end,
        rise_duration,
        "ease_in_out",
        0.0,
        TimeType.PLAY_PHYSICS_SCALED)

    S.time.tween_property(
        G.player,
        "position",
        player_rise_animation_position_end,
        player_other_rise_position_end,
        auto_rise_duration - rise_duration,
        "ease_out",
        rise_duration,
        TimeType.PLAY_PHYSICS_SCALED)

    S.time.set_timeout(_start, auto_rise_duration)

    G.player.start_rise_animation()


func _update_zoom() -> void:
    var viewport_size: Vector2 = G.main.get_viewport().size
    var viewport_aspect_ratio := viewport_size.x / viewport_size.y

    var sub_viewport := S.game_screen.sub_viewport
    var sub_viewport_container: SubViewportContainer = sub_viewport.get_parent()

    var sub_viewport_size: Vector2
    var sub_viewport_position: Vector2

    if viewport_aspect_ratio > MAX_ASPECT_RATIO:
        # Too wide.
        sub_viewport_size = Vector2(viewport_size.y * MAX_ASPECT_RATIO, viewport_size.y)
        sub_viewport_position = Vector2((viewport_size.x - sub_viewport_size.x) / 2.0, 0)
    elif viewport_aspect_ratio < MIN_ASPECT_RATIO:
        # Too tall.
        sub_viewport_size = Vector2(viewport_size.x, viewport_size.x / MIN_ASPECT_RATIO)
        sub_viewport_position = Vector2(0, (viewport_size.y - sub_viewport_size.y) / 2.0)
    else:
        sub_viewport_size = viewport_size
        sub_viewport_position = Vector2.ZERO

    var sub_viewport_aspect_ratio := sub_viewport_size.x / sub_viewport_size.y
    var sub_viewport_basis_ratio := sub_viewport_size / VIEWPORT_SIZE_BASIS

    sub_viewport.size = sub_viewport_size
    S.game_screen.size = viewport_size
    sub_viewport_container.position = sub_viewport_position

    _default_camera_zoom = max(sub_viewport_basis_ratio.x, sub_viewport_basis_ratio.y) * Vector2.ONE
    %Camera2D.zoom = _default_camera_zoom


func get_lower_bound() -> float:
    return %PlayerLowerBound.position.y


func get_upper_bound() -> float:
    return %PlayerUpperBound.position.y


func game_over(success: bool) -> void:
    S.log.print("GAME OVER: %s" % ("success" if success else "failure"))
    is_game_active = false
    G.session.end_time = S.time.get_play_time()
    await get_tree().create_timer(GAME_OVER_SCREEN_DELAY).timeout
    _show_game_over_screen()


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
