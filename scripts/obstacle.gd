extends Area2D
## Ground hazard — touching player ends the run.

signal hit_player

var _hit: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if _hit:
		return
	if body.is_in_group("player"):
		_hit = true
		hit_player.emit()
