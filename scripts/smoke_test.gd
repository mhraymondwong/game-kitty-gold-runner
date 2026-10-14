extends SceneTree
## Headless smoke: load scenes, run main a moment, simulate jump.

func _initialize() -> void:
	print("[smoke] kitty-gold-runner smoke test start")
	var title := load("res://scenes/title.tscn")
	assert(title != null, "title.tscn failed to load")
	print("[smoke] title.tscn OK")
	var main_ps: PackedScene = load("res://scenes/main.tscn")
	assert(main_ps != null, "main.tscn failed to load")
	print("[smoke] main.tscn OK")
	assert(load("res://scenes/coin.tscn") != null)
	assert(load("res://scenes/obstacle_rock.tscn") != null)
	assert(load("res://scenes/obstacle_box.tscn") != null)
	print("[smoke] entity scenes OK")

	var inst: Node = main_ps.instantiate()
	root.add_child(inst)
	print("[smoke] main instantiated")

	await create_timer(0.35).timeout
	var player: CharacterBody2D = inst.get_node("Player")
	var manager = inst.get_node("GameManager")
	assert(manager.running == true, "manager should be running")
	print("[smoke] manager running, coins=", manager.coins, " speed=", manager.speed)

	# Simulate jump
	Input.action_press("jump")
	await create_timer(0.05).timeout
	Input.action_release("jump")
	await create_timer(0.25).timeout
	print("[smoke] after jump vel.y=", player.velocity.y, " on_floor=", player.is_on_floor())

	# Force game over path
	manager.end_run()
	await create_timer(0.1).timeout
	var go: CanvasLayer = inst.get_node("GameOver")
	assert(go.visible == true, "game over UI should show")
	print("[smoke] game over UI visible OK")

	print("[smoke] PASS")
	quit(0)
