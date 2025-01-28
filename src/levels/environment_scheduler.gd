class_name EnvironmentScheduler
extends Node2D


signal changed_environment(new: E.EnvironmentType, old: E.EnvironmentType)


var environment_count := 0
var current_environment: E.EnvironmentType


func _ready() -> void:
    G.environment_scheduler = self

    current_environment = M.manifest.environment_sequence[0]
    _change_environment()
    S.time.set_interval(
        _change_environment,
        M.manifest.environment_change_interval,
        [],
        TimeType.PLAY_PHYSICS_SCALED)


func _change_environment() -> void:
    environment_count += 1
    var manifest_index := (
        (environment_count - 1) % M.manifest.environment_sequence.size()
    )

    var previous_environment := current_environment
    current_environment = M.manifest.environment_sequence[manifest_index]

    if M.manifest.log_fragment_updates:
        S.log.print("New environment queued: %s" % E.EnvironmentType.keys()[current_environment])

    changed_environment.emit(current_environment, previous_environment)
