extends Resource
class_name LevelData

export(int) var level_index
export(Array, Enums.BUILDING_BLOCKS) var block_types
export(Array, int) var block_number
export(int) var energy
export(int) var health

export(Array, String, MULTILINE) var intro_lines
export(Array, String, MULTILINE) var win_lines
export(Array, String, MULTILINE) var lose_lines
