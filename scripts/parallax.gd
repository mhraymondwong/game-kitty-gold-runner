extends Node2D
## Simple hills parallax scrolling slower than ground.

@export var factor: float = 0.35

var _manager = null
var _sprites: Array[Sprite2D] = []

func setup(manager) -> void:
	_manager = manager
	for c in get_children():
		c.queue_free()
	_sprites.clear()
	var tex: Texture2D = load("res://assets/hills.png")
	for i in range(3):
		var s := Sprite2D.new()
		s.texture = tex
		s.centered = false
		s.position = Vector2(i * 1280.0, 400.0)
		s.modulate = Color(1, 1, 1, 0.85)
		add_child(s)
		_sprites.append(s)

func _process(delta: float) -> void:
	if _manager == null or not _manager.running:
		return
	var dx: float = float(_manager.speed) * factor * delta
	for s in _sprites:
		s.position.x -= dx
		if s.position.x + 1280.0 < 0.0:
			var max_x := -INF
			for t in _sprites:
				max_x = maxf(max_x, t.position.x)
			s.position.x = max_x + 1280.0
