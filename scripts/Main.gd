extends Node

export var max_points = 5
export var slow_min_speed = 300
export var fast_min_speed = 600

const CAR_SCENE = preload("res://scenes/Car.tscn")

var slow_lanes_to_right = [544, 438, 384]
var slow_lanes_to_left = [324, 216, 160]

var fast_lanes_to_right = [600, 488]
var fast_lanes_to_left = [272, 104]

var scoreboards = [0, 0]

func _ready():
	for _player in get_children(): if "Player" in _player.name:
		_player.position = Vector2(_player.initial_position_x, _player.initial_position_y)
		_player.walk_speed = _player.initial_walk_speed

	$AudioThemeSong.play()

	$TimerFastCars.start()
	$TimerSlowCars.start()

	$HUD/Message.visible = false
	$HUD/Scoreboard.text = "0"
	$HUD/Scoreboard2.text = "0"
	$HUD/Button.visible = false


func _on_TimerSlowCars_timeout():
	make_car(slow_lanes_to_right, slow_min_speed, slow_min_speed + 10, -10, true)
	make_car(slow_lanes_to_left, slow_min_speed, slow_min_speed + 10, 1290, false)
	pass


func _on_TimerFastCars_timeout():
	make_car(fast_lanes_to_right, fast_min_speed, fast_min_speed + 10, -10, true)
	make_car(fast_lanes_to_left, fast_min_speed, fast_min_speed + 10, 1290, false)
	pass


func make_car(lanes, min_speed, max_speed, start_point, goes_right):
	var car = CAR_SCENE.instance()
	var lane = lanes[randi() % lanes.size()]
	var orientation = 1 if goes_right else -1

	car.flip(false, not goes_right)	

	add_child(car)

	car.position = Vector2(start_point, lane)
	car.linear_velocity = Vector2(orientation * rand_range(min_speed, max_speed), 0)
	car.linear_damp = -1


func pause_after_win(player):
	$AudioThemeSong.stop()
	$AudioVictory.play()

	$TimerFastCars.stop()
	$TimerSlowCars.stop()

	$HUD/Message.visible = true
	$HUD/Button.visible = true
	$HUD/Message.render("Player "+str(player.player_index)+" wins!")

	for _player in get_children(): if "Player" in _player.name:
		_player.walk_speed = 0


func _on_Player_score():
	scoreboards[0] += 1
	$HUD/Scoreboard.text = str(scoreboards[0])
	pause_after_win($Player) if scoreboards[0] >= max_points else $AudioScore.play()


func _on_Player2_score():
	scoreboards[1] += 1
	$HUD/Scoreboard2.text = str(scoreboards[1])
	pause_after_win($Player2) if scoreboards[1] >= max_points else $AudioScore.play()


func _on_HUD_restart():
	scoreboards[0] = 0
	scoreboards[1] = 0
	_ready()
