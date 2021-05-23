extends Control

export(float) var animation_speed = 0.5

onready var hero_stats = $HeroStats
onready var available_blocks = $AvailableBlocks
onready var start_button = $StartButton
onready var tween = $Tween
onready var fade_in_pos = $FadeInPosition
onready var fade_out_pos = $FadeOutPosition

var fade_in_alpha = Color(1, 1, 1, 1)
var fade_out_alpha = Color(1, 1, 1, 0)

var can_toggle_ui = true
var ui_on = true


func _ready():
	var y_pos = hero_stats.rect_position.y + hero_stats.rect_size.y
	available_blocks.rect_position.y = y_pos + 7
	var y_pos_2 = available_blocks.rect_position.y + available_blocks.rect_size.y
	start_button.rect_position.y = y_pos_2 + 3


func _input(event):
	if event.is_action_pressed("start"):
		start_button.emit_signal("pressed")
		start_button.disabled = true
		start_button.visible = false
	if can_toggle_ui and event.is_action_pressed("toggle_ui") and !tween.is_active():
		if ui_on:
			tween_ui(fade_in_pos, fade_out_pos, fade_in_alpha, fade_out_alpha)
		else:
			tween_ui(fade_out_pos, fade_in_pos, fade_out_alpha, fade_in_alpha)


func tween_ui(start, end, start_color, end_color):
	tween.interpolate_property(self, "rect_position", start.position, end.position, 
	animation_speed, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.interpolate_property(self, "modulate", start_color, end_color, 
	animation_speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
	ui_on = !ui_on


func _on_GameState_hero_journey_started():
	if !ui_on:
		tween_ui(fade_out_pos, fade_in_pos, fade_out_alpha, fade_in_alpha)
	can_toggle_ui = false
