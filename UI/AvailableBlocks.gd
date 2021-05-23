extends MarginContainer

signal block_selected(block_type)

export(Resource) var level_data

onready var block_container = $MarginContainer/CenterContainer/AvailableBlocksContainer

var uc_block = preload("res://UI/UnderConstructionBlock.tscn")
var doggo_block = preload("res://UI/DoggoBlock.tscn")
var dumbbell_block = preload("res://UI/DumbbellBlock.tscn")
var spike_block = preload("res://UI/SpikeBlock.tscn")

var blocks = {}
var block_scenes = {
	Enums.BUILDING_BLOCKS.UNDER_CONSTRUCTION: uc_block,
	Enums.BUILDING_BLOCKS.DOGGO: doggo_block,
	Enums.BUILDING_BLOCKS.DUMBBELL: dumbbell_block,
	Enums.BUILDING_BLOCKS.SPIKE: spike_block
}

# Called when the node enters the scene tree for the first time.
func _ready():
	if level_data is LevelData:
		for i in range(len(level_data.block_types)):
			if i <= len(level_data.block_number):
				blocks[level_data.block_types[i]] = level_data.block_number[i]

	for block in blocks.keys():
		var new_block = block_scenes[block].instance()
		block_container.add_child(new_block)
		new_block.set_amount(blocks[block])
		new_block.set_type(block)
		new_block.button.connect("pressed", self, "_on_AvailableBlockButton_pressed")


func select_first_one():
	if block_container.get_child_count() > 0:
		block_container.get_child(0).set_active()


func _on_AvailableBlockButton_pressed():
	var selected = -1
	for block in block_container.get_children():
		if block.is_active():
			selected = block.type
	
	if selected > -1:
		emit_signal("block_selected", selected)


func _on_Builder_block_created(_tile_pos, type):
	for block in block_container.get_children():
		if block.type == type:
			block.set_amount(block.amount - 1)


func _on_Builder_block_deleted(_tile_pos, type):
	for block in block_container.get_children():
		if block.type == type:
			block.set_amount(block.amount + 1)
