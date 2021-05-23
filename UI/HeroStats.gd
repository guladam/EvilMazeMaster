extends MarginContainer


export(Resource) var level_data

onready var energy_label = $MarginContainer/CenterContainer/VBoxContainer/EnergyBar/Label
onready var hp_bar = $MarginContainer/CenterContainer/VBoxContainer/HpBar

var hp = preload("res://UI/HP.tscn")

func _ready():
	if level_data is LevelData:
		if level_data.energy > -1:
			energy_label.text = str(level_data.energy)
		if level_data.health > -1:
			for _i in range(level_data.health):
				var new_hp = hp.instance()
				hp_bar.add_child(new_hp)


func _on_Hero_healed_or_damaged(new_health):
	var child_count = hp_bar.get_child_count()
	for i in range(child_count):
		var child = hp_bar.get_child(i)
		if i < new_health:
			child.set_full()
		else:
			child.set_empty()


func _on_Hero_energy_changed(new_energy):
	energy_label.text = str(new_energy)
