class_name HUD
extends CanvasLayer

@onready var animation_tree = $AnimationTree

@onready var next_level = $"Base/Level Clear Holder/VBoxContainer/HBoxContainer/Next Level"
@onready var level_select = $"Base/Level Clear Holder/VBoxContainer/HBoxContainer/Level Select"

var level_cleared = false;
var focused = false;

var paused = false;
var in_options = false;

@onready var resume = $"Base/Pause Panel/HBoxContainer/VBoxContainer/Resume"
@onready var restart = $"Base/Pause Panel/HBoxContainer/VBoxContainer/Restart"
@onready var options = $"Base/Pause Panel/HBoxContainer/VBoxContainer/Options"
@onready var pause_level_select = $"Base/Pause Panel/HBoxContainer/VBoxContainer/Level Select"
@onready var main_menu = $"Base/Pause Panel/HBoxContainer/VBoxContainer/Main Menu"

var player : Player = null;

@onready var action_text = $Base/Hud/ActionText

@onready var fullscreen_toggle = $"Base/Options/HBoxContainer/VBoxContainer2/Fullscreen Holder/HBoxContainer/Fullscreen Toggle"
@onready var fullscreen_stretch_toggle = $"Base/Options/HBoxContainer/VBoxContainer2/Fullscreen Scale Holder/HBoxContainer/Fullscreen Stretch Toggle"
@onready var music_toggle = $"Base/Options/HBoxContainer/VBoxContainer2/Music Holder/HBoxContainer/Music Toggle"
@onready var sfx_toggle = $"Base/Options/HBoxContainer/VBoxContainer2/SFX Holder/HBoxContainer/SFX Toggle"

var options_loaded : bool = false;
var save_data : Options;

func _ready():
	visible = true;
	player = get_tree().current_scene.get_node("Pausable").get_node("Player") as Player;
	save_data = get_tree().current_scene.get_node("/root/SaveLoadHandler") as Options;

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
	
	if not player.special_intro:
		if Input.is_action_just_pressed("Pause") and not level_cleared:
			if not in_options:
				paused = !paused;
				if paused:
					player.can_control = false;
					animation_tree.set("parameters/UI Blend/blend_amount", -1.0);
					animation_tree.set("parameters/Pause Blend/blend_amount", 0.0);
					animation_tree.set("parameters/Pause Shot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE);
					
					resume.grab_focus();
				else:
					unpause();
			else:
				exit_options();

func unpause():
	paused = false;
	animation_tree.set("parameters/UI Blend/blend_amount", 0.0);
	animation_tree.set("parameters/Unpause Shot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE);
	
	player.can_control = true;
	
	resume.release_focus();
	restart.release_focus();
	options.release_focus();
	pause_level_select.release_focus();
	main_menu.release_focus();

func exit_options():
	in_options = false;
	options.grab_focus();
	animation_tree.set("parameters/Pause Blend/blend_amount", 0.0);
	animation_tree.set("parameters/Exit Options Shot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE);
func enter_options():
	in_options = true;
	fullscreen_toggle.grab_focus();
	animation_tree.set("parameters/Pause Blend/blend_amount", 1.0);
	animation_tree.set("parameters/Options Shot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE);

func toggle_music(music_on):
	if options_loaded:
		AudioServer.set_bus_mute(1, !music_on);
		save_data.toggle_music(music_on);
func toggle_sfx(sfx_on):
	if options_loaded:
		AudioServer.set_bus_mute(2, !sfx_on);
		save_data.toggle_sfx(sfx_on);

func restart_scene():
	get_tree().reload_current_scene();

func go_to_main_menu():
	get_tree().current_scene.get_node("/root/RoomChanger").change_room("res://Rooms/Main Menu.tscn");
func quit_game():
	get_tree().quit();

func level_clear():
	animation_tree.set("parameters/Level Clear Shot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE);
	animation_tree.set("parameters/UI Blend/blend_amount", 1.0);
	
	level_cleared = true;
	next_level.grab_focus();
	focused = true;

func on_action_switch(new_text : String):
	if new_text != "None":
		action_text.text = "Press to: " + new_text;
	else:
		action_text.text = "No action"

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
