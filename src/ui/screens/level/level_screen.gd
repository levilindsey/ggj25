class_name LevelScreen
extends Screen


func _ready() -> void:
    super()
    # TODO: Configure different levels?
    var level_scene = (
        G.manifest.dev_mode_level
        if G.settings.dev_mode
        else G.manifest.main_level
    )
    start(level_scene)


func start(level_scene: PackedScene) -> void:
    var level_node: Level = level_scene.instantiate()
    %SubViewport.add_child(level_node)
    level_node.start()

    %LevelStartSound.play()

    print("Level started: %s" % level_scene.resource_name)


func on_level_ended() -> void:
    ScreenHandler.open("game_over_screen")
    ScreenHandler.close(self)
