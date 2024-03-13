extends Sprite2D

@export var blend : float = 0.0;
var last_blend = 0.0;

func _process(_delta):
	if last_blend != blend:
		material.set("shader_param/blend_amount", blend);
		last_blend = blend;
