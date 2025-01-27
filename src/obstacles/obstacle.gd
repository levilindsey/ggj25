@tool
@icon("res://assets/editor_icons/Node.svg")
class_name Obstacle
extends Node2D


@export var type := Main.ObstacleType.FLOATING:
    set(value):
        type = value
        #if Engine.is_editor_hint():
            #update_content()

@export var environment_type := Main.EnvironmentType.NATURE:
    set(value):
        environment_type = value
        #if Engine.is_editor_hint():
            #update_content()

var _sprite: Node2D


func _ready() -> void:
    pass
    #update_content()


func update_content() -> void:
    if (not is_instance_valid(S)
            or not ("manifest" in S)
            or not is_instance_valid(S.manifest)):
        return

    if is_instance_valid(_sprite):
        _sprite.queue_free()

    match [type, environment_type]:
        [Main.ObstacleType.FLOATING, Main.EnvironmentType.NATURE]:
            _update_content_helper(S.manifest.obstacle_cloud)
        [Main.ObstacleType.SIDEWAYS, Main.EnvironmentType.NATURE]:
            _update_content_helper(S.manifest.obstacle_dragonfly)
        [Main.ObstacleType.UP_AND_DOWN, Main.EnvironmentType.NATURE]:
            _update_content_helper(S.manifest.obstacle_bird)
        [Main.ObstacleType.STANDING_SHORT, Main.EnvironmentType.NATURE]:
            _update_content_helper(S.manifest.obstacle_tree_short)
        [Main.ObstacleType.STANDING_TALL, Main.EnvironmentType.NATURE]:
            _update_content_helper(S.manifest.obstacle_tree_tall)
        [Main.ObstacleType.STANDING_TALL, Main.EnvironmentType.FOREST]:
            _update_content_helper(S.manifest.obstacle_bluebird)
        [Main.ObstacleType.SIDEWAYS, Main.EnvironmentType.DESERT]:
            _update_content_helper(S.manifest.obstacle_ufo)
        _:
            match type:
                Main.ObstacleType.FLOATING:
                    _update_content_helper(S.manifest.obstacle_cloud)
                Main.ObstacleType.SIDEWAYS:
                    _update_content_helper(S.manifest.obstacle_dragonfly)
                Main.ObstacleType.UP_AND_DOWN:
                    _update_content_helper(S.manifest.obstacle_bird)
                Main.ObstacleType.STANDING_SHORT:
                    _update_content_helper(S.manifest.obstacle_tree_short)
                Main.ObstacleType.STANDING_TALL:
                    _update_content_helper(S.manifest.obstacle_tree_tall)
                _:
                    S.utils.ensure(
                        false,
                        "Obstacle or environment type not recognized: %s, %s" %
                            [type, environment_type])


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
