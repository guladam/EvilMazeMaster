extends Control


func _on_MainMenuButton_button_press_finished():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://MainMenu/MainMenu.tscn")
