class_name FragmentSpawner
extends Node2D


signal entered_fragment

const NEW_FRAGMENT_DISTANCE_FROM_PLAYER_SPAWN_THRESHELD := 500.0
const OLD_FRAGMENT_DISTANCE_FROM_PLAYER_DESPAWN_THRESHELD := 300.0

# Array[Array[FragmentConfig]]
var fragment_difficulty_buckets := []

var _fragment_count := 0

var _previous_fragment: Fragment
var _current_fragment: Fragment
var _next_fragment: Fragment

var previous_fragment_environment: Main.EnvironmentType
var current_fragment_environment: Main.EnvironmentType
var next_fragment_environment: Main.EnvironmentType

var time_to_next_fragment: float = INF


func _ready() -> void:
    G.fragment_spawner = self
    _bucketize_fragments()
    _spawn_start_fragment()


func _bucketize_fragments() -> void:
    # Array[float]
    var difficulties: Array = S.manifest.fragments.map(
        func(config: FragmentConfig):
            return config.difficulty
    ).reduce(
        # Dictionary[float, bool]
        func(accum: Dictionary, difficulty: float):
            accum[difficulty] = true
            return accum,
        {}
    ).keys()
    difficulties.sort()

    var bucket_count := difficulties.size()

    # Dictionary[float, int]
    var difficulty_to_index: Dictionary = range(
        bucket_count
    ).reduce(
        # Dictionary[float, int]
        func(accum: Dictionary, index: int):
            accum[difficulties[index]] = index
            return accum,
        {}
    )

    # Initialize the buckets as empty arrays.
    fragment_difficulty_buckets = range(bucket_count).map(
        func(_index: int):
            return [])

    # Fill the buckets.
    for config in S.manifest.fragments:
        var index: int = difficulty_to_index[config.difficulty]
        fragment_difficulty_buckets[index].push_back(config)


func _process(_delta: float) -> void:
    var player_position_x := G.player.global_position.x
    # Check for transitions to the next fragment.
    var is_past_current_fragment := player_position_x > _current_fragment.bounds.end.x
    var is_past_next_fragment := (
        is_instance_valid(_next_fragment)
        and player_position_x > _next_fragment.bounds.end.x)
    S.utils.ensure(not is_past_next_fragment)
    if is_past_current_fragment:
        _transition_to_next_fragment()

    # Check whether the player is close enough to spawn the next fragment.
    var is_close_enough_to_end_of_current_fragment := (
        player_position_x >=
        _current_fragment.bounds.end.x -
            NEW_FRAGMENT_DISTANCE_FROM_PLAYER_SPAWN_THRESHELD
    )
    if is_close_enough_to_end_of_current_fragment:
        _spawn_next_fragment()

    # Check whether the player is far enough to despawn the next fragment.
    if is_instance_valid(_previous_fragment):
        var is_far_enough_from_start_of_current_fragment := (
            player_position_x >=
            _current_fragment.bounds.position.x +
                OLD_FRAGMENT_DISTANCE_FROM_PLAYER_DESPAWN_THRESHELD
        )
        if is_far_enough_from_start_of_current_fragment:
            _despawn_previous_fragment()

    # Estimate the time until the next fragment.
    if is_instance_valid(_next_fragment):
        var distance_to_next_fragment := (
            _next_fragment.bounds.position.x - player_position_x)
        time_to_next_fragment = (
            distance_to_next_fragment /
            (G.level.horizontal_speed * S.time.get_combined_scale()))
    else:
        time_to_next_fragment = INF


func _spawn_start_fragment() -> void:
    var config := S.manifest.start_fragment
    _current_fragment = config.scene.instantiate()
    #_current_fragment.position.x = _current_fragment.width / 2.0
    add_child(_current_fragment)
    _fragment_count += 1
    current_fragment_environment = S.manifest.environment_sequence[0]


func _spawn_next_fragment() -> void:
    if is_instance_valid(_next_fragment):
        return

    var config := _select_next_fragment()

    if S.manifest.log_fragment_updates:
        S.log.print("Spawning next fragment: %s" %
            S.utils.get_display_text(config.scene))

    _next_fragment = config.scene.instantiate()
    _next_fragment.position.x = (
        _current_fragment.bounds.end.x + _next_fragment.width / 2.0)
    add_child(_next_fragment)
    _fragment_count += 1
    next_fragment_environment = G.environment_scheduler.current_environment


func _transition_to_next_fragment() -> void:
    if S.manifest.log_fragment_updates:
        S.log.print("Player entered next fragment: %s" %
            S.utils.get_display_text(_next_fragment))

    _despawn_previous_fragment()
    _previous_fragment = _current_fragment
    _current_fragment = _next_fragment
    _next_fragment = null
    previous_fragment_environment = current_fragment_environment
    current_fragment_environment = next_fragment_environment
    next_fragment_environment = G.environment_scheduler.current_environment

    entered_fragment.emit()


func _despawn_previous_fragment() -> void:
    if not is_instance_valid(_previous_fragment):
        return

    if S.manifest.log_fragment_updates:
        S.log.print("Despawning previous fragment: %s" %
            S.utils.get_display_text(_previous_fragment))

    _previous_fragment.queue_free()
    _previous_fragment = null


func _select_next_fragment() -> FragmentConfig:
    var difficulty_weight := G.session.play_time / S.manifest.time_to_max_fragment_difficulty
    difficulty_weight = clampf(difficulty_weight, 0.0, 1.0)

    var bucket_count := fragment_difficulty_buckets.size()

    var basis_index := int(bucket_count * difficulty_weight)
    basis_index = clampi(basis_index, 0, bucket_count - 1)

    # A hacky weighted random index offset. Prefers no offset.
    var sample := randf()
    var index_delta: int
    if sample < 0.6:
        index_delta = 0
    elif sample < 0.9:
        index_delta = 1
    else: # sample >= 0.9
        index_delta = 2
    if randf() < 0.5:
        index_delta *= -1

    var bucket_index := clampi(basis_index + index_delta, 0, bucket_count - 1)

    # Array[FragmentConfig]
    var bucket: Array = fragment_difficulty_buckets[bucket_index]
    var config_index := randi_range(0, bucket.size() - 1)

    return bucket[config_index]
