extends Node

export(NodePath) var pause_menu_node

onready var pause_menu = get_node(pause_menu_node)
var paused = false
var can_pause = true

func _input(event):
	if can_pause and event is InputEventKey and event.is_action_pressed("pause"):
		if !paused:
			pause()
			pause_menu.visible = true
			pause_menu.fade_in()
		else:
			pause_menu.fade_out()


func pause():
	get_tree().paused = true


func unpause():
	get_tree().paused = false


func _on_PauseTween_tween_all_completed():
	if paused:
		pause_menu.visible = false
		unpause()
	paused = !paused
