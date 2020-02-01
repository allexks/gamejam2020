extends Area2D

export (PackedScene) var Cabel
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _process(delta):
	if(Input.is_action_just_pressed("PutCable") and $StaticBody2D.is_coll):
		$StaticBody2D.queue_free()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
