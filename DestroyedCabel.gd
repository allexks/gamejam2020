

extends KinematicBody2D

var is_coll = false


func _on_Area2D_body_entered(body):
	is_coll = true;
	print("Enters" + body.get_name() + " " + str(is_coll))


func _on_Area2D_body_exited(body):
	is_coll = false;
	print("Exits" + body.get_name() + " " + str(is_coll))
