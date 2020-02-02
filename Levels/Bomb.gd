extends Area2D



export var FallAnimation = "fall"
export var BoomAnimation = "boom"

# Called when the node enters the scene tree for the first time.
func _ready():
	$BoomCollision.disabled = true
	$AnimatedSprite.play(FallAnimation)


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == FallAnimation:
		$BoomCollision.disabled = false
		$AnimatedSprite.play(BoomAnimation)
		Event.emit_signal("Boom")
	elif $AnimatedSprite.animation == BoomAnimation:
		$BoomCollision.disabled = true
		queue_free()
	


func _on_Bomb_body_entered(body):
	if(body.get_name() == "Player"):
		body.Hit()
		body.Hit()
		body.Hit()
