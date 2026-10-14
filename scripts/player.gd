extends CharacterBody2D
## Cute 小花貓 runner — auto-runs right; jump only.

@export var jump_velocity: float = -520.0
@export var gravity: float = 1600.0
@export var coyote_time: float = 0.12
@export var jump_buffer: float = 0.1

@onready var sprite: Sprite2D = $Sprite
@onready var anim_timer: Timer = $AnimTimer

var _coyote: float = 0.0
var _buffer: float = 0.0
var _run_frame: int = 0
var _alive: bool = true
var _textures: Dictionary = {}

signal died

func _ready() -> void:
	_textures = {
		"run0": load("res://assets/cat_run0.png"),
		"run1": load("res://assets/cat_run1.png"),
		"run2": load("res://assets/cat_run2.png"),
		"jump": load("res://assets/cat_jump.png"),
		"idle": load("res://assets/cat_idle.png"),
	}
	sprite.texture = _textures["idle"]
	anim_timer.timeout.connect(_on_anim_tick)
	anim_timer.wait_time = 0.12
	anim_timer.start()

func _physics_process(delta: float) -> void:
	if not _alive:
		return

	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
		_coyote = maxf(0.0, _coyote - delta)
	else:
		_coyote = coyote_time
		if velocity.y > 0.0:
			velocity.y = 0.0

	_buffer = maxf(0.0, _buffer - delta)

	if Input.is_action_just_pressed("jump"):
		_buffer = jump_buffer

	if _buffer > 0.0 and _coyote > 0.0:
		velocity.y = jump_velocity
		_coyote = 0.0
		_buffer = 0.0
		sprite.texture = _textures["jump"]

	# Horizontal stickiness for CharacterBody2D (world scrolls instead)
	velocity.x = 0.0
	move_and_slide()

	_update_sprite()

func _update_sprite() -> void:
	if not is_on_floor():
		sprite.texture = _textures["jump"]
		# slight squash/stretch feel
		sprite.scale = Vector2(0.95, 1.08)
	else:
		sprite.scale = Vector2(1.0, 1.0)

func _on_anim_tick() -> void:
	if not _alive or not is_on_floor():
		return
	_run_frame = (_run_frame + 1) % 3
	sprite.texture = _textures["run%d" % _run_frame]

func kill() -> void:
	if not _alive:
		return
	_alive = false
	velocity = Vector2.ZERO
	sprite.modulate = Color(1, 0.5, 0.5)
	died.emit()

func reset_state(pos: Vector2) -> void:
	_alive = true
	global_position = pos
	velocity = Vector2.ZERO
	sprite.modulate = Color.WHITE
	sprite.texture = _textures["idle"]
