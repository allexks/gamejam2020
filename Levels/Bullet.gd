extends KinematicBody2D

export var Speed = 1000.0

var direction = Vector2(0, 1) # down


func _process(delta):
	move_and_slide(direction * Speed)
