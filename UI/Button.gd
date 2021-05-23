extends TextureButton

signal button_press_finished()

onready var label = $Label


func _on_Button_button_down():
	label.rect_position.y += 2


func _on_Button_button_up():
	label.rect_position.y -= 2


func _on_Button_pressed():
	if !Config.sound_enabled:
		emit_signal("button_press_finished")
	$SoundEffectPlayer.play_sound(0)


func _on_SoundEffectPlayer_finished():
	emit_signal("button_press_finished")
