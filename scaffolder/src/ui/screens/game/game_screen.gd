class_name GameScreen
extends Screen


var sub_viewport: SubViewport


func _enter_tree() -> void:
    S.game_screen = self


func _ready() -> void:
    super()

    sub_viewport = %SubViewport

    await get_tree().process_frame

    # TODO: Configure different levels?
    var level_scene = (
        S.manifest.dev_mode_level
        if S.manifest.dev_mode
        else S.manifest.main_level
    )
    start(level_scene)


func start(level_scene: PackedScene) -> void:
    var level_node: Level = level_scene.instantiate()
    %SubViewport.add_child(level_node)
    level_node.start()

    S.audio.play_sfx("level_start")

    S.log.print("Level started: %s" % S.utils.get_display_text(level_scene))


func on_level_ended() -> void:
    S.screens.open("game_over_screen")
    S.screens.close(self)
