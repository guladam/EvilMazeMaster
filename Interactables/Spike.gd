extends "res://Interactables/PickUp.gd"


func effect(area):
	$AnimationPlayer.play("Animate")
	area.interact_anim = "Damage"
	area.add_health(-1)
	$SoundEffectPlayer.play_sound(0)
