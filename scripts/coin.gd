extends Area2D
## Collectible gold coin.

signal collected(coin: Area2D)

var _taken: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	# gentle bob
	var tw := create_tween().set_loops()
	tw.tween_property(self, "position:y", position.y - 8.0, 0.45).set_trans(Tween.TRANS_SINE)
	tw.tween_property(self, "position:y", position.y, 0.45).set_trans(Tween.TRANS_SINE)

func _on_body_entered(body: Node2D) -> void:
	if _taken:
		return
	if body.is_in_group("player"):
		_taken = true
		collected.emit(self)
		queue_free()
