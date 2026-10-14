extends Control
## Title screen — 開始遊戲

func _ready() -> void:
	$Center/VBox/Start.pressed.connect(_on_start)
	# gentle cat bob on title art
	var cat: Sprite2D = $CatPreview
	if cat:
		var tw := create_tween().set_loops()
		tw.tween_property(cat, "position:y", cat.position.y - 12.0, 0.7).set_trans(Tween.TRANS_SINE)
		tw.tween_property(cat, "position:y", cat.position.y, 0.7).set_trans(Tween.TRANS_SINE)

func _on_start() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		_on_start()
