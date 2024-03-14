extends Sprite2D

@export_range(-1, 1) var sine_offset : float = 0.0; 
var time = 0.0;
var current_sine = 0.0;

@export var amplitude : float = 2.0;
@export var speed = 2.0;
var default_offset : Vector2;

@export var enabled : bool = true;

func _ready():
	default_offset = offset;

func _process(delta):
	time += delta;
	current_sine = sin((time + sine_offset) * speed) * amplitude;
	if enabled:
		offset = default_offset + Vector2(0.0, current_sine);
	else:
		offset = Vector2.ZERO;
