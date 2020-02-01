extends KinematicBody2D
signal repair_cabel
var speed = 2 * 60

func _process(delta):
	var dir = Vector2.ZERO
	dir.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	dir.y = Input.get_action_strength("Down") - Input.get_action_strength("Up")
	
	if(Input.is_action_just_pressed("PutCable")):
		emit_signal("repair_cabel")
	
	dir = dir.normalized()
	move_and_slide(dir * speed)
	

	
