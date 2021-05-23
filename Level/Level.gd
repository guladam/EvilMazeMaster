extends Node2D

signal path_generated(path)
signal path_modified(path)
signal endpoint_reached()

onready var start = $StartPoint
onready var end = $EndPoint
onready var tile_selector = $TileSelector
onready var builder = $Builder
onready var nav = $TileSelector/LevelNavigation
onready var line = $TileSelector/LevelNavigation/Line2D

var path


func _ready():
	tile_selector.connect("tile_hovered", builder, "_on_TileHovered")
	builder.buildslots_tilemap = tile_selector.build_slots


func generate_path():
	path = nav.get_simple_path(start.global_position, end.global_position, false)
	emit_signal("path_generated", path)
	show_path()


func show_path():
	line.points = path
	line.remove_point(len(path)-1)


func hide_path():
	line.points = []


func _on_Hero_point_reached():
	path.remove(0)
	if path.size() == 0:
		emit_signal("endpoint_reached")
	else:
		emit_signal("path_modified", path)


func _on_TileSelector_block_fully_created_or_deleted(block_type):
	if block_type == Enums.BUILDING_BLOCKS.UNDER_CONSTRUCTION:
		generate_path()
		show_path()


func _on_GameState_hero_journey_started():
	hide_path()
	if path:
		emit_signal("path_modified", path)
