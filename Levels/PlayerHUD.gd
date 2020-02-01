extends CanvasLayer

var lives setget set_lives


func set_lives(new_lives):
	if new_lives < 0 or new_lives > 3:
		return
	if new_lives == 0:
		$LivesSprite.hide()
	else:
		$LivesSprite.show()
		$LivesSprite.frame = new_lives - 1
	lives = new_lives


func _ready():
	$Mission1Sprite.hide()
	$Mission2Sprite.hide()
	$Mission3Sprite.hide()
	lives = 3


func add_mission(timeout, mission_id, mission_start, mission_end):
	if not $Mission1Sprite.started:
		$Mission1Sprite.begin(timeout, mission_id, mission_start, mission_end)
	elif not $Mission2Sprite.started:
		$Mission2Sprite.begin(timeout, mission_id, mission_start, mission_end)
	elif not $Mission3Sprite.started:
		$Mission3Sprite.begin(timeout, mission_id, mission_start, mission_end)
