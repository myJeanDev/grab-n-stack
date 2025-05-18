extends Node2D

var velocity_threshold: float = 0.5
var stability_time: float = 0.5
var lerp_speed: float = 5.0
var stability_tracker = {}
var height_timer: Timer
var pending_highest_point: Vector2
var target_position: Vector2
var all_time_highest: float = 1000000

@onready var current_tracker = $currentTracker
@onready var best_tracker = $bestTracker

func _ready() -> void:
	height_timer = Timer.new()
	add_child(height_timer)
	height_timer.wait_time = 3.0
	height_timer.one_shot = true
	height_timer.timeout.connect(apply_new_height)
	target_position = current_tracker.position
	all_time_highest = current_tracker.position.y


func _process(delta: float) -> void:
	var stack_blocks = get_tree().get_nodes_in_group("stackBlocks")
	update_stability_tracking(stack_blocks, delta)
	update_position_to_highest_point(stack_blocks)
	current_tracker.position.y = lerp(current_tracker.position.y, target_position.y, lerp_speed * delta)


func update_stability_tracking(blocks: Array, delta: float) -> void:
	for block in blocks:
		if is_block_held(block):
			stability_tracker.erase(block.get_instance_id())
			continue
			
		var velocity = block.linear_velocity.length()
		var instance_id = block.get_instance_id()
		
		if velocity <= velocity_threshold:
			if not instance_id in stability_tracker:
				stability_tracker[instance_id] = 0.0
			stability_tracker[instance_id] += delta
		else:
			stability_tracker.erase(instance_id)
	
	clean_stability_tracker(blocks)

func update_position_to_highest_point(blocks: Array) -> void:
	var highest_point = Vector2(current_tracker.position.x, 1000000)
	var new_height_found = false
	
	for block in blocks:
		var instance_id = block.get_instance_id()
		
		if not instance_id in stability_tracker or stability_tracker[instance_id] < stability_time:
			continue
		
		for point in get_block_points(block):
			var global_point = block.to_global(point)
			
			if global_point.y < highest_point.y:
				highest_point = Vector2(current_tracker.position.x, global_point.y)
				new_height_found = true
	
	# Changed condition: Update whenever we find a stable height, regardless of whether 
	# it's higher or lower than the current target
	if new_height_found and height_timer.is_stopped():
		pending_highest_point = highest_point
		height_timer.start()

func apply_new_height() -> void:
	target_position.y = pending_highest_point.y
	set_new_height()
	
	# Check if this is the new all-time highest point
	if target_position.y < all_time_highest:
		all_time_highest = target_position.y
		update_best_tracker()

func update_best_tracker() -> void:
	# Update the best tracker position to the new record height
	best_tracker.position.y = all_time_highest
	print("New record height:", all_time_highest)

func clean_stability_tracker(blocks: Array) -> void:
	var block_ids = []
	for block in blocks:
		block_ids.append(block.get_instance_id())
	
	var keys_to_erase = []
	for id in stability_tracker.keys():
		if not id in block_ids:
			keys_to_erase.append(id)
	
	for id in keys_to_erase:
		stability_tracker.erase(id)

func is_block_held(block) -> bool:
	return block.is_held

func get_block_points(block) -> Array:
	for child in block.get_children():
		if child is CollisionShape2D and child.shape is ConvexPolygonShape2D:
			return child.shape.points
		elif child is CollisionPolygon2D:
			return child.polygon
	
	if "collision_shape" in block and block.collision_shape.shape is ConvexPolygonShape2D:
		return block.collision_shape.shape.points
	
	print("Warning: No polygon points found for block ", block.name)
	return []

func set_new_height():
	print("New current height:", target_position.y)
