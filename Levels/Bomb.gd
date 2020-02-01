extends Area2D

signal detonation_ended

# Called when the node enters the scene tree for the first time.
func _ready():
	$BoomCollision.disabled = true


func _on_FallTimer_timeout():
	$BoomCollision.disabled = false
	$EndOfDamageTimer.start()


func _on_EndOfDamageTimer_timeout():
	$BoomCollision.disabled = true
	emit_signal("detonation_ended")
