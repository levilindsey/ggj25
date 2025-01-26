extends CanvasGroup
@onready var canvas_group = $"."  # Replace with the actual path to your CanvasGroup
@export var time_to_fade_in = 1.0  # When to start the fade-in
@export var time_to_fade_out = 5.0  # When to start the fade-out
@export var fade_length = 3.0  # Duration of both fade-in and fade-out

var fade_in_started = false
var fade_out_started = false
var elapsed_time = 0.0

func _process(delta: float) -> void:
    # Track elapsed game time
    elapsed_time += delta

    # Start fade-in
    if elapsed_time >= time_to_fade_in and not fade_in_started:
        fade_in_started = true
        fade_in(canvas_group, 1.0, fade_length)  # Fade to full opacity (1.0)

    # Start fade-out
    if elapsed_time >= time_to_fade_out and not fade_out_started:
        fade_out_started = true
        fade_out(canvas_group, 0.0, fade_length)  # Fade to 0 opacity

func fade_in(canvas_group: CanvasGroup, target_opacity: float, duration: float) -> void:
    var timer = 0.0
    var initial_opacity = canvas_group.modulate.a

    # Smoothly fade in over the given duration
    while timer < duration:
        timer += get_process_delta_time()
        var new_opacity = lerp(initial_opacity, target_opacity, timer / duration)
        canvas_group.modulate.a = new_opacity
        await get_tree().process_frame  # Wait for the next frame

    canvas_group.modulate.a = target_opacity  # Ensure final opacity is set

func fade_out(canvas_group: CanvasGroup, target_opacity: float, duration: float) -> void:
    var timer = 0.0
    var initial_opacity = canvas_group.modulate.a

    # Smoothly fade out over the given duration
    while timer < duration:
        timer += get_process_delta_time()
        var new_opacity = lerp(initial_opacity, target_opacity, timer / duration)
        canvas_group.modulate.a = new_opacity
        await get_tree().process_frame  # Wait for the next frame

    canvas_group.modulate.a = target_opacity  # Ensure final opacity is set
