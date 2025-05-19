extends RigidBody2D

var path_to_home: Path2D
var path_line_visual: Line2D
var path_follow: PathFollow2D
var going_home: bool = false
var HOME_SPEED: float = 200.0
var MAX_LENGTH: float = 10000.0
var INITIAL_SPEED: float = 100.0
var ACCELERATION:float = 1.0
var can_place_points: bool = true
var last_point_removed: float
var current_speed:float = 0.0



func _ready():
	var claw_count = get_tree().get_nodes_in_group("claw").size()
	update_scale(claw_count)
	var line_width = 16 - (claw_count*1.2)
	path_line_visual = Line2D.new()
	path_line_visual.width = line_width
	path_line_visual.modulate.a = 0.5
	path_to_home = Path2D.new()
	path_to_home.curve = Curve2D.new()
	
	path_follow = PathFollow2D.new()
	path_follow.loop = false
	path_to_home.add_child(path_follow)
	
	place_path_point()
	get_parent().add_child(path_to_home)
	get_parent().add_child(path_line_visual)


func update_scale(claw_count: int):
	var scale_factor = max(0.2, 1.0 - (claw_count - 1) * 0.1)
	var base_radius = 50.0
	var area2d_shape = CircleShape2D.new()
	var rigidbody_shape = CircleShape2D.new()
	
	var rigidbody_radius = base_radius * scale_factor
	var area2d_radius = rigidbody_radius * 2.0  # 50% larger
	
	area2d_shape.radius = area2d_radius
	rigidbody_shape.radius = rigidbody_radius
	
	var area2d_collision = $Area2D/CollisionShape2D
	var rigidbody_collision = $CollisionShape2D  # or $RigidBody2D/CollisionShape2D
	var polygon2d = $Polygon2D
	
	area2d_collision.shape = area2d_shape
	rigidbody_collision.shape = rigidbody_shape
	
	var polygon_scale = Vector2(scale_factor, scale_factor)
	polygon2d.scale = polygon_scale


func _physics_process(delta):
	if going_home:
		follow_path_home(delta)
	else:
		check_length()


func place_path_point():
	if can_place_points:
		print("added point", global_position)
		path_line_visual.add_point(global_position)
		path_to_home.curve.add_point(global_position)


func remove_passed_points(previous_progress):
	var point_count = path_line_visual.get_point_count()
	if point_count <= 1:
		return
	
	var removal_threshold = 1.0
	
	if previous_progress - path_follow.progress > removal_threshold:
		path_line_visual.remove_point(point_count - 1)
		last_point_removed = path_follow.progress
		
		if path_to_home.curve.get_point_count() > 1:
			path_to_home.curve.remove_point(path_to_home.curve.get_point_count() - 1)


func check_length():
	var curve_length = path_to_home.curve.get_baked_length()
	#if curve_length > MAX_LENGTH:
		#go_home()
	#if linear_velocity.length() <= 20.0:
		#go_home()


func go_home():
	grab_objects()
	print("claw going home")
	can_place_points = false
	going_home = true
	linear_velocity = Vector2.ZERO
	freeze = true
	current_speed = INITIAL_SPEED
	path_follow.progress = path_to_home.curve.get_baked_length()


func follow_path_home(delta):
	var previous_progress = path_follow.progress
	current_speed += ACCELERATION * delta
	current_speed = min(current_speed, HOME_SPEED)
	path_follow.progress -= current_speed * delta
	global_position = path_follow.global_position
	global_rotation = path_follow.global_rotation
	
	remove_passed_points(previous_progress)
	if path_follow.progress <= 0:
		reach_home()


func reach_home():
	path_to_home.queue_free()
	path_line_visual.queue_free()
	path_follow.queue_free()
	release_objects()
	queue_free()


func _on_timer_timeout() -> void:
	place_path_point()

var grabbed_bodies = []
var joints = []

func grab_objects():
	release_objects()
	for body in $Area2D.get_overlapping_bodies():
		if body is RigidBody2D and body != self:
			grabbed_bodies.append(body)
			
			# Create a joint to connect the body to the claw
			var joint = PinJoint2D.new()
			joint.disable_collision = true
			add_child(joint)
			joint.node_a = get_path()
			joint.node_b = body.get_path()
			
			# Set joint position (in global coordinates)
			joint.position = to_local(body.global_position)
			
			joints.append(joint)


func release_objects():
	for joint in joints:
		joint.queue_free()
	joints.clear()
	grabbed_bodies.clear()


var count_down = 5
func _on_time_till_grab_timeout() -> void:
	count_down -= 1
	$RichTextLabel.text = str(count_down)
	if count_down == 0:
		go_home()
