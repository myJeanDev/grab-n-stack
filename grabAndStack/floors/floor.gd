extends StaticBody2D

@export var floor_shapes: Array[PackedScene] = []
var rng = RandomNumberGenerator.new()
var last_shape = null


func _ready():
	rng.randomize()
	change_floor_type()


func change_floor_type():
	if last_shape != null:
		last_shape.queue_free()
	var shape = floor_shapes.pick_random().instantiate()
	$CollisionPolygon2D.add_child(shape)
	$CollisionPolygon2D.set_polygon(shape.polygon)
	last_shape = shape
