class_name CheckpointManager
extends Node

var last_checkpoint : Checkpoint = null;
var initial_position : Vector2;

var player : Player;

func _ready():
	player = get_tree().current_scene.get_node("Pausable").get_node("Player");
	
	for check : Checkpoint in get_children():
		check.on_touch.connect(on_last_checkpoint);

func on_last_checkpoint(checkpoint : Checkpoint):
	last_checkpoint = checkpoint;

func set_initial_position(position : Vector2):
	initial_position = position;

func respawn_player():
	if last_checkpoint == null:
		player.global_position = initial_position;
	else:
		player.global_position = last_checkpoint.global_position;
