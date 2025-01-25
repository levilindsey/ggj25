class_name Player
extends CharacterBody2D


@export_range(0.0, 1.0) var initial_bubble_inflation := 0.5
@export var initial_vertical_velocity := -75.0

# Pixels per second per second.
@export var max_blow_vertical_acceleration := -2000.0

# Pixels per second per second.
@export var gravity_acceleration := 400.0

# Whole-bubble-inflated per second.
@export var max_blow_bubble_inflate_speed := 0.3

# Whole-bubble-inflated per second.
@export var bubble_deflate_speed := -0.1

# Pixels per second.
@export var max_vertical_speed := 150.0

# [0,1]
var _bubble_inflation := 0.0

var _velocity := Vector2.ZERO


func _init() -> void:
    S.player = self
    _bubble_inflation = initial_bubble_inflation
    _velocity.y = initial_vertical_velocity


func _physics_process(delta: float) -> void:
    var blow_weight := G.mic.get_blow_weight()

    # Update inflation.
    var inflation_speed: float = lerp(
        bubble_deflate_speed,
        max_blow_bubble_inflate_speed,
        blow_weight)
    _bubble_inflation += inflation_speed * delta
    _bubble_inflation = clamp(_bubble_inflation, 0.0, 1.0)

    # Update speed.
    var acceleration: float = lerp(
        max_blow_vertical_acceleration,
        gravity_acceleration,
        1 - blow_weight)
    _velocity.y += acceleration * delta
    _velocity.y = clamp(_velocity.y, -max_vertical_speed, max_vertical_speed)

    # Update position.
    position.y += _velocity.y * delta
