extends Node

var save_file = "user://progress.save"
var current_level = -1


func save_progress(level):
	var file = File.new()
	file.open(save_file, File.WRITE)
	file.store_var(level)
	file.close()


func load_progress():
	var file = File.new()
	if file.file_exists(save_file):
		file.open(save_file, File.READ)
		current_level = file.get_var()
		file.close()
	else:
		current_level = -1
