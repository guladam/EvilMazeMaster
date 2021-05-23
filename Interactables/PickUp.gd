extends Area2D


func effect(_area):
	pass


func _on_PickUp_area_entered(area):
	area.just_interacted = true
	effect(area)


func delete():
	queue_free()
