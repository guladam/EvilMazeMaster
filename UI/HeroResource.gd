extends Control


onready var full = $Full
onready var empty = $Empty


func toggle():
	empty.visible = !empty.visible
	full.visible = !full.visible


func set_empty():
	empty.visible = true
	full.visible = false


func set_full():
	empty.visible = false
	full.visible = true
