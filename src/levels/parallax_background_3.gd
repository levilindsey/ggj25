extends ParallaxBackground

@export var fade_length := 3.0
@export var background_environment_type := E.EnvironmentType.BEACH
@export var fade_stagger := 2.0

var active_environment := false
var starting_opacity := 0.0

signal transition_in(fade_length, fade_stagger)
signal transition_out(fade_length, fade_stagger)

func _ready():
    G.level_started.connect(_on_level_started)

func _on_level_started():
    var emitter = G.level
    emitter.entered_new_environment.connect(_on_entered_new_environment)

func _on_entered_new_environment(new_env: E.EnvironmentType, old_env: E.EnvironmentType):
    var matches_new_environment = new_env == background_environment_type
    if matches_new_environment and active_environment == false:
        transition_in.emit(fade_length, fade_stagger)
        print("fade in:", E.EnvironmentType.keys()[new_env])
        active_environment = true

    elif !matches_new_environment and active_environment == true:
            transition_out.emit(fade_length, fade_stagger)
            active_environment = false
            print("fade out:", E.EnvironmentType.keys()[old_env])
            relayer_backgrounds(fade_length, fade_stagger)

func relayer_backgrounds(fade_length, fade_stagger):
    await get_tree().create_timer((fade_stagger + fade_length) / S.time.get_combined_scale()) .timeout
    var parent_node = G.level
    print("BEACH to bottom")
    parent_node.move_child(self, 0)
