class_name EnvironmentScheduler
extends Node2D


signal changed_environment(new: Main.EnvironmentType, old: Main.EnvironmentType)


var environment_count := 0
var current_environment: Main.EnvironmentType


func _ready() -> void:
    G.environment_scheduler = self

    current_environment = S.manifest.environment_sequence[0]
    _change_environment()
    S.time.set_interval(_change_environment, S.manifest.environment_change_interval)


func _change_environment() -> void:
    environment_count += 1
    var manifest_index := (
        (environment_count - 1) % S.manifest.environment_sequence.size()
    )

    var previous_environment := current_environment
    current_environment = S.manifest.environment_sequence[manifest_index]

    if S.manifest.log_fragment_updates:
        S.log.print("New environment queued: %s" % Main.EnvironmentType.keys()[current_environment])

    changed_environment.emit(current_environment, previous_environment)
