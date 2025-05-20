extends Node2D

var claw_scene: PackedScene = preload("res://leftSide/claw.tscn")
var rotationSpeed = 1
var can_launch = true
var launch_power = 0.0
var POWER_INCREASE = 2000.0
const MAX_POWER = 5000.0
var current_claw: RigidBody2D = null


func _ready() -> void:
	print("ClawLauncher Ready: ")


func _process(delta: float) -> void:
	if Input.is_action_pressed("left"):
		rotate_claw(1)
	if Input.is_action_pressed("right"):
		rotate_claw(-1)
	if Input.is_action_pressed("shoot"):
		increase_power(delta)
	if Input.is_action_just_released("shoot"):
		shoot_claw(launch_power)
	update_power_indicator()


func rotate_claw(direction: int):
	var currentRotation = $RotationOrigin.get_rotation_degrees()
	var newRotation = clamp(currentRotation + (rotationSpeed*direction), -75, 75)
	$RotationOrigin.set_rotation_degrees(newRotation)


func update_power_indicator():
	var min_scale = Vector2(4.0, 4.0)  # Minimum scale when power is 0
	var max_scale = Vector2(10.0, 10.0)  # Maximum scale when power is MAX_POWER
	var scale_x = remap(launch_power, 0.0, MAX_POWER, min_scale.x, max_scale.x)
	var scale_y = remap(launch_power, 0.0, MAX_POWER, min_scale.y, max_scale.y)
	$RotationOrigin/Polygon2D2.scale = Vector2(scale_x, scale_y)


func increase_power(delta: float):
	launch_power = clamp(launch_power + POWER_INCREASE * delta,0.0, MAX_POWER)


func shoot_claw(power: float):
	launch_power = 0.0 
	if get_tree().get_nodes_in_group("claw").size() < 3:
		current_claw = claw_scene.instantiate()
		current_claw.global_position = global_position
		get_parent().add_child(current_claw)
		var direction = ($RotationOrigin/Marker2D.global_position - global_position).normalized()
		current_claw.set_linear_velocity(direction * power) 
		print("shooting claw with:",current_claw.linear_velocity)

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("claw hit!",body)
