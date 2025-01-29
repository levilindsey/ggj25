@tool
@icon("res://assets/editor_icons/Node.svg")
class_name Obstacle
extends Node2D


@export var type := E.ObstacleType.FLOATING:
    set(value):
        type = value
        #if Engine.is_editor_hint():
            #update_content()

@export var environment_type := E.EnvironmentType.NATURE:
    set(value):
        environment_type = value
        #if Engine.is_editor_hint():
            #update_content()

var proximity_range := 1000.0

var _sprite: Node2D


func _ready() -> void:
    %ProximityShape.shape.size.x = proximity_range * 2
    #update_content()


func update_content() -> void:
    if (not is_instance_valid(M)
            or not ("manifest" in M)
            or not is_instance_valid(M.manifest)):
        return

    if is_instance_valid(_sprite):
        _sprite.queue_free()

    match [get_type(), environment_type]:
        [E.ObstacleType.FLOATING, E.EnvironmentType.NATURE]:
            _update_content_helper(M.manifest.obstacle_cloud)
        [E.ObstacleType.SIDEWAYS, E.EnvironmentType.NATURE]:
            _update_content_helper(M.manifest.obstacle_dragonfly)
        [E.ObstacleType.UP_AND_DOWN, E.EnvironmentType.NATURE]:
            _update_content_helper(M.manifest.obstacle_bird)
        [E.ObstacleType.STANDING_SHORT, E.EnvironmentType.NATURE]:
            _update_content_helper(M.manifest.obstacle_tree_short)
        [E.ObstacleType.STANDING_TALL, E.EnvironmentType.NATURE]:
            _update_content_helper(M.manifest.obstacle_tree_tall)
        [E.ObstacleType.STANDING_SHORT, E.EnvironmentType.BEACH]:
            _update_content_helper(M.manifest.obstacle_palm_short)
        [E.ObstacleType.STANDING_TALL, E.EnvironmentType.BEACH]:
            _update_content_helper(M.manifest.obstacle_palm_tall)
        [E.ObstacleType.UP_AND_DOWN, E.EnvironmentType.BEACH]:
            _update_content_helper(M.manifest.obstacle_beachball)
        [E.ObstacleType.STANDING_SHORT, E.EnvironmentType.DESERT]:
            _update_content_helper(M.manifest.obstacle_ufo_short)
        [E.ObstacleType.STANDING_TALL, E.EnvironmentType.DESERT]:
            _update_content_helper(M.manifest.obstacle_palm_tall)

        [E.ObstacleType.SIDEWAYS, E.EnvironmentType.NATURE]:
            _update_content_helper(M.manifest.obstacle_dragonfly)
        [E.ObstacleType.SIDEWAYS, E.EnvironmentType.FOREST]:
            _update_content_helper(M.manifest.obstacle_bluebird)
        [E.ObstacleType.STANDING_TALL, E.EnvironmentType.FOREST]:
            _update_content_helper(M.manifest.obstacle_tree_tall)
        [E.ObstacleType.SIDEWAYS, E.EnvironmentType.DESERT]:
            _update_content_helper(M.manifest.obstacle_ufo)
        _:
            match get_type():
                E.ObstacleType.FLOATING:
                    _update_content_helper(M.manifest.obstacle_cloud)
                E.ObstacleType.SIDEWAYS:
                    _update_content_helper(M.manifest.obstacle_dragonfly)
                E.ObstacleType.UP_AND_DOWN:
                    _update_content_helper(M.manifest.obstacle_bird)
                E.ObstacleType.STANDING_SHORT:
                    _update_content_helper(M.manifest.obstacle_tree_short)
                E.ObstacleType.STANDING_TALL:
                    _update_content_helper(M.manifest.obstacle_tree_tall)
                _:
                    S.utils.ensure(
                        false,
                        "Obstacle or environment type not recognized: %s, %s" %
                            [get_type(), environment_type])


func _update_content_helper(sprite_scene: PackedScene) -> void:
    _sprite = sprite_scene.instantiate()
    add_child(_sprite)
    move_child(_sprite, 0)


func _snap_to_ground() -> void:
    var half_height: float = %CollisionShape2D.shape.get_rect().size.y / 2.0
    if not Engine.is_editor_hint() and is_instance_valid(G.level):
        position.y = G.level.get_lower_bound() - half_height
    elif Engine.is_editor_hint():
        position.y = Fragment.HEIGHT / 2.0 - half_height


func _on_body_collided(body: Node2D) -> void:
    if not S.utils.ensure(body is Player):
        return
    body.on_obstacle_collided(self)


func _on_body_proximity(body: Node2D) -> void:
    if not S.utils.ensure(body is Player):
        return
    body.on_obstacle_proximity(self)


func get_type() -> E.ObstacleType:
    S.utils.ensure(false, "This should be overridden!")
    return E.ObstacleType.FLOATING
