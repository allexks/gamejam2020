extends Node2D

export (String, FILE, "*.tscn") var Next_Scene: String
var index_one = 0
var index_two = 0
var index_three = 0
export (PackedScene) var Bomb
export (PackedScene) var Bullet
export (PackedScene) var DestroyedCabel
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
	
# Locations of all broken wires of the level
# in tile map coordinates
var broken_wire_locations

# Max time in second before the next mission starts
export var time_between_missions = [
	10,
	15,
	20,
	
]

var current_mission_index = -1

var missions_accomplished = [
	false, false, false
]

var destroyed_cabel_instances = [
	null, null, null
]

var level_is_over = false

func _ready():
	index_one = randi() % len(possible_wire_locations)
	index_two = randi() % len(possible_wire_locations)
	index_three = randi() % len(possible_wire_locations)

	broken_wire_locations = [
		possible_wire_locations[index_one],
		possible_wire_locations[index_two],
		possible_wire_locations[index_three],
	]
	
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
			next_mission()
			return
		i += 1


func _on_SpawnNextMissionTimer_timeout():
	$SpawnNextMissionTimer.stop()
	next_mission(true)


func next_mission(lose_if_no_next = false):
	if level_is_over:
		return
	
	current_mission_index += 1
	
	if current_mission_index >= len(time_between_missions):
		if lose_if_no_next:
			lose_level()
			return
		
		for mission_accomplished in missions_accomplished:
			if not mission_accomplished:
				return
		
		win_level()
		return

	start_next_mission_timer()
	spawn_next_mission()


func start_next_mission_timer():
	$SpawnNextMissionTimer.start(time_between_missions[current_mission_index])

func spawn_next_mission():
	var tile_position = broken_wire_locations[current_mission_index]
	
	var world_position = $TileMapInside.map_to_world(tile_position)
	
	var new_cabel = DestroyedCabel.instance()
	destroyed_cabel_instances[current_mission_index] = new_cabel
	add_child(new_cabel)
	
	new_cabel.position = world_position


func win_level():
	level_is_over = true
	print("koito igrai picheli")
	# TODO


func lose_level():
	level_is_over = true
	print("Otidi konq u rqkata")
	# TODO
