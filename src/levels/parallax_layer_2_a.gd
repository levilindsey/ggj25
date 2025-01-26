extends ParallaxLayer

@export var cloud_speed: float = 0.0

@onready var fade_length = $"..".background2_fade_length
@onready var time_to_fade_out = $"..".background2_fade_out
@onready var time_to_fade_in = $"..".background2_fade_in


var fade_in_started = false
var fade_out_started = false
var elapsed_time = 0.0

func _ready() -> void:
    modulate.a = 0.0

func _process(delta: float) -> void:
    motion_offset.x += cloud_speed

    # Track elapsed game time
    elapsed_time += delta

    # Start fade-in
    if elapsed_time >= time_to_fade_in and not fade_in_started:
        fade_in_started = true
        fade_in(self, 1.0, fade_length)  # Fade to full opacity (1.0)

    # Start fade-out
    if elapsed_time >= time_to_fade_out and not fade_out_started:
        fade_out_started = true
        fade_out(self, 0.0, fade_length)  # Fade to 0 opacity

func fade_in(target_node: ParallaxLayer, target_opacity: float, duration: float) -> void:
    var timer = 0.0
    var initial_opacity = target_node.modulate.a

    # Smoothly fade in over the given duration
    while timer < duration:
        timer += get_process_delta_time()
        var new_opacity = lerp(initial_opacity, target_opacity, timer / duration)
        target_node.modulate.a = new_opacity
        await get_tree().process_frame  # Wait for the next frame

    target_node.modulate.a = target_opacity  # Ensure final opacity is set

func fade_out(target_node: ParallaxLayer, target_opacity: float, duration: float) -> void:
    var timer = 0.0
    var initial_opacity = target_node.modulate.a

    # Smoothly fade out over the given duration
    while timer < duration:
        timer += get_process_delta_time()
        var new_opacity = lerp(initial_opacity, target_opacity, timer / duration)
        target_node.modulate.a = new_opacity
        await get_tree().process_frame  # Wait for the next frame

    target_node.modulate.a = target_opacity  # Ensure final opacity is set
