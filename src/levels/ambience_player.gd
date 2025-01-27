extends AudioStreamPlayer

var current_ambience

func _ready():
    G.level_started.connect(_on_level_started)

func _on_level_started():
    var playback := get_stream_playback()
    if !S.utils.ensure(is_instance_valid(playback)):
        return
    current_ambience = stream.get_clip_name(playback.get_current_clip_index())
