extends Sprite2D

@export var rotation_speed : float = 50;

func _process(delta):
	rotation += rotation_speed * delta;
	rotation_degrees = wrapf(rotation_degrees, 0.0, 360.0);
