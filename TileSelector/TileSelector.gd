extends Node2D

signal tile_hovered(tile_position, buildable)
signal block_fully_created(block_type)
signal block_fully_deleted(block_type)

onready var floor_tiles = $LevelNavigation/Floor
onready var walls = $LevelNavigation/Walls
onready var build_slots = $LevelNavigation/BuildSlots

var enabled = true
var selected_tile_pos = Vector2.ZERO
var selected_tile = TileMap.INVALID_CELL

var under_block_tiles = {}

func _process(_delta):
	if !enabled:
		return

	var mouse_pos = get_global_mouse_position()
	try_getting_tile(mouse_pos, build_slots, true)
	try_getting_tile(mouse_pos, floor_tiles, false)
	try_getting_tile(mouse_pos, walls, false)


func try_getting_tile(mouse_pos, tilemap, buildable):
	var tile_pos = tilemap.world_to_map(mouse_pos)
	var tile = tilemap.get_cellv(tile_pos)
	if tile != TileMap.INVALID_CELL and tile_pos != selected_tile_pos:
		selected_tile_pos = tile_pos
		selected_tile = tile
		emit_signal("tile_hovered", tilemap.map_to_world(tile_pos) + tilemap.cell_size / 2, buildable)


func _on_Builder_create_block(position, block_type):
	if block_type == Enums.BUILDING_BLOCKS.UNDER_CONSTRUCTION:
		under_block_tiles[str(position)] = floor_tiles.get_cellv(position)
		floor_tiles.set_cellv(position, -1)
		floor_tiles.update_dirty_quadrants()
		emit_signal("block_fully_created", block_type)


func _on_Builder_delete_block(position, selected_block_type):
	if str(position) in under_block_tiles:
		floor_tiles.set_cellv(position, under_block_tiles[str(position)])
		under_block_tiles.erase(str(position))
		floor_tiles.update_dirty_quadrants()
		emit_signal("block_fully_deleted", selected_block_type)


func _on_GameState_hero_journey_started():
	enabled = false
