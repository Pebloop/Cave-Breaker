extends TileMap

var level: GameLevel = null
@export var sideLevelBackCells : TilesetSideRef

# List of all the patterns that set a border tile
var patterns : Dictionary = {
	# sides
	[false, false, false, false, true, false, true, true]: TilesetSideRef.TILE_TYPE.INSIDE_CORNER_TOP_LEFT,
	[false, false, false, true, false, true, true, false]: TilesetSideRef.TILE_TYPE.INSIDE_CORNER_TOP_RIGHT,
	[false, true, true, false, false, false, false, false]: TilesetSideRef.TILE_TYPE.SIDE_BOTTOM,
	[true, true, true, false, false, false, false, false]: TilesetSideRef.TILE_TYPE.SIDE_BOTTOM,
	[true, true, false, false, false, false, false, false]: TilesetSideRef.TILE_TYPE.SIDE_BOTTOM,
	[false, false, false, false, false, false, false, true]: TilesetSideRef.TILE_TYPE.CORNER_TOP_LEFT,
	[false, false, false, false, true, false, false, false]: TilesetSideRef.TILE_TYPE.SIDE_LEFT,
	[false, false, true, false, false, false, false, false]: TilesetSideRef.TILE_TYPE.CORNER_BOTTOM_LEFT,
	[false, false, false, false, false, false, true, false]: TilesetSideRef.TILE_TYPE.SIDE_TOP,
	[false, false, false, false, false, true, false, false]: TilesetSideRef.TILE_TYPE.CORNER_TOP_RIGHT,
	[false, false, false, true, false, false, false, false]: TilesetSideRef.TILE_TYPE.SIDE_RIGHT,
	[true, false, false, false, false, false, false, false]: TilesetSideRef.TILE_TYPE.CORNER_BOTTOM_RIGHT,
	[false, false, false, false, false, false, true, true]: TilesetSideRef.TILE_TYPE.SIDE_TOP,
	[false, false, false, false, false, true, true, true]: TilesetSideRef.TILE_TYPE.SIDE_TOP,
	[false, false, false, false, true, false, false, true]: TilesetSideRef.TILE_TYPE.SIDE_LEFT,
	[false, false, true, false, true, false, false, true]: TilesetSideRef.TILE_TYPE.SIDE_LEFT,
	[false, false, false, false, false, true, true, false]: TilesetSideRef.TILE_TYPE.SIDE_TOP,
	[false, false, false, true, false, true, false, false]: TilesetSideRef.TILE_TYPE.SIDE_RIGHT,
	[true, false, false, true, false, true, false, false]: TilesetSideRef.TILE_TYPE.SIDE_RIGHT,
	[false, false, true, false, true, false, false, false]: TilesetSideRef.TILE_TYPE.SIDE_LEFT,
	[true, false, false, true, false, false, false, false]: TilesetSideRef.TILE_TYPE.SIDE_RIGHT,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	level = SceneSwitcher.gameData.level
	
	get_tree().get_root().size_changed.connect(_on_windows_resize)
	_on_windows_resize()
	
	var i = 0
	for cell in level.board:
		if cell < 0:
			i = i + 1
			continue
		
		var x = i % level.width
		var y = i / level.width
		set_cell(0, Vector2(x,y), 0, Vector2(1,1))
		i = i + 1
		
	for used_cell in get_used_cells(0):
		for cell in _getSurroundingTiles(used_cell):
			if get_cell_source_id(0, cell) >= 0:
				continue
			_setSurroundingTile(cell)
			
			
func _setSurroundingTile(tile : Vector2i):
	var surroundingTile = _getSurroundingTiles(tile)
	var surroundingTileValues: Array[bool] = []
	
	for sTile in surroundingTile:
		surroundingTileValues.append(
			get_cell_source_id(0, sTile) >= 0
			and get_cell_atlas_coords(0, sTile) == Vector2i(1,1)
		)
		
	if patterns.get(surroundingTileValues, null) != null:
		set_cell(0, tile, 0, sideLevelBackCells.get_Tile(patterns.get(surroundingTileValues)))
	else:
		print(surroundingTileValues)
		

func _on_windows_resize():
	var screen_size = get_viewport().get_visible_rect().size
	var level_size := Vector2((level.width + 4) * 64, ((level.height + 4) * 64) + 100)
	
	if level_size.x >= screen_size.x or level_size.y >= screen_size.y:
		var new_level_size: float = screen_size.x / ((level.width + 4) * 64.0)
		var new_level_size_y = screen_size.y / (((level.height + 4) * 64.0) + 100)
		if new_level_size_y < new_level_size:
			new_level_size = new_level_size_y
		scale = Vector2(new_level_size, new_level_size)
	else:
		scale =  Vector2.ONE
	
	var pos_x = screen_size.x / 2 - ((level.width) * (scale.x * 64) / 2)
	var pos_y = screen_size.y / 2 - ((level.height) * (scale.x * 64) / 2)
	position = Vector2(pos_x, pos_y - (scale.x * 50))

		
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
		var cell = get_neighbor_cell(tile, direction)
		surroundingTilesCoord.append(cell)
		
	return surroundingTilesCoord
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
