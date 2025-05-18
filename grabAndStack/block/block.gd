extends RigidBody2D

@onready var leftNode = get_tree().get_first_node_in_group("leftSideLimit")
@onready var rightNode = get_tree().get_first_node_in_group("rightSideLimit")
var is_held: bool = false

# Color properties for velocity-based coloring
@export var base_color: Color = Color(1, 1, 1)  # Default white
@export var max_velocity_color: Color = Color(1, 0, 0)  # Red at max speed
@export var max_velocity: float = 400.0  # Adjust based on your game physics

# Reference to the polygon visual
var shape_visual: Polygon2D

func _ready():
	pass

func setup_shape(polygon_shape: Polygon2D):
	shape_visual = polygon_shape
	add_child(shape_visual)
	$CollisionPolygon2D.set_polygon(shape_visual.polygon)
	base_color = shape_visual.color


func _physics_process(delta):
	if shape_visual:
		var velocity_magnitude = linear_velocity.length()
		var t = clamp(velocity_magnitude / max_velocity, 0.0, 1.0)
		shape_visual.color = base_color.lerp(Color.ORANGE, t)
