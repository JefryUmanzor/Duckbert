extends Control

@onready var animation_tree = $AnimationTree

var focused = false;
@onready var start_button = $"Main Menu/Main Buttons/Start"
@onready var options_button = $"Main Menu/Main Buttons/Options"

@onready var fullscreen_toggle = $"Options/VBoxContainer2/Fullscreen Holder/HBoxContainer/Fullscreen Toggle"

func _ready():
	animation_tree.set("parameters/Main Shot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE);

func _process(_delta):
	if not focused:
		if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down"):
			start_button.grab_focus();

func on_grab_focus():
	focused = true;

func send_to_test_room():
	get_tree().call_deferred("change_scene_to_file", "res://Rooms/Test Room.tscn");
func quit_game():
	get_tree().quit();

func switch_to_options():
	animation_tree.set("parameters/Options Shot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE);
	animation_tree.set("parameters/Blend/blend_amount", 1.0);
	fullscreen_toggle.grab_focus();
func switch_to_main():
	animation_tree.set("parameters/Options Return Shot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE);
	animation_tree.set("parameters/Blend/blend_amount", 0.0);
	options_button.grab_focus();

func toggle_fullscreen(fullscreen):
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN);
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED);
func toggle_fs_stretch(stretch):
	if stretch:
		get_tree().root.content_scale_stretch = Window.CONTENT_SCALE_STRETCH_FRACTIONAL;
	else:
		get_tree().root.content_scale_stretch = Window.CONTENT_SCALE_STRETCH_INTEGER;
