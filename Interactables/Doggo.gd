extends "res://Interactables/PickUp.gd"


func effect(area):
	area.add_energy(-3)
	area.interact_anim = "EnergyLost"
	self.visible = false
	if !Config.sound_enabled:
		queue_free()
	else:
		$SoundEffectPlayer.play_sound(0)
