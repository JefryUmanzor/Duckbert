class_name RoomManager;
extends Node

signal on_room_change;
var signal_countdown : int = 0;

func change_room(path):
	get_tree().change_scene_to_file(path);
	signal_countdown = 1;

func _process(_delta):
	if signal_countdown > 0:
		signal_countdown-= 1;
		if signal_countdown == 0:
			emit_room_change_signal();

func emit_room_change_signal():
	on_room_change.emit();
