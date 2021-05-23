extends TextureButton

signal button_press_finished()

onready var label = $Label


func _on_PlayButton_button_down():
	label.rect_position.y += 4


func _on_PlayButton_button_up():
	label.rect_position.y -= 4


func _on_SoundEffectPlayer_finished():
	emit_signal("button_press_finished")


func _on_MainMenuButton_pressed():
	if !Config.sound_enabled:
		emit_signal("button_press_finished")
	$SoundEffectPlayer.play_sound(0)
