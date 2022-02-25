extends RigidBody2D

func _ready():
	var car_types_count = $AnimatedSprite.frames.get_frame_count("default")
	var car_index = randi() % car_types_count
	$AnimatedSprite.frame = car_index


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func flip(h: bool, v: bool):
	$AnimatedSprite.flip_h = h
	$AnimatedSprite.flip_v = v
