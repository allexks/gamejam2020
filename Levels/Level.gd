extends Node2D

export (String, FILE, "*.tscn") var Next_Scene: String

export (PackedScene) var Bomb
export (PackedScene) var Bullet

func _ready():
	$SpawnBombTimer.start(randi() % 5)
	$SpawnBulletTimer.start()
	

func _on_SpawnBombTimer_timeout():
	var bomb = Bomb.instance()
	add_child(bomb)
	
	bomb.position.x = $Area2D/Player.position.x + 40 - (randi() % 80)
	bomb.position.y = $Area2D/Player.position.y + 40 - (randi() % 80)
	$SpawnBombTimer.start(randi() % 5)


func _on_SpawnBulletTimer_timeout():
	$BulletPath/BulletPathFollower.offset = $Area2D/Player.position.x + 100 - (randi() % 200)
	
	var bullet = Bullet.instance()
	add_child(bullet)
	
	bullet.position = $BulletPath/BulletPathFollower.position
	
