extends CollisionShape2D
signal pl_entered

func _on_KinematicBody2D_body_entered(body):
	if(body.get_name() == "Player"):
		emit_signal("pl_entered")
