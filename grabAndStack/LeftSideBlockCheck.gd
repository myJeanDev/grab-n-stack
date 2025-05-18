extends Area2D


func _process(delta: float) -> void:
	if get_overlapping_bodies().size() == 0:
		$"..".reset_left_side()

func remove_all_blocks():
	for each in get_overlapping_bodies():
		if each.is_in_group("block"):
			each.queue_free()
