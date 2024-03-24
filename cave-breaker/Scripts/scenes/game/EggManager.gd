extends Node2D

var level: GameLevel = null
var grid: Array[Sprite2D] = []

func _ready():
	level = SceneSwitcher.gameData.level
	get_tree().get_root().size_changed.connect(_on_resize_window)
	
	
	var i: int = 0
	for cell in level.board:
		if cell < 0:
			i = i + 1
			grid.append(null)
			continue
		
		var egg := Sprite2D.new()
		var eggData := level.eggs[level.board[i]]
		var x: float = i % level.width + 0.5
		var y: float = i / level.width + 0.5
		egg.texture = eggData.sprite
		add_child(egg)
		grid.append(egg)
		
		i = i + 1
	
	_on_resize_window()

func _process(delta):
	pass
	
func _on_resize_window():
	var screen_size = get_viewport().get_visible_rect().size
	var level_size := Vector2((level.width + 4) * 64, ((level.height + 4) * 64) + 100)
	
	var i: int = 0
	for cell in grid:
		if not cell:
			i = i + 1
			continue
		
		var scaling = Vector2(1.0 / cell.texture.get_size().x * 64, 1.0 / cell.texture.get_size().y * 64)
		var new_level_size: float = 1
		
		if level_size.x >= screen_size.x or level_size.y >= screen_size.y:
			new_level_size = screen_size.x / ((level.width + 4) * 64.0)
			var new_level_size_y = screen_size.y / (((level.height + 4) * 64.0) + 100)
			if new_level_size_y < new_level_size:
				new_level_size = new_level_size_y
			scaling = scaling * Vector2(new_level_size, new_level_size)
		
		var pos_x = screen_size.x / 2 - ((level.width) * (new_level_size * 64) / 2)
		var pos_y = screen_size.y / 2 - ((level.height) * (new_level_size * 64) / 2)
		var x: float = i % level.width + 0.5
		var y: float = i / level.width + 0.5
		cell.position = Vector2(x * (new_level_size * 64) + pos_x, y * (new_level_size * 64) + pos_y - (new_level_size * 50))
		cell.scale = scaling
		i = i + 1
