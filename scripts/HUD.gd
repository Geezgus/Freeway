extends CanvasLayer


signal restart


#func _ready():
#	pass # Replace with function body.

func _on_Button_pressed():
	emit_signal("restart")
