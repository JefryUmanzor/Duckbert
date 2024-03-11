extends Node2D

@export var teleport_player : bool = false;
@export var teleport_offset : Vector2 = Vector2(0.0, -512);

func on_touch_player(_player):
	get_tree().current_scene.get_node("GUI").level_clear();
	var player : Player = (_player as Player);
	player.can_control = false;
	
	if teleport_player:
		player.gravity_scale = 0.0;
		player.velocity = Vector2.ZERO;
		player.global_position = global_position + teleport_offset;
