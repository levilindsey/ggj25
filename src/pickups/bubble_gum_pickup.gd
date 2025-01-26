@tool
class_name BubbleGumPickup
extends Pickup


enum Type {
    FLOATY,
    BOUNCY,
    SUPER,
    RANDOM,
}


@export var type := Type.FLOATY:
    set(value):
        type = value
        _update_content()

@export_group("Sprite Scene")
@export var sprite_scene_floaty_gum: PackedScene
@export var sprite_scene_bouncy_gum: PackedScene
@export var sprite_scene_super_gum: PackedScene
@export_group("")


func _ready() -> void:
    _update_content()


func _update_content() -> void:
    modulate = Color.WHITE
    match type:
        Type.FLOATY:
            _update_sprite(sprite_scene_floaty_gum)
        Type.BOUNCY:
            _update_sprite(sprite_scene_bouncy_gum)
        Type.SUPER:
            _update_sprite(sprite_scene_super_gum)
        Type.RANDOM:
            _update_sprite(sprite_scene_super_gum)
            modulate = Color.DIM_GRAY
        _:
            S.utils.ensure(false)


func _update_sprite(scene: PackedScene) -> void:
    var instance := scene.instantiate()
    add_child(instance)


func _on_area_2d_body_entered(body: Node2D) -> void:
    if not S.utils.ensure(body is Player):
        return
    body.on_pickup_collided(self)
