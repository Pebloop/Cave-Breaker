extends Node2D
class_name RoomsManager

@export var tileMap : TileMap
@export var roomsMap : TileMap

@export var darknessTileSet : TileSet
@export var sideDarknessCells : TilesetSideRef

@export var rooms: Array[RoomManager] = []

# List of all the patterns that set a border tile
var patterns : Dictionary = {
	# sides
	[true, false, false, true, false, true, false, false]: TilesetSideRef.TILE_TYPE.SIDE_LEFT,
	[false, false, false, true, false, true, false, false]: TilesetSideRef.TILE_TYPE.SIDE_LEFT,
	[true, false, false, true, false, false, false, false]: TilesetSideRef.TILE_TYPE.SIDE_LEFT,
	[false, false, false, true, false, false, false, false]: TilesetSideRef.TILE_TYPE.SIDE_LEFT,
	[false, false, true, false, true, false, false, true]: TilesetSideRef.TILE_TYPE.SIDE_RIGHT,
	[false, false, true, false, true, false, false, false]: TilesetSideRef.TILE_TYPE.SIDE_RIGHT,
	[false, false, false, false, true, false, false, true]: TilesetSideRef.TILE_TYPE.SIDE_RIGHT,
	[false, false, false, false, true, false, false, false]: TilesetSideRef.TILE_TYPE.SIDE_RIGHT,
	[true, true, true, false, false, false, false, false]: TilesetSideRef.TILE_TYPE.SIDE_TOP,
	[false, true, true, false, false, false, false, false]: TilesetSideRef.TILE_TYPE.SIDE_TOP,
	[true, true, false, false, false, false, false, false]: TilesetSideRef.TILE_TYPE.SIDE_TOP,
	[false, true, false, false, false, false, false, false]: TilesetSideRef.TILE_TYPE.SIDE_TOP,
	[false, false, false, false, false, true, true, true]: TilesetSideRef.TILE_TYPE.SIDE_BOTTOM,
	[false, false, false, false, false, true, true, false]: TilesetSideRef.TILE_TYPE.SIDE_BOTTOM,
	[false, false, false, false, false, false, true, true]: TilesetSideRef.TILE_TYPE.SIDE_BOTTOM,
	[false, false, false, false, false, false, true, false]: TilesetSideRef.TILE_TYPE.SIDE_BOTTOM,
	# outside corners
	[true, false, false, false, false, false, false, false]: TilesetSideRef.TILE_TYPE.CORNER_BOTTOM_RIGHT,
	[false, false, true, false, false, false, false, false]: TilesetSideRef.TILE_TYPE.CORNER_BOTTOM_LEFT,
	[false, false, false, false, false, true, false, false]: TilesetSideRef.TILE_TYPE.CORNER_TOP_RIGHT,
	[false, false, false, false, false, false, false, true]: TilesetSideRef.TILE_TYPE.CORNER_TOP_LEFT,
	# inside corners
	[false, true, true, false, true, false, false, false]: TilesetSideRef.TILE_TYPE.INSIDE_CORNER_TOP_RIGHT,
	[false, false, false, true, false, true, true, false]: TilesetSideRef.TILE_TYPE.INSIDE_CORNER_BOTTOM_LEFT,
	[true, true, false, true, false, false, false, false]: TilesetSideRef.TILE_TYPE.INSIDE_CORNER_TOP_LEFT,
	[false, false, false, false, true, false, true, true]: TilesetSideRef.TILE_TYPE.INSIDE_CORNER_BOTTOM_RIGHT
}

var _openned_tiles := []

func _ready():
	if !tileMap or !roomsMap:
		print("Tilemap or roommap empty, cannot start game")
		return
	roomsMap.visible = false
	tileMap.set_layer_enabled(1,true)
	

func openRoom(id: int, animated: bool = false, disable: bool=false):
	var cellsToOpen := roomsMap.get_used_cells(id)
	rooms[id].activate_room()
	if disable:
		disable_events()
	
	for cell in cellsToOpen:
		tileMap.set_cell(1, cell)
		
		if animated:
			_openSides()
			await get_tree().create_timer(0.07).timeout
		if !_openned_tiles.any(func(tile): return cell == tile):
			_openned_tiles.append(cell)
	_openSides()
	
func disable_events():
	for room in rooms:
		if not room.is_active:
			continue
			
		room.disable_events()
		
func enable_events():
	for room in rooms:
		if not room.is_active:
			continue
			
		room.enable_events()
		
func _openSides():
	for cell in _openned_tiles:
		var surrounding_tiles := _getSurroundingTiles(cell)
		for sCell in surrounding_tiles:
			var cellToTest := tileMap.get_cell_source_id(1, sCell)
			if cellToTest != -1:
				_setDarknessTile(sCell)
	

func _setDarknessTile(tile : Vector2i):
	var surroundingTilesCoords := _getSurroundingTiles(tile)
	var surroundingTilesValue : Array[bool] = []
	
	for sTile in surroundingTilesCoords:
		surroundingTilesValue.append(tileMap.get_cell_source_id(1, sTile) < 0)
		
	if patterns.get(surroundingTilesValue, null) != null:
		tileMap.set_cell(1, tile, 1, sideDarknessCells.get_Tile(patterns.get(surroundingTilesValue)))
	else:
		print(surroundingTilesValue)
	
func _getSurroundingTiles(tile : Vector2i) -> Array[Vector2i] :
	var surroundingTilesCoord : Array[Vector2i] = []
	var surroundingTileTemplate = [
		TileSet.CELL_NEIGHBOR_TOP_LEFT_CORNER,
		TileSet.CELL_NEIGHBOR_TOP_SIDE,
		TileSet.CELL_NEIGHBOR_TOP_RIGHT_CORNER,
		TileSet.CELL_NEIGHBOR_LEFT_SIDE,
		TileSet.CELL_NEIGHBOR_RIGHT_SIDE,
		TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_CORNER,
		TileSet.CELL_NEIGHBOR_BOTTOM_SIDE,
		TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER
	]
	
	for direction in surroundingTileTemplate:
		var cell = tileMap.get_neighbor_cell(tile, direction)
		surroundingTilesCoord.append(cell)
		
	return surroundingTilesCoord
	
func _intToBitArray(number: int) -> Array[bool]:
	var array: Array[bool] = []
	for i in 8:
		array.append(number % 2 == 1)
		number = number / 2
	array.reverse()
	return array
		

func _process(delta):
	pass
