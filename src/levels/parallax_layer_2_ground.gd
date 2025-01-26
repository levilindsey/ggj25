extends ParallaxLayer

@onready var canvas_group = $"."  # Replace with the actual path to your CanvasGroup
@onready var fade_length = $"..".background1_fade_length
@onready var time_to_fade = $"..".background1_fade_out

var fade_started = false
var elapsed_time = 0.0

func _ready() -> void:
    modulate.a = 1.0

func _process(delta: float) -> void:
    # Track elapsed game time
    elapsed_time += delta

    # Start fading after 15 seconds
    if elapsed_time >= time_to_fade and not fade_started:
        fade_started = true
        fade_background(canvas_group, 0.0, fade_length)  # Fade to 0 opacity over 10 seconds

func fade_background(canvas_group: ParallaxLayer, target_opacity: float, duration: float) -> void:
    var timer = 0.0
    var initial_opacity = canvas_group.modulate.a

    # Smoothly fade out over the given duration
    while timer < duration:
        timer += get_process_delta_time()
        var new_opacity = lerp(initial_opacity, target_opacity, timer / duration)
        canvas_group.modulate.a = new_opacity
        await get_tree().process_frame  # Wait for the next frame

    canvas_group.modulate.a = target_opacity  # Ensure final opacity is set
