extends AudioStreamPlayer

var current_ambience

func _ready():
    G.level_started.connect(_on_level_started)

func _on_level_started():
    current_ambience = stream.get_clip_name(get_stream_playback().get_current_clip_index())
