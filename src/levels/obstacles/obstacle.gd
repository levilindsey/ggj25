@icon("res://assets/editor_icons/Node.svg")
class_name Obstacle
extends Node2D


enum ObstacleType {
    FLOATER,
    SLIDE_SIDEWAYS,
    UP_AND_DOWN,
    RISE_FROM_GROUND,
}

@export var type := ObstacleType.FLOATER
