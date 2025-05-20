extends Node2D

var blockShapes: Array[PackedScene] = [
	preload("res://block/shapeTypes/shape0.tscn"),
	preload("res://block/shapeTypes/shape1.tscn"),
	preload("res://block/shapeTypes/shape2.tscn"),
	preload("res://block/shapeTypes/shape3.tscn"),
	preload("res://block/shapeTypes/shape4.tscn"),
	preload("res://block/shapeTypes/shape5.tscn"),
	preload("res://block/shapeTypes/shape6.tscn"),
	preload("res://block/shapeTypes/shape7.tscn"),
	preload("res://block/shapeTypes/shapeCHRIS.tscn"),
	preload("res://block/shapeTypes/shapeCoffin.tscn"),
	preload("res://block/shapeTypes/shapeHook.tscn"),
	preload("res://block/shapeTypes/shapeIVY.tscn"),
	preload("res://block/shapeTypes/shapeJay3.tscn"),
	preload("res://block/shapeTypes/shapeJay.tscn"),
	preload("res://block/shapeTypes/shapeJOSH.tscn"),
	preload("res://block/shapeTypes/shapeL.tscn"),
	preload("res://block/shapeTypes/shapeLong.tscn"),
	preload("res://block/shapeTypes/shapeLongeest.tscn"),
	preload("res://block/shapeTypes/shapeLongEH.tscn"),
	preload("res://block/shapeTypes/shapeLongEHer.tscn"),
	preload("res://block/shapeTypes/shapeLonger.tscn"),
	preload("res://block/shapeTypes/shapeNOTBALLS.tscn"),
	preload("res://block/shapeTypes/shapeSquare.tscn"),
	preload("res://block/shapeTypes/shapeT.tscn"),
	preload("res://block/shapeTypes/shapeViNNYT.tscn"),
	preload("res://block/shapeTypes/shapje3.tscn")
]

@export var blockGroup: String = "block"
var block_scene: PackedScene = preload("res://block/block.tscn")
var starting_amount: int = 3
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
