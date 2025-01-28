class_name BubbleSprite
extends AnimatedSprite2D


@export var type := E.BubbleGumType.FLOATY:
    set(value):
        var old_type := type
        type = value
        if type != old_type:
            _update_type()

var _inflate_animation := "inflate_floaty"
var _pop_animation := "pop_floaty"

var _weight: float


func _update_type() -> void:
    match type:
        E.BubbleGumType.FLOATY:
            _inflate_animation = "inflate_floaty"
            _pop_animation = "pop_floaty"
        E.BubbleGumType.BOUNCY:
            _inflate_animation = "inflate_bouncy"
            _pop_animation = "pop_bouncy"
        _:
            S.utils.ensure(false)
            return

    if animation.contains("inflate"):
        set_inflation(_weight)


func set_inflation(weight: float) -> void:
    _weight = weight
    animation = _inflate_animation
    frame = int(lerpf(0, sprite_frames.get_frame_count(_inflate_animation) - 1, weight))


func pop() -> void:
    frame = 0
    play(_pop_animation)
