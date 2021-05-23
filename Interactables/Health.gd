extends "res://Interactables/PickUp.gd"


func effect(area):
	area.add_health(1)
	area.interact_anim = "Heal"
	self.visible = false
	if !Config.sound_enabled:
		queue_free()
	else:
		$SoundEffectPlayer.play_sound(0)
