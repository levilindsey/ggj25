class_name Player
extends CharacterBody2D



@export_range(0.0, 1.0) var initial_bubble_weight := 0.5

@export var max_bubble_acceleration := 800.0

@export var gravity_acceleration := 200.0

# [0,1]
var bubble_weight := 0.0


func _init() -> void:
    S.player = self
    bubble_weight = initial_bubble_weight


func _physics_process(delta: float) -> void:
    G.mic.get_blow_weight()
