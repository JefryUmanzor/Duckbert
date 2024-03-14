extends Node2D

@export var teleport_player : bool = false;
@export var teleport_offset : Vector2 = Vector2(0.0, -512);
@onready var camera_2d = $"../Camera2D"

var save_data : SaveLoad;
@export_flags_2d_navigation var level_to_unlock = 0;

signal on_player_teleport;

func _ready():
	save_data = get_node("/root/SaveLoadHandler") as SaveLoad;

func send_to_ending():
	get_node("/root/RoomChanger").change_room("res://Rooms/Ending Cutscene.tscn");

func on_touch_player(_player):
	if not teleport_player:
		save_data.write_save(level_to_unlock);
		get_tree().current_scene.get_node("GUI").level_clear();
	
	var player : Player = (_player as Player);
	player.can_control = false;
	
	if teleport_player:
		camera_2d.follow_target = false;
		player.gravity_scale = 0.0;
		player.velocity = Vector2.ZERO;
		player.global_position = global_position + teleport_offset;
		on_player_teleport.emit();
