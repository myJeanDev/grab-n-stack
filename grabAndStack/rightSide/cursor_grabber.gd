extends Node2D

var held_object: PhysicsBody2D = null
var blockShapes = []


func _ready():
	print("grabber ready")
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _process(delta):
	if Input.is_action_just_pressed("grab"):
		handle_grab()
	
	if Input.is_action_just_released("grab"):
		handle_release()


func _input(event):
	if event is InputEventMouseMotion:
		follow_mouse(event.position)
		if held_object != null:
			if position.distance_to(held_object.position) > 1000.0:
				handle_release()


func follow_mouse(mouse_position: Vector2):
	set_position(mouse_position)


func handle_grab()-> void:
	var pathToObject = null
	for overlapping_body in $Area2D.get_overlapping_bodies():
		if overlapping_body.is_in_group("stackBlocks"):
			pathToObject = overlapping_body.get_path()
	
	if pathToObject != null:
		$PinJoint2D.set_node_b(pathToObject)
		held_object = get_node(pathToObject)
		held_object.modulate = Color.ORANGE
		held_object.is_held = true


func handle_release()-> void:
	if held_object != null:
		$PinJoint2D.set_node_b("")
		held_object.modulate = Color(1.0,1.0,1.0)
		held_object.is_held = false
		held_object = null
