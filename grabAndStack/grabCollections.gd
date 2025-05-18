extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("block") and $Timer.is_stopped():
		var provided_shape:Polygon2D = body.get_node("Polygon2D")
		body.remove_child(provided_shape)
		get_tree().get_first_node_in_group("rightBlockSpawner").spawn_block_with_passed_shape(provided_shape)
		body.queue_free()
