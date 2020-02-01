extends Area2D

signal detonation_ended

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
	elif $AnimatedSprite.animation == BoomAnimation:
		$BoomCollision.disabled = true
		queue_free()
	
