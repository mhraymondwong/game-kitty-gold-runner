extends Node
## Autoload-style game state; also lives on Main as GameManager node.

signal score_changed(coins: int, distance: int)
signal game_over(final_coins: int, final_distance: int)
signal started

var coins: int = 0
var distance: float = 0.0
var running: bool = false
var speed: float = 280.0
var base_speed: float = 280.0
var max_speed: float = 560.0
var speed_ramp: float = 8.0  # per second

func reset() -> void:
	coins = 0
	distance = 0.0
	speed = base_speed
	running = false
	score_changed.emit(coins, 0)

func start_run() -> void:
	reset()
	running = true
	started.emit()
	score_changed.emit(coins, 0)

func add_coin(n: int = 1) -> void:
	if not running:
		return
	coins += n
	score_changed.emit(coins, int(distance))

func tick(delta: float) -> void:
	if not running:
		return
	distance += speed * delta * 0.05  # scale to readable meters-ish
	speed = minf(max_speed, speed + speed_ramp * delta)
	score_changed.emit(coins, int(distance))

func end_run() -> void:
	if not running:
		return
	running = false
	game_over.emit(coins, int(distance))
