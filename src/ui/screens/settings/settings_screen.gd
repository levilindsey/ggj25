class_name SettingsScreen
extends Screen



func _ready() -> void:
    super()
    for property in G.settings.get_settings_properties():
        # FIXME(llindsey): LEFT OFF HERE: -----------------------------
        # - Create a widget row for each setting.
        pass


func _on_close_button_pressed() -> void:
    ScreenHandler.close(self)
