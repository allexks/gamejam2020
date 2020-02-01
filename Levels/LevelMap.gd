extends CanvasLayer

export (String, FILE, "*.tscn") var NextScene

func _on_BeginLevelButton_button_up():
	Event.emit_signal("ChangeScene", NextScene)
