extends ColorRect

export(float) var animation_speed = 0.5

onready var message = $Background/MarginContainer/Label
onready var window = $Background
onready var tween = $Tween
onready var fade_in_pos = $FadeInPosition
onready var fade_out_pos = $FadeOutPosition


func set_message(text):
	message.text = str(text)


func tween_ui_color(object, start_color, end_color):
	tween.interpolate_property(object, "modulate", start_color, end_color, 
	animation_speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)


func tween_ui_position(object, start, end):
	tween.interpolate_property(object, "rect_position:y", start.rect_position.y, end.rect_position.y, 
	animation_speed, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	

func fade_in():
	if tween.is_active():
		return
	tween_ui_color(self, Color(1, 1, 1, 0), Color(1, 1, 1, 1))
	tween_ui_color(window, Color(1, 1, 1, 0), Color(1, 1, 1, 1))
	tween_ui_position(window, fade_out_pos, fade_in_pos)
	tween.start()


func fade_out():
	if tween.is_active():
		return
	tween_ui_color(self, Color(1, 1, 1, 1), Color(1, 1, 1, 0))
	tween_ui_color(window, Color(1, 1, 1, 1), Color(1, 1, 1, 0))
	tween_ui_position(window, fade_in_pos, fade_out_pos)
	tween.start()
