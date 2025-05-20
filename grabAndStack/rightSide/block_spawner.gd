extends Node2D
@export var blockGroup: String = "block"
@export var block_scene: PackedScene
@export var starting_amount: int = 3
@export var blockShapes: Array[PackedScene] = []
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	spawn_some_blocks()

func spawn_some_blocks():
	for i in starting_amount:
		$Timer.start()
		await $Timer.timeout
		spawn_block(position)

# Set a specific seed for deterministic randomness
func set_seed(seed_value: int):
	rng.seed = seed_value
	
# Spawn a block at the specified position with random x offset
func spawn_block(position: Vector2) -> RigidBody2D:
	var block = block_scene.instantiate()
	block.add_to_group(blockGroup)
	
	# Add random x offset between -100 and +100
	var random_x_offset = rng.randf_range(-500.0, 500.0)
	var spawn_position = Vector2(position.x + random_x_offset, position.y)
	block.position = spawn_position
	
	# Choose a random shape using our seeded RNG
	var shape_index = rng.randi() % blockShapes.size()
	var shape = blockShapes[shape_index].instantiate()
	
	# Setup the block with this shape
	block.setup_shape(shape)
	
	# Add to scene
	get_parent().call_deferred("add_child", block)
	return block
	
# Spawn a block with a specific shape index
func spawn_block_with_shape(position: Vector2, shape_index: int) -> RigidBody2D:
	if shape_index < 0 or shape_index >= blockShapes.size():
		return spawn_block(position)  # Fallback to random
		
	var block = block_scene.instantiate()
	
	# Add random x offset between -100 and +100
	var random_x_offset = rng.randf_range(-500.0, 500.0)
	var spawn_position = Vector2(position.x + random_x_offset, position.y)
	block.position = spawn_position
	
	var shape = blockShapes[shape_index].instantiate()
	block.setup_shape(shape)
	
	add_child(block)
	return block


func spawn_block_with_passed_shape(shape: Polygon2D) -> RigidBody2D:
	shape.modulate = Color(1.0,1.0,1.0)
	shape.color = Color(1.0,1.0,1.0)
	var block = block_scene.instantiate()
	block.add_to_group(blockGroup)
	
	# Add random x offset between -100 and +100
	var random_x_offset = rng.randf_range(-500.0, 500.0)
	var spawn_position = Vector2(global_position.x + random_x_offset, global_position.y)
	block.global_position = spawn_position
	
	block.setup_shape(shape)
	get_parent().call_deferred("add_child", block)
	return block
