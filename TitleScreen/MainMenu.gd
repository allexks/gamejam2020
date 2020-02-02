extends CanvasLayer

export (String, FILE, "*.tscn") var First_Level: String

func _ready()->void:
	Event.MainMenu = true
	guiBrain.gui_collect_focusgroup()
	if Settings.HTML5:
		$"BG/MarginContainer/VBoxMain/HBoxContainer/ButtonContainer/Exit".visible = false
	#Localization
	Settings.connect("ReTranslate", self, "retranslate")
	retranslate()

func _process(delta):
	$BG.visible = !Event.Options

func _exit_tree()->void:
	Event.MainMenu = false				#switch bool for easier pause menu detection and more
	guiBrain.gui_collect_focusgroup()	#Force re-collect buttons because main meno wont be there

func _on_NewGame_pressed()->void:
	Event.emit_signal("NewGame")
	Event.emit_signal("ButtonPressed")
	Event.emit_signal("ChangeScene", First_Level)

func _on_Options_pressed()->void:
	Event.Options = true
	Event.emit_signal("ButtonPressed")

func _on_Exit_pressed()->void:
	Event.emit_signal("Exit")
	Event.emit_signal("ButtonPressed")

#Localization
func retranslate()->void:
	find_node("NewGame").text = tr("NEW_GAME")
	find_node("Options").text = tr("OPTIONS")
	find_node("Exit").text = tr("EXIT")
