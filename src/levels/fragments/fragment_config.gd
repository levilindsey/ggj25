class_name FragmentConfig
extends Resource


@export var scene: PackedScene
@export var start_seam := Fragment.FragmentSeamType.OPEN
@export var end_seam := Fragment.FragmentSeamType.OPEN
@export_range(0.1, 1.0, 0.1) var difficulty := 0.5