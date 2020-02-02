extends Node2D

export (String, FILE, "*.tscn") var Next_Scene: String

export (PackedScene) var Bomb
export (PackedScene) var Bullet
export (PackedScene) var DestroyedCabel

export var Barracks1 = "BR1"
export var Barracks2 = "BR2"
export var Barracks3 = "BR3"
export var Medical = "MED"
export var HQ = "HQ"
export var Ammo = "AMM"

var lives = 3

var possible_wire_locations = [
	Vector2(16, 5),
	Vector2(8, 14),
	Vector2(20, 7),
	Vector2(12, 12),
	Vector2(5, 15),
	Vector2(9, 8),
	Vector2(26, 12),
	Vector2(36, 2),
	Vector2(34, 6),
	Vector2(23, 8),
	Vector2(19, 13),
	Vector2(22, 4),
	Vector2(19, 6),
	Vector2(28, 8),
	Vector2(10, 6),
]

var possible_mission_startpoints

var possible_mission_endpoints
	
# Locations of all broken wires of the level
# in tile map coordinates
var broken_wire_locations


export var mission_durations = [
	30,
	30,
	30,
	30,
	30,
	30,
	30,
	30,
	30,
	30
]

export var time_before_missions = [
	3,
	25,
	25,
	25,
	25,
	25,
	25,
	25,
	20,
	20
]

var current_mission_index = -1

var missions_accomplished = [
	false, false, false, false, false, false, false, false, false, false
]

var destroyed_cabel_instances = [
	null, null, null, null, null, null, null, null, null, null
]

var ongiong_mission_indices = []

var level_is_over = false

func _ready():
	possible_mission_startpoints = [
		Barracks2,
		HQ,
		Barracks1,
		Medical,
		HQ,
		Ammo,
		Barracks3,
		Barracks3,
		Barracks2,
		Barracks3,
		Medical,
		Barracks1,
		Barracks1,
		Barracks2,
		Barracks3
	]
	
	possible_mission_endpoints = [
		Ammo,
		Medical,
		Barracks3,
		HQ,
		Medical,
		HQ,
		HQ,
		Barracks2,
		Barracks3,
		Barracks1,
		Barracks3,
		HQ,
		Barracks3,
		Barracks3,
		Ammo
	]
	
	Event.emit_signal("EnterLevel")
	$SpawnBombTimer.start(randi() % 5)
	$SpawnBulletTimer.start()
	next_mission()
	
func _on_SpawnBombTimer_timeout():
	var bomb = Bomb.instance()
	add_child(bomb)
	
	bomb.position.x = $Player.position.x + 30 - (randi() % 60)
	bomb.position.y = $Player.position.y + 30 - (randi() % 60)
	$SpawnBombTimer.start(randi() % 5)


func _on_SpawnBulletTimer_timeout():
	$BulletPath/BulletPathFollower.offset = $Player.position.x + 100 - (randi() % 200)
	
	var bullet = Bullet.instance()
	add_child(bullet)
	
	bullet.position = $BulletPath/BulletPathFollower.position


func _on_Player_repair_cabel():
	var i = 0
	for cable in destroyed_cabel_instances:
		if cable != null and cable.is_coll:
			cable.queue_free()
			missions_accomplished[i] = true
			destroyed_cabel_instances[i] = null
			if i in ongiong_mission_indices:
				ongiong_mission_indices.remove(i)
				$Player/PlayerHUD.remove_mission(i)
			return
		i += 1


func _on_SpawnNextMissionTimer_timeout():
	$SpawnNextMissionTimer.stop()
	next_mission()


func next_mission():
	if level_is_over:
		return
	
	spawn_next_mission()
	
	current_mission_index += 1

	start_next_mission_timer()


func start_next_mission_timer():
	$SpawnNextMissionTimer.start(time_before_missions[current_mission_index])

func spawn_next_mission():
	if current_mission_index < 0:
		return

	var random_index = randi() % len(possible_wire_locations)
	var tile_position = possible_wire_locations[random_index]
	
	var world_position = $TileMapInside.map_to_world(tile_position)
	
	var new_cabel = DestroyedCabel.instance()
	destroyed_cabel_instances[current_mission_index] = new_cabel
	add_child(new_cabel)
	
	new_cabel.position = world_position
	
	possible_wire_locations.remove(random_index)
	
	
	$Player/PlayerHUD.add_mission(
			mission_durations[current_mission_index], 
			current_mission_index, 
			possible_mission_startpoints[random_index], 
			possible_mission_endpoints[random_index]
	)
	
	ongiong_mission_indices.append(current_mission_index)

func win_level():
	Event.emit_signal("EndLevel")
	level_is_over = true
	print("koito igrai picheli")
	# TODO


func lose_level():
	level_is_over = true
	Event.emit_signal("EndLevel")
	print("Otidi konq u rqkata")
	Event.emit_signal("ChangeScene", Next_Scene)


func _on_Player_baftata(id):
	print(id)
	lives -= 1
	$Player/PlayerHUD.lives -= 1
	ongiong_mission_indices.remove(id)
	if lives == 0:
		lose_level()
	


func _on_MGTileAnimator_timeout():
	var x = 1
	var y = 4
	var texture = $TileMapStructures.get_cell(x, y)
	var new_texture = 10 if texture == 9 else 9
	$TileMapStructures.set_cell(x, y, new_texture)
