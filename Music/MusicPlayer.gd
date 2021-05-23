extends Node


onready var anim = $AnimationPlayer
onready var menu = $AudioStreamPlayerMenu
onready var game = $AudioStreamPlayerGame

var current = null

func start_music():
	if !current:
		current = menu
		play_current()


func play_current():
	current.volume_db = -4
	current.play()


func set_music(value):
	if value and current:
		play_current()
	elif current:
		current.stop()


func fade_to_menu_music():
	if !Config.music_enabled or current == menu:
		return

	anim.play("FadeToMenu")
	current = menu


func fade_to_game_music():
	if !Config.music_enabled or current == game:
		return

	anim.play("FadeToGame")
	current = game
