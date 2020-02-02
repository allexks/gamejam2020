extends KinematicBody2D

export var Speed = 1000.0
export (PackedScene) var player_var
var is_coll = false
var direction = Vector2(0, 1) # down
signal hit_pl

func _process(delta):
	move_and_slide(direction * Speed)




func _on_Area2D_body_entered(body):
	if(body.get_name() == "Player"):
		if(body.animation == body.AnimationStillUpward or body.animation == body.AnimationStillDownward or body.animation == body.AnimationStillSideward):
			return
		else:
			queue_free()
			body.Hit()
