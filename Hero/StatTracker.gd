extends Node2D

signal damaged(health)
signal healed(health)
signal energy_lost(energy)
signal energy_gained(energy)

export(Resource) var level_data

var energy = -1
var health = -1

func _ready():
	if level_data is LevelData:
		energy = level_data.energy	
		health = level_data.health


func change_health(amount):
	if health > -1 and amount > 0:
		health = min(health + amount, level_data.health)
		emit_signal("healed", health)
	if health > -1 and amount < 0:
		health = max(health + amount, 0)
		emit_signal("damaged", health)


func change_energy(amount):
	if energy > -1 and amount > 0:
		energy = min(energy + amount, level_data.energy)
		emit_signal("energy_gained", energy)
	if energy > -1 and amount < 0:
		energy = max(energy + amount, 0)
		emit_signal("energy_lost", energy)
