extends Area2D

func remove_all_blocks():
	for each in get_overlapping_bodies():
		if each.is_in_group("block"):
			each.queue_free()
