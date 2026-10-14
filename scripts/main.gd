extends Node2D
## Main game scene — wires manager, player, spawner, HUD, game over.

@onready var manager = $GameManager
@onready var player: CharacterBody2D = $Player
@onready var ground: Node2D = $GroundScroll
@onready var hills: Node2D = $Parallax
@onready var spawner: Node2D = $Spawner
@onready var hud: CanvasLayer = $HUD
@onready var game_over_ui: CanvasLayer = $GameOver
@onready var coin_label: Label = $HUD/CoinLabel
@onready var dist_label: Label = $HUD/DistLabel
@onready var go_panel: PanelContainer = $GameOver/Center/Panel
@onready var go_title: Label = $GameOver/Center/Panel/VBox/Title
@onready var go_score: Label = $GameOver/Center/Panel/VBox/Score
@onready var retry_btn: Button = $GameOver/Center/Panel/VBox/Retry
@onready var title_btn: Button = $GameOver/Center/Panel/VBox/ToTitle

const PLAYER_START := Vector2(220, 580)

func _ready() -> void:
	ground.setup(manager)
	hills.setup(manager)
	spawner.setup(manager)
	manager.score_changed.connect(_on_score)
	manager.game_over.connect(_on_game_over)
	player.died.connect(_on_player_died)
	player.add_to_group("player")
	retry_btn.pressed.connect(_on_retry)
	title_btn.pressed.connect(_on_to_title)
	game_over_ui.visible = false
	_start()

func _process(delta: float) -> void:
	manager.tick(delta)

func _start() -> void:
	game_over_ui.visible = false
	player.reset_state(PLAYER_START)
	spawner.setup(manager)
	manager.start_run()

func _on_score(coins: int, distance: int) -> void:
	coin_label.text = "金幣：%d" % coins
	dist_label.text = "距離：%d" % distance

func _on_game_over(final_coins: int, final_distance: int) -> void:
	player.kill()
	go_title.text = "遊戲結束"
	go_score.text = "金幣 %d　距離 %d" % [final_coins, final_distance]
	game_over_ui.visible = true

func _on_player_died() -> void:
	pass

func _on_retry() -> void:
	_start()

func _on_to_title() -> void:
	get_tree().change_scene_to_file("res://scenes/title.tscn")
