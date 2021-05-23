extends Node2D

export(Resource) var level_data

onready var game_state = $GameState

onready var level = $Level
onready var hero = $Hero
onready var hero_stats_ui = $HUD/GUI/HeroStats
onready var progress_tracker = $ProgressTracker
onready var gui = $HUD/GUI
onready var level_end_menu = $Menu/LevelEndWindow
onready var game_pauser = $Menu/PauseWindow/GamePauser
onready var dialogue_window = $Menu/DialogueWindow
onready var tile_selector = $Level/TileSelector
onready var builder = $Level/Builder

var current_level = 0
var current_dialogue = 0
var intro_lines = []
var further_lines = [
	["oh, i forgot..", "you can see where the hero wants to go.", "don't worry... they are dumb as a post.", "what kind of dum-dum would always pick the simplest path?", "heehee!"],
	["well, well, well...", "now let's see if how well you can do your job."]
]

func _ready():
	randomize()
	
	tile_selector.enabled = false
	builder.enabled = false
	
	MusicPlayer.fade_to_game_music()
	GameSaver.load_progress()
	
	if level_data is LevelData:
		current_level = level_data.level_index
		intro_lines = level_data.intro_lines.duplicate()
	
	game_state.connect("hero_journey_started", level, "_on_GameState_hero_journey_started")
	game_state.connect("hero_journey_started", gui, "_on_GameState_hero_journey_started")
	
	level.connect("path_modified", hero, "_on_LevelNavigaton_path_modified")
	level.connect("endpoint_reached", progress_tracker, "_on_Hero_endpoint_reached")
	level.connect("endpoint_reached", hero, "_on_Hero_endpoint_reached")
	
	hero.connect("point_reached", level, "_on_Hero_point_reached")
	hero.stat_tracker.connect("damaged", hero_stats_ui, "_on_Hero_healed_or_damaged")
	hero.stat_tracker.connect("healed", hero_stats_ui, "_on_Hero_healed_or_damaged")
	hero.stat_tracker.connect("energy_lost", hero_stats_ui, "_on_Hero_energy_changed")
	hero.stat_tracker.connect("energy_gained", hero_stats_ui, "_on_Hero_energy_changed")
	hero.stat_tracker.connect("damaged", progress_tracker, "_on_Hero_health_changed")
	hero.stat_tracker.connect("energy_lost", progress_tracker, "_on_Hero_energy_changed")
	
	level.generate_path()
	
	if intro_lines:
		dialogue_window.play_lines(intro_lines)


func restart_level():
	# warning-ignore:return_value_discarded
	game_pauser.unpause()
	get_tree().reload_current_scene()


func back_to_menu():
	# warning-ignore:return_value_discarded
	game_pauser.unpause()
	get_tree().change_scene("res://LevelSelector/LevelSelector.tscn")


func _on_ProgressTracker_level_lost():
	if current_level > GameSaver.current_level:
		GameSaver.save_progress(current_level)
		
	game_pauser.can_pause = false
	yield(get_tree().create_timer(4), "timeout")

	var lose_message = "Lost :()"
	if level_data and level_data.lose_lines.size() > 0:
		lose_message = level_data.lose_lines[randi() % level_data.lose_lines.size()]

	level_end_menu.set_message(lose_message)
	level_end_menu.visible = true
	level_end_menu.fade_in()


func _on_DialogueWindow_dialogue_ended():
	if current_dialogue == 0:
		dialogue_window.play_lines(further_lines[0])
	if current_dialogue == 1:
		level.get_node("TileSelector/LevelNavigation/Line2D").visible = true
		dialogue_window.play_lines(further_lines[1])
	if current_dialogue == 2:
		game_state.start_hero_journey()
		
	current_dialogue += 1
