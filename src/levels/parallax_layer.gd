extends ParallaxLayer

@export var cloud_speed: float = 0.0

func _ready():
    G.level_loaded.connect(_on_level_loaded)
    modulate.a = 1.0
    
func _on_level_loaded():
    var emitter = $".."
    emitter.transition_in.connect(fade_in.bind(1.0))
    emitter.transition_out.connect(fade_out.bind(0.0))

func _process(delta: float) -> void:
    motion_offset.x += cloud_speed

func fade_in( duration: float, fade_stagger: float, target_opacity: float) -> void:
    await get_tree().create_timer(fade_stagger).timeout
    var timer = 0.0
    var initial_opacity = modulate.a

    # Smoothly fade in over the given duration
    while timer < duration:
        timer += get_process_delta_time()
        var new_opacity = lerp(initial_opacity, target_opacity, timer / duration)
        modulate.a = new_opacity
        await get_tree().process_frame  # Wait for the next frame

    modulate.a = target_opacity  # Ensure final opacity is set

func fade_out(duration: float, fade_stagger: float, target_opacity: float) -> void:
    await get_tree().create_timer(fade_stagger).timeout
    var timer = 0.0
    var initial_opacity = modulate.a

    # Smoothly fade out over the given duration
    while timer < duration:
        timer += get_process_delta_time()
        var new_opacity = lerp(initial_opacity, target_opacity, timer / duration)
        modulate.a = new_opacity
        await get_tree().process_frame  # Wait for the next frame

    modulate.a = target_opacity  # Ensure final opacity is set
