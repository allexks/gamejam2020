extends KinematicBody2D

signal repair_cabel
signal baftata

export var DefaultSpeed = 120
export var Hp = 3
export var AnimationUp = "up"
export var AnimationDown = "down"
export var AnimationSide = "side"
export var AnimationStillUpward = "still_up"
export var AnimationStillDownward = "still_down"
export var AnimationStillSideward = "still_side"
export var AnimationWork = "work"
var animation = ""
enum Direction { UP, DOWN, RIGHT, LEFT }

var lastDirection

func _ready():
	$BloodUp.hide()
	$BloodDown.hide()

func _process(delta):

	if Input.is_action_pressed("PutCable"):
		print("pressed")
		animation = AnimationWork
		emit_signal("repair_cabel")
	else:
		animation = ""
		
	var dir = Vector2.ZERO
	dir.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	dir.y = Input.get_action_strength("Down") - Input.get_action_strength("Up")

	dir = dir.normalized()
	move_and_slide(dir * DefaultSpeed)

	if(Hp <= 0):
		queue_free()

	# Animations
	var sprite_node = $AnimatedSprite
	
	var velocity = dir.length()

	if animation == AnimationWork:
		
		pass
	elif velocity == 0:
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

	sprite_node.play(animation)
	
func Hit(up):

	Hp -= 1
	
	if up:
		$BloodUp.show()
		$BloodUp.play("default")
	else:
		$BloodDown.show()
		$BloodDown.play("default")


func _on_PlayerHUD_mission_timeout(id):
	emit_signal("baftata", id)


func _on_BloodUp_animation_finished():
	$BloodUp.hide()
	$BloodUp.stop()


func _on_BloodDown_animation_finished():
	$BloodDown.hide()
	$BloodDown.stop()
