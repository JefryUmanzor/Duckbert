extends Line2D

@onready var path = $".."

func _ready():
	points = (path.curve as Curve2D).get_baked_points();
