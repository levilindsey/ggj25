@icon("res://assets/editor_icons/Node.svg")
class_name EarBudWarning
extends MarginContainer


@export var includes_input_selector := false


func _ready() -> void:
    %AudioInputSelectorContainer.visible = includes_input_selector


func _process(_delta: float) -> void:
    var regex = RegEx.new()
    regex.compile("(bud|pod)")
    var result := regex.search(AudioServer.input_device)
    visible = result != null
