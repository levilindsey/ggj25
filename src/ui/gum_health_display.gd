@tool
@icon("res://assets/editor_icons/Node.svg")
class_name GumHealthDisplay
extends Control


@export var sprite_size := Vector2(24, 24):
    set(value):
        sprite_size = value
        update()
@export var sprite_offset := 18:
    set(value):
        sprite_offset = value
        update()
@export var inner_scale: float:
    set(value):
        inner_scale = value
        update()

@export var floaty_gum_texture: Texture2D:
    set(value):
        floaty_gum_texture = value
        update()
@export var bouncy_gum_texture: Texture2D:
    set(value):
        bouncy_gum_texture = value
        update()


func _ready() -> void:
    update()


func update() -> void:
    if not is_node_ready():
        return

    %InnerWrapper.scale = inner_scale * Vector2.ONE

    for child in %HealthContainer.get_children():
        child.queue_free()

    var health: Array[E.BubbleGumType]
    if is_instance_valid(G.player):
        health = G.player.health
    elif Engine.is_editor_hint():
        health = [E.BubbleGumType.FLOATY, E.BubbleGumType.FLOATY, E.BubbleGumType.BOUNCY]
    else:
        health = []

    var count := health.size()
    for index in range(count):
        var reversed_index := (count - 1 - index)
        var texture_rect := TextureRect.new()
        texture_rect.texture = _get_texture(health[reversed_index])
        texture_rect.position.x = index * sprite_offset
        %HealthContainer.add_child(texture_rect)

    var total_width := (
        (count - 1) * sprite_offset + sprite_size.x
        if count > 0
        else sprite_size.x
    )
    custom_minimum_size = Vector2(total_width, sprite_size.y) * inner_scale


func _get_texture(type: E.BubbleGumType) -> Texture2D:
    match type:
        E.BubbleGumType.FLOATY:
            return floaty_gum_texture
        E.BubbleGumType.BOUNCY:
            return bouncy_gum_texture
        _:
            S.utils.ensure(false)
            return null
