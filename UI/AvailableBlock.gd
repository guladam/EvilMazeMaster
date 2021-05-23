extends HBoxContainer

onready var button = $AvailableBlockButton
onready var label = $Label
var amount = 1
var type = -1


func set_type(block_type):
	type = block_type
	

func set_amount(value):
	amount = value
	label.text = str(amount)


func set_active():
	button.pressed = true
	button.emit_signal("pressed")


func is_active():
	return button.pressed
