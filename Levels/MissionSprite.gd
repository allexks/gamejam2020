extends AnimatedSprite

signal mission_timeout

var mission_id

var started = false

func begin(initial_time_left, id, mission_from, mission_to):
	play("default")
	$SecondsLeft.text = "%3d" % initial_time_left
	mission_id = id
	$StartStructureName.text = mission_from
	$EndStructureName.text = mission_to
	show()
	$Timer.start()
	started = true


func end():
	hide()
	$Timer.stop()
	stop()
	started = false


func _on_Timer_timeout():
	var time_left = int($SecondsLeft.text)
	$SecondsLeft.text = "%3d" % (time_left - 1)
	if time_left == 0:
		end()
		emit_signal("mission_timeout", mission_id)

