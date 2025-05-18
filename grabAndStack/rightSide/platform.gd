extends StaticBody2D


func _ready():
	$CollisionPolygon2D.set_polygon($Polygon2D.polygon)
