extends Resource
class_name TilesetSideRef

@export var side_left := Vector2i(0,0)
@export var side_right := Vector2i(0,0)
@export var side_top := Vector2i(0,0)
@export var side_bottom := Vector2i(0,0)

@export var corner_top_left := Vector2i(0,0)
@export var corner_top_right := Vector2i(0,0)
@export var corner_bottom_left := Vector2i(0,0)
@export var corner_bottom_right := Vector2i(0,0)

@export var inside_corner_top_left := Vector2i(0,0)
@export var inside_corner_top_right := Vector2i(0,0)
@export var inside_corner_bottom_left := Vector2i(0,0)
@export var inside_corner_bottom_right := Vector2i(0,0)

enum TILE_TYPE {
	NONE = -1,
	SIDE_LEFT = 0,
	SIDE_RIGHT = 1,
	SIDE_TOP = 2,
	SIDE_BOTTOM = 3,
	CORNER_TOP_LEFT = 4,
	CORNER_TOP_RIGHT = 5,
	CORNER_BOTTOM_LEFT = 6,
	CORNER_BOTTOM_RIGHT = 7,
	INSIDE_CORNER_TOP_LEFT = 8,
	INSIDE_CORNER_TOP_RIGHT = 9,
	INSIDE_CORNER_BOTTOM_LEFT = 10,
	INSIDE_CORNER_BOTTOM_RIGHT = 11
}

func get_Tile(type : TILE_TYPE) -> Vector2i:
	match type:
		TILE_TYPE.NONE:
			return Vector2i(-1,-1)
		TILE_TYPE.SIDE_LEFT:
			return side_left
		TILE_TYPE.SIDE_RIGHT:
			return side_right
		TILE_TYPE.SIDE_TOP:
			return side_top
		TILE_TYPE.SIDE_BOTTOM:
			return side_bottom
		TILE_TYPE.CORNER_TOP_LEFT:
			return corner_top_left
		TILE_TYPE.CORNER_TOP_RIGHT:
			return corner_top_right
		TILE_TYPE.CORNER_BOTTOM_LEFT:
			return corner_bottom_left
		TILE_TYPE.CORNER_BOTTOM_RIGHT:
			return corner_bottom_right
		TILE_TYPE.INSIDE_CORNER_TOP_LEFT:
			return inside_corner_top_left
		TILE_TYPE.INSIDE_CORNER_TOP_RIGHT:
			return inside_corner_top_right
		TILE_TYPE.INSIDE_CORNER_BOTTOM_LEFT:
			return inside_corner_bottom_left
		TILE_TYPE.INSIDE_CORNER_BOTTOM_RIGHT:
			return inside_corner_bottom_right
	return Vector2i(-1,-1)
	
