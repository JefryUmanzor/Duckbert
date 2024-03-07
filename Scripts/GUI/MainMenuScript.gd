extends Control

@onready var animation_tree = $AnimationTree
const TEST_ROOM = preload("res://Rooms/Test Room.tscn")

func _ready():
	animation_tree.set("parameters/Main Shot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE);

func send_to_test_room():
	get_tree().change_scene_to_packed(TEST_ROOM);
