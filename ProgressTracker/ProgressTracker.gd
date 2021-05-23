extends Node2D

signal level_won
signal level_lost

func _on_Hero_energy_changed(amount):
	if amount == 0:
		emit_signal("level_won")


func _on_Hero_health_changed(amount):
	if amount == 0:
		emit_signal("level_won")


func _on_Hero_endpoint_reached():
	emit_signal("level_lost")
