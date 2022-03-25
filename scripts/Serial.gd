extends Node

const serial_res = preload("res://bin/gdserial.gdns")

var serial_port = serial_res.new()
var is_port_open = false
var text = ""

signal P1_UP
signal NOT_P1_UP
signal P1_DOWN
signal NOT_P1_DOWN

signal P2_CONTROL(value)

# Called when the node enters the scene tree for the first time.
func _ready():
	is_port_open = serial_port.open_port('COM3', 115200)
	print(is_port_open)


func _process(delta):
		if is_port_open:
			var message = serial_port.read_text()
			if message.length() > 0:
				message = message.replace("\r", "")
				message = message.replace("\n", "")
				
				if message == "P1_UP":
					emit_signal("P1_UP")
				elif message == "!P1_UP":
					emit_signal("NOT_P1_UP")
				elif message == "P1_DOWN":
					emit_signal("P1_DOWN")
				elif message == "!P1_DOWN":
					emit_signal("NOT_P1_DOWN")
				elif "P2_" in message:
					message = message.replace("P2_", "")
					emit_signal("P2_CONTROL", message)
				else: print("Unknown Command")
