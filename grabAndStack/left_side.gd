extends Node2D


func reset_left_side():
	$Area2D.remove_all_blocks()
	spawn_more_blocks()
	$Floor.change_floor_type()


func spawn_more_blocks():
	var block_spawner = get_tree().get_first_node_in_group("leftBlockSpawner")
	block_spawner.spawn_some_blocks()


func _on_timer_timeout() -> void:
	reset_left_side()


func _process(delta: float) -> void:
	$RichTextLabel.text = str($Area2D/Timer.time_left)



func _on_end_game_timer_timeout():
	$Area2D/Timer.stop()
