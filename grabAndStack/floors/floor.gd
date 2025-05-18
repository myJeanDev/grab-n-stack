extends StaticBody2D

var floor_shapes: Array[String] = []
var rng = RandomNumberGenerator.new()
var shapes_path = "res://floors/floorTypes/"
var last_shape = null


func _ready():
	rng.randomize()
	floor_shapes = dir_contents(shapes_path)
	change_floor_type()


func change_floor_type():
	if last_shape != null:
		last_shape.queue_free()
	print(floor_shapes.pick_random())
	var shape = load(floor_shapes.pick_random()).instantiate()
	$CollisionPolygon2D.add_child(shape)
	$CollisionPolygon2D.set_polygon(shape.polygon)
	last_shape = shape
	

func dir_contents(path) -> Array[String]:
	var shapes: Array[String] = []
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				shapes.append(path + file_name)
				print("Found FILE: " + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return shapes
