extends CanvasGroup


@onready var canvas_group = $"."

var fade_started = false
var elapsed_time = 0.0

func _process(delta: float) -> void:
    # Track elapsed game time
    elapsed_time += delta

    # Start fading after 15 seconds
    if elapsed_time >= 5.0 and not fade_started:
        fade_started = true
        fade_background(canvas_group, 0.0, 50.0)  # Fade to 0 opacity over 10 seconds

func fade_background(canvas_group: CanvasGroup, target_opacity: float, duration: float) -> void:
    var timer = 0.0
    var initial_opacity = canvas_group.modulate.a

    # Smoothly fade out over the given duration
    while timer < duration:
        timer += S.time.scale_delta(get_process_delta_time())
        var new_opacity = lerp(initial_opacity, target_opacity, timer / duration)
        canvas_group.modulate.a = new_opacity
        await get_tree().process_frame  # Wait for the next frame

    canvas_group.modulate.a = target_opacity  # Ensure final opacity is set
