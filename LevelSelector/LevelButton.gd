extends TextureButton


onready var label = $Label
var level_number = 0

func set_level_number(number):
	level_number = number
	label.text = str(number)


func hide_level_number():
	label.visible = false


# warning-ignore:return_value_discarded
func _on_LevelButton_pressed():
	if level_number > 0:
		get_tree().change_scene("res://LevelScenes/Level" + str(level_number) + ".tscn")
