extends KinematicBody2D

signal repair_cabel

export var DefaultSpeed = 120

export var AnimationUp = "up"
export var AnimationDown = "down"
export var AnimationSide = "side"
export var AnimationStillUpward = "still_up"
export var AnimationStillDownward = "still_down"
export var AnimationStillSideward = "still_side"

enum Direction { UP, DOWN, RIGHT, LEFT }

var lastDirection

func _process(delta):
	if Input.is_action_pressed("PutCable"):
		emit_signal("repair_cabel")

	var dir = Vector2.ZERO
	dir.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	dir.y = Input.get_action_strength("Down") - Input.get_action_strength("Up")

	if(Input.is_action_just_pressed("PutCable")):
		emit_signal("repair_cabel")

	dir = dir.normalized()
	move_and_slide(dir * DefaultSpeed)

	# Animations
	var sprite_node = $AnimatedSprite
	var animation = ""
	var velocity = dir.length()
	
	if velocity == 0:
		match lastDirection:
			Direction.UP:
				animation = AnimationStillUpward
			Direction.DOWN:
				animation = AnimationStillDownward
			Direction.RIGHT:
				animation = AnimationStillSideward
				sprite_node.flip_h = false
			Direction.LEFT:
				animation = AnimationStillSideward
				sprite_node.flip_h = true
			_:
				animation = AnimationStillDownward
	elif velocity > 0:
		if dir.x > 0:
			lastDirection = Direction.RIGHT
			animation = AnimationSide
			sprite_node.flip_h = false
		elif dir.x < 0:
			lastDirection = Direction.LEFT
			animation = AnimationSide
			sprite_node.flip_h = true
		elif dir.y > 0:
			lastDirection = Direction.DOWN
			animation = AnimationDown
		elif dir.y < 0:
			lastDirection = Direction.UP
			animation = AnimationUp

	print(animation)
	sprite_node.play(animation)
