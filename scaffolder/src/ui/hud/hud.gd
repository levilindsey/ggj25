@icon("res://assets/editor_icons/Node.svg")
class_name Hud
extends PanelContainer


func _ready() -> void:
    S.hud = self

    self.visible = M.manifest.get("show_hud")


func _process(_delta: float) -> void:
    %Distance.text = "%d" % G.session.score


func _on_pause_pressed() -> void:
    S.level.pause()


func update_health() -> void:
    %GumHealthDisplay.update()
