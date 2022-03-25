extends Area2D

signal score

export var walk_speed = 5
export var player_index = 1

var screen_size
var initial_position_x
var initial_position_y
var initial_walk_speed = walk_speed

var up_strength = 0
var down_strength = 0

func _ready():
	screen_size = get_viewport_rect().size
	initial_position_x = position.x
	initial_position_y = position.y
	
	Serial.connect("P1_UP", self, "_on_P1_UP")
	Serial.connect("NOT_P1_UP", self, "_on_NOT_P1_UP")
	
	Serial.connect("P1_DOWN", self, "_on_P1_DOWN")
	Serial.connect("NOT_P1_DOWN", self, "_on_NOT_P1_DOWN")
	
	Serial.connect("P2_CONTROL", self, "_on_P2_CONTROL")

func _process(delta):
	var orientation = Vector2()
	
	orientation.y = ((down_strength - up_strength))
	print (orientation.y)
	
	position += walk_speed * orientation
	
	if orientation.length() > 0:
		$AnimatedSprite.animation = ("down" if orientation.y > 0 else "up")
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.frame = 1
		$AnimatedSprite.stop()
	
	position.y = clamp(position.y, 0, screen_size.y)


func _on_Player_body_entered(body):
	emit_signal("score") if body.name == "FinishLine" else $AudioStreamPlayer2D.play()
	
	position.x = initial_position_x
	position.y = initial_position_y


func _on_P1_UP():
	if player_index == 1: up_strength = 1

func _on_NOT_P1_UP():
	if player_index == 1: up_strength = 0

func _on_P1_DOWN():
	if player_index == 1: down_strength = 1

func _on_NOT_P1_DOWN():
	if player_index == 1: down_strength = 0


func _on_P2_CONTROL(value):
	value = round(float(value))
	if player_index == 2:
		var speed = abs(value / 100)
		if value < 0:
			down_strength = speed
		else:
			up_strength = speed
