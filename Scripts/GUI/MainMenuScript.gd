extends Control

@onready var animation_tree = $AnimationTree

var focused = false;
@onready var start_button = $"Main Menu/Main Buttons/Start"
@onready var options_button = $"Main Menu/Main Buttons/Options"

@onready var fullscreen_toggle = $"Options/VBoxContainer2/Fullscreen Holder/HBoxContainer/Fullscreen Toggle"
@onready var fullscreen_stretch_toggle = $"Options/VBoxContainer2/Fullscreen Scale Holder/HBoxContainer/Fullscreen Stretch Toggle"
@onready var music_toggle = $"Options/VBoxContainer2/Music Holder/HBoxContainer/Music Toggle"
@onready var sfx_toggle = $"Options/VBoxContainer2/SFX Holder/HBoxContainer/SFX Toggle"

var options_loaded : bool = false;
var save_data : Options;

func _ready():
	save_data = get_tree().current_scene.get_node("/root/SaveLoadHandler") as Options;
	animation_tree.set("parameters/Main Shot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE);

func on_options_loaded():
	fullscreen_toggle.button_pressed = save_data.options_save.options.is_fullscreen as bool;
	fullscreen_stretch_toggle.button_pressed = save_data.options_save.options.stretch_mode == Window.CONTENT_SCALE_STRETCH_FRACTIONAL;
	music_toggle.button_pressed = save_data.options_save.options.music_on as bool;
	sfx_toggle.button_pressed = save_data.options_save.options.sfx_on as bool;
	
	options_loaded = true;

func _process(_delta):
	if !options_loaded:
		if save_data.options_loaded:
			on_options_loaded();
	
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

func toggle_music(music_on):
	if options_loaded:
		AudioServer.set_bus_mute(1, !music_on);
		save_data.toggle_music(music_on);
func toggle_sfx(sfx_on):
	if options_loaded:
		AudioServer.set_bus_mute(2, !sfx_on);
		save_data.toggle_sfx(sfx_on);

func toggle_fullscreen(fullscreen):
	if options_loaded:
		if fullscreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN);
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED);
		save_data.toggle_fullscreen(fullscreen);
func toggle_fs_stretch(stretch):
	if options_loaded:
		if stretch:
			get_tree().root.content_scale_stretch = Window.CONTENT_SCALE_STRETCH_FRACTIONAL;
			save_data.switch_stretch(Window.CONTENT_SCALE_STRETCH_FRACTIONAL);
		else:
			get_tree().root.content_scale_stretch = Window.CONTENT_SCALE_STRETCH_INTEGER;
			save_data.switch_stretch(Window.CONTENT_SCALE_STRETCH_INTEGER);
