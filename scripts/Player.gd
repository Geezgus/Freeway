extends Area2D

signal score

export var walk_speed = 5
export var player = 1

var screen_size
var initial_position_x
var initial_position_y
var initial_walk_speed = walk_speed

func _ready():
	screen_size = get_viewport_rect().size
	initial_position_x = position.x
	initial_position_y = position.y

func _process(delta):
	var orientation = Vector2()
	
	orientation.y = (Input.get_action_strength("p"+str(player)+"_down") - # px_down
					 Input.get_action_strength("p"+str(player)+"_up"))    # px_up
	
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
