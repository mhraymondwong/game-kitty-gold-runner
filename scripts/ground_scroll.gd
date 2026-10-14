extends Node2D
## Repeating ground tiles that scroll left with game speed.

@export var tile_width: float = 256.0
@export var ground_y: float = 600.0

var _tiles: Array[Sprite2D] = []
var _manager = null

func setup(manager) -> void:
	_manager = manager
	for c in get_children():
		c.queue_free()
	_tiles.clear()
	var tex: Texture2D = load("res://assets/ground.png")
	var count := int(ceil(1400.0 / tile_width)) + 2
	for i in range(count):
		var s := Sprite2D.new()
		s.texture = tex
		s.centered = false
		s.position = Vector2(i * tile_width, ground_y)
		add_child(s)
		_tiles.append(s)

func _process(delta: float) -> void:
	if _manager == null or not _manager.running:
		return
	var dx: float = float(_manager.speed) * delta
	for s in _tiles:
		s.position.x -= dx
	# recycle
	for s in _tiles:
		if s.position.x + tile_width < -64.0:
			var max_x := -INF
			for t in _tiles:
				max_x = maxf(max_x, t.position.x)
			s.position.x = max_x + tile_width
