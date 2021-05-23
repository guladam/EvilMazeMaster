extends CenterContainer

export(int) var levels = 20

onready var grid = $VBoxContainer/GridContainer
var level_button = preload("res://LevelSelector/LevelButton.tscn")


func _ready():
	GameSaver.load_progress()
	MusicPlayer.fade_to_menu_music()
	for i in range(levels):
		var new_level = level_button.instance()
		grid.add_child(new_level)
		new_level.set_level_number(i+1)
		if i > 0 and i > GameSaver.current_level:
			new_level.hide_level_number()
			new_level.disabled = true


# warning-ignore:return_value_discarded
func _on_MainMenuButton_pressed():
	get_tree().change_scene("res://MainMenu/MainMenu.tscn")
