class_name ParticleHandler
extends Node2D

func _ready():
	for child in get_children():
		if child is GPUParticles2D:
			child.restart();
