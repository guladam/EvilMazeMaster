extends Node2D

export(Resource) var level_data

onready var game_state = $GameState
onready var level = $Level
onready var tile_selector = $Level/TileSelector
onready var builder = $Level/Builder
onready var cam_panner = $CameraPanner
onready var hero = $Hero
onready var hero_stats_ui = $HUD/GUI/HeroStats
onready var progress_tracker = $ProgressTracker
onready var available_blocks_gui = $HUD/GUI/AvailableBlocks
onready var gui = $HUD/GUI
onready var level_end_menu = $Menu/LevelEndWindow
onready var game_pauser = $Menu/PauseWindow/GamePauser
onready var dialogue_window = $Menu/DialogueWindow

var current_level = 0
var intro_lines = []

func _ready():
	randomize()
	
	MusicPlayer.fade_to_game_music()
	GameSaver.load_progress()
	
	if level_data is LevelData:
		current_level = level_data.level_index
		intro_lines = level_data.intro_lines.duplicate()
	
	game_state.connect("hero_journey_started", tile_selector, "_on_GameState_hero_journey_started")
	game_state.connect("hero_journey_started", builder, "_on_GameState_hero_journey_started")
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
	
	gui.start_button.connect("button_press_finished", self, "start_hero")
	
	available_blocks_gui.connect("block_selected", builder, "_on_AvailableBlock_selected")
	available_blocks_gui.select_first_one()
	
	builder.connect("create_block", available_blocks_gui, "_on_Builder_block_created")
	builder.connect("delete_block", available_blocks_gui, "_on_Builder_block_deleted")
	level.generate_path()
	
	if intro_lines:
		dialogue_window.play_lines(intro_lines)
		game_pauser.can_pause = false
		game_pauser.pause()


func start_hero():
	cam_panner.snap_to_target(hero)
	gui.start_button.disabled = true
	gui.start_button.visible = false


func _on_CameraPanner_snapped_to_target():
	game_state.start_hero_journey()


func restart_level():
	# warning-ignore:return_value_discarded
	game_pauser.unpause()
	get_tree().reload_current_scene()


func back_to_menu():
	game_pauser.unpause()
	if current_level >= 9:
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://EndScreen/EndScreen.tscn")
	else:
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://LevelSelector/LevelSelector.tscn")


func _on_ProgressTracker_level_won():
	if current_level > GameSaver.current_level:
		GameSaver.save_progress(current_level)
	
	var win_message = "WON :)"
	if level_data and level_data.win_lines.size() > 0:
		win_message = level_data.win_lines[randi() % level_data.win_lines.size()]
	
	game_pauser.can_pause = false
	yield(get_tree().create_timer(4), "timeout")
	level_end_menu.set_message(win_message)
	level_end_menu.visible = true
	level_end_menu.fade_in()


func _on_ProgressTracker_level_lost():
	game_pauser.can_pause = false
	yield(get_tree().create_timer(4), "timeout")

	var lose_message = "Lost :()"
	if level_data and level_data.lose_lines.size() > 0:
		lose_message = level_data.lose_lines[randi() % level_data.lose_lines.size()]

	level_end_menu.set_message(lose_message)
	level_end_menu.visible = true
	level_end_menu.fade_in()


func _on_DialogueWindow_dialogue_ended():
	game_pauser.unpause()
	game_pauser.can_pause = true
