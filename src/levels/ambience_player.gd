extends AudioStreamPlayer

var current_ambience

func _ready():
    G.level_loaded.connect(_on_level_loaded)

func _on_level_loaded():
    current_ambience = stream.get_clip_name(get_stream_playback().get_current_clip_index())
