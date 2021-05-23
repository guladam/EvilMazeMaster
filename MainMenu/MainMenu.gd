extends Control

onready var play = $Buttons/PlayButton
onready var levels = $Buttons/LevelSelectorButton
onready var quit = $Buttons/QuitButton

func _ready():
	MusicPlayer.start_music()
	GameSaver.load_progress()
	if GameSaver.current_level > -1:
		play.get_node("Label").text = "intro"
	else:
		levels.visible = false


func load_scene(scene_name):
	# warning-ignore:return_value_discarded
	get_tree().change_scene(scene_name)
	
	
func quit_game():
	get_tree().quit()


func _on_PlayButton_pressed():
	load_scene("res://Intro/Intro.tscn")


func _on_LevelSelectorButton_pressed():
	load_scene("res://LevelSelector/LevelSelector.tscn")
