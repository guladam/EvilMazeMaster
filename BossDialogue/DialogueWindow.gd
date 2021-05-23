extends Control

signal dialogue_ended()

export(float) var char_per_second = 20

onready var portrait = $Portrait
onready var portrait_anim = $Portrait/Sprite/AnimationPlayer
onready var dialogue_text = $NinePatchRect/Label
onready var tween = $Tween

var can_progress = false
var active = false
var all_lines = []


func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		proceed_dialogue()
	if active and event.is_action_pressed("dialogue_skip"):
		proceed_dialogue()
	if active and event.is_action_pressed("dialogue_skip_all"):
		end_dialogue()


func proceed_dialogue():
	if active and can_progress:
		play_current_line()
	elif active:
		tween.seek(tween.get_runtime())


func play_lines(lines):
	all_lines = lines
	active = true
	play_current_line()


func end_dialogue():
	can_progress = false
	active = false
	self.visible = false
	emit_signal("dialogue_ended")


func play_current_line():
	if all_lines:
		play_dialogue(all_lines.pop_front())
	else:
		end_dialogue()


func play_dialogue(line):
	self.visible = true
	can_progress = false
	dialogue_text.text = line
	var seconds = ceil(len(line) / char_per_second)
	tween.interpolate_property(dialogue_text, "percent_visible", 0.0, 1.0,
		seconds, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	portrait_anim.play("Talk")


func _on_Tween_tween_all_completed():
	can_progress = true
	portrait_anim.stop()
	yield(get_tree().create_timer(0.25), "timeout")
	portrait_anim.play("Smile")
