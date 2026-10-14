extends Node2D
## Spawns coins and obstacles ahead; recycles when off-screen.

@onready var coin_scene: PackedScene = preload("res://scenes/coin.tscn")
@onready var rock_scene: PackedScene = preload("res://scenes/obstacle_rock.tscn")
@onready var box_scene: PackedScene = preload("res://scenes/obstacle_box.tscn")

var _manager = null
var _spawn_x: float = 900.0
var _next_gap: float = 280.0
var _rng := RandomNumberGenerator.new()

func setup(manager) -> void:
	_manager = manager
	_rng.randomize()
	_spawn_x = 1000.0
	_next_gap = 300.0
	for c in get_children():
		c.queue_free()

func _process(delta: float) -> void:
	if _manager == null or not _manager.running:
		return
	# Move all children left with world speed
	var dx: float = float(_manager.speed) * delta
	for c in get_children():
		c.position.x -= dx
		if c.position.x < -120.0:
			c.queue_free()

	_spawn_x -= dx
	while _spawn_x < 1400.0:
		_spawn_chunk()
		_spawn_x += _next_gap
		# tighten gaps slightly as speed rises
		var t: float = clampf((float(_manager.speed) - float(_manager.base_speed)) / (float(_manager.max_speed) - float(_manager.base_speed)), 0.0, 1.0)
		_next_gap = lerpf(340.0, 220.0, t) + _rng.randf_range(-40.0, 60.0)

func _spawn_chunk() -> void:
	var ground_y := 600.0
	var kind := _rng.randi() % 10
	if kind < 5:
		# coin cluster (1–3)
		var n := 1 + _rng.randi() % 3
		for i in range(n):
			var coin: Area2D = coin_scene.instantiate()
			coin.position = Vector2(_spawn_x + i * 48.0, ground_y - 90.0 - _rng.randf_range(0.0, 80.0))
			add_child(coin)
			coin.collected.connect(_on_coin_collected)
	elif kind < 8:
		# obstacle
		var obs: Area2D
		if _rng.randf() < 0.5:
			obs = rock_scene.instantiate()
			obs.position = Vector2(_spawn_x, ground_y)
		else:
			obs = box_scene.instantiate()
			obs.position = Vector2(_spawn_x, ground_y)
		add_child(obs)
		obs.hit_player.connect(_on_obstacle_hit)
	else:
		# coin over low obstacle — jump timing challenge
		var obs: Area2D = rock_scene.instantiate()
		obs.position = Vector2(_spawn_x, ground_y)
		add_child(obs)
		obs.hit_player.connect(_on_obstacle_hit)
		var coin: Area2D = coin_scene.instantiate()
		coin.position = Vector2(_spawn_x + 20.0, ground_y - 140.0)
		add_child(coin)
		coin.collected.connect(_on_coin_collected)

func _on_coin_collected(_coin: Area2D) -> void:
	if _manager:
		_manager.add_coin(1)

func _on_obstacle_hit() -> void:
	if _manager and _manager.running:
		_manager.end_run()
