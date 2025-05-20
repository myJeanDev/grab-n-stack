extends StaticBody2D

var floor_shapes: Array[PackedScene] = [
	preload("res://floors/floorTypes/floorType1.tscn"),
	preload("res://floors/floorTypes/floorType2.tscn"),
	preload("res://floors/floorTypes/floorType3.tscn"),
	preload("res://floors/floorTypes/floorType4.tscn"),
	preload("res://floors/floorTypes/floorType5.tscn"),
	preload("res://floors/floorTypes/floorType6.tscn"),
	preload("res://floors/floorTypes/floorType7.tscn"),
	preload("res://floors/floorTypes/floorType8.tscn"),
	preload("res://floors/floorTypes/floorType9.tscn"),
	preload("res://floors/floorTypes/floorType10.tscn"),
	preload("res://floors/floorTypes/floorType11.tscn")
]

var rng = RandomNumberGenerator.new()
var last_shape = null


func _ready():
	rng.randomize()
	change_floor_type()


func change_floor_type():
	if last_shape != null:
		last_shape.queue_free()
	var shape = floor_shapes.pick_random().instantiate()
	$CollisionPolygon2D.call_deferred("add_child", shape)
	$CollisionPolygon2D.set_polygon(shape.polygon)
	last_shape = shape
