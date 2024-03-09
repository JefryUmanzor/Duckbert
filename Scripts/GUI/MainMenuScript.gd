extends Control

@onready var animation_tree = $AnimationTree
const TEST_ROOM = preload("res://Rooms/Test Room.tscn")

var focused = false;
@onready var start_button = $"Main Menu/Main Buttons/Start"

func _ready():
	animation_tree.set("parameters/Main Shot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE);

func _process(_delta):
	if not focused:
		if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down"):
			start_button.grab_focus();

func on_grab_focus():
	focused = true;

func send_to_test_room():
	get_tree().change_scene_to_packed(TEST_ROOM);

func quit_game():
	get_tree().quit();
