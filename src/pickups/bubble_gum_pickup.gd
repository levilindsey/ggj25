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

@export var vertical_range := 20.0
@export var oscillation_period := 1.8

@export_group("Sprite Scene")
@export var sprite_scene_floaty_gum: PackedScene
@export var sprite_scene_bouncy_gum: PackedScene
@export var sprite_scene_super_gum: PackedScene
@export_group("")

var _start_position: Vector2
var _start_time: float


func _ready() -> void:
    if Engine.is_editor_hint():
        return

    _start_position = position
    _start_time = S.time.get_scaled_play_time()

    if type == Type.RANDOM:
        type = [Type.FLOATY, Type.BOUNCY, Type.SUPER].pick_random()

    _update_content()


func _process(_delta: float) -> void:
    if Engine.is_editor_hint():
        return

    # Float up and down.
    var current_time := S.time.get_scaled_play_time()
    var progress := fmod(current_time - _start_time, oscillation_period) / oscillation_period
    var vertical_delta := sin(progress * TAU) * vertical_range / 2.0
    position.y = _start_position.y - vertical_delta


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
        _:
            S.utils.ensure(false)


func _update_sprite(scene: PackedScene) -> void:
    var instance := scene.instantiate()
    add_child(instance)


func _on_area_2d_body_entered(body: Node2D) -> void:
    if not S.utils.ensure(body is Player):
        return
    body.on_pickup_collided(self)
