extends CanvasLayer

export (String, FILE, "*.tscn") var NextScene
var animation = "Expand"

var time_left = 10

func _ready():
	$StartLevel.start()
	$AnimatedSprite.play(animation)
	print("Vlizam")
	$Label.text = "%3d" % time_left




func _on_StartLevel_timeout():
	time_left = time_left - 1
	$Label.text = "%3d" % time_left
	if time_left == 0:
		Event.emit_signal("ChangeScene", NextScene)
		$StartLevel.stop()
