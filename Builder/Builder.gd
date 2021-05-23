extends Node2D

signal create_block(position, selected_block_type)
signal delete_block(position, selected_block_type)

export(Resource) var level_data

onready var cursor = $Indicator
onready var cursor_anim = $Indicator/AnimationPlayer
onready var interactables = $Interactables
onready var sound = $SoundEffectPlayer

var doggo_block = preload("res://Interactables/Doggo.tscn")
var spike_block = preload("res://Interactables/Spike.tscn")

var enabled = true
var selected_block_type = -1
var buildslots_tilemap = null
var selected_tile_pos = Vector2.ZERO
var can_build = false

var available_blocks = {}
var built_blocks = {}


func _ready():
	if level_data is LevelData:
		for i in range(len(level_data.block_types)):
			if i <= len(level_data.block_number):
				available_blocks[level_data.block_types[i]] = level_data.block_number[i]


func _unhandled_input(event):
	if !enabled or selected_tile_pos == Vector2.ZERO:
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == 1 and can_build:
		create_block()
	if event is InputEventMouseButton and event.pressed and event.button_index == 2 and can_build:
		delete_block()


func show_cursor(pos):
	cursor.global_position = pos
	cursor.visible = true
	cursor_anim.play("animate")


func hide_cursor():
	cursor.visible = false
	cursor_anim.stop()


func create_interactable_block(scene, pos):
	var interactable = scene.instance()
	interactables.add_child(interactable)
	interactable.position = buildslots_tilemap.map_to_world(pos) + buildslots_tilemap.cell_size / 2
	
	built_blocks[pos] = [selected_block_type, interactable]


func create_block():
	if !buildslots_tilemap or selected_block_type == -1:
		return
	if not selected_block_type in available_blocks or available_blocks[selected_block_type] == 0:
		return

	var tile_pos = buildslots_tilemap.world_to_map(selected_tile_pos)
	
	if tile_pos in built_blocks:
		delete_block(false)
	
	match selected_block_type:
		Enums.BUILDING_BLOCKS.UNDER_CONSTRUCTION:
			buildslots_tilemap.set_cellv(tile_pos, 1)
			built_blocks[tile_pos] = [selected_block_type, 1]
			sound.play_sound(0)
		Enums.BUILDING_BLOCKS.DOGGO:
			buildslots_tilemap.set_cellv(tile_pos, 2)
			create_interactable_block(doggo_block, tile_pos)
			sound.play_sound(1)
		Enums.BUILDING_BLOCKS.SPIKE:
			buildslots_tilemap.set_cellv(tile_pos, 3)
			create_interactable_block(spike_block, tile_pos)
			sound.play_sound(2)
	
	available_blocks[selected_block_type] -= 1
	emit_signal("create_block", tile_pos, selected_block_type)


func delete_block(play_sound=true):
	if !buildslots_tilemap:
		return

	var tile_pos = buildslots_tilemap.world_to_map(selected_tile_pos)
	buildslots_tilemap.set_cellv(tile_pos, 0)
	
	if !tile_pos in built_blocks:
		return
	
	var block_data = built_blocks[tile_pos]
	match block_data[0]:
		Enums.BUILDING_BLOCKS.DOGGO:
			block_data[1].queue_free()
		Enums.BUILDING_BLOCKS.SPIKE:
			block_data[1].queue_free()
	
	if play_sound:
		sound.play_sound(3)
	available_blocks[built_blocks[tile_pos][0]] += 1
	emit_signal("delete_block", tile_pos, built_blocks[tile_pos][0])
	built_blocks.erase(tile_pos)


func _on_TileHovered(tile_pos, buildable):
	if !enabled:
		return

	show_cursor(tile_pos)
	selected_tile_pos = tile_pos
	can_build = buildable
	
	if !buildable:
		cursor.modulate = Color(1, 0, 0, 1)
	else:
		cursor.modulate = Color(1, 1, 1, 1)


func _on_AvailableBlock_selected(block_type):
	selected_block_type = block_type


func _on_GameState_hero_journey_started():
	hide_cursor()
	enabled = false
