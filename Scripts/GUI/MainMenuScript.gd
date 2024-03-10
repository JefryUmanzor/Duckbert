extends Control

@onready var animation_tree = $AnimationTree

@onready var start_button = $"Main Screen/Main Buttons/Start"
@onready var options_button = $"Main Screen/Main Buttons/Options"
@onready var quit = $"Main Screen/Main Buttons/Quit"

@onready var fullscreen_toggle = $"Options/VBoxContainer2/Fullscreen Holder/HBoxContainer/Fullscreen Toggle"
@onready var fullscreen_stretch_toggle = $"Options/VBoxContainer2/Fullscreen Scale Holder/HBoxContainer/Fullscreen Stretch Toggle"
@onready var music_toggle = $"Options/VBoxContainer2/Music Holder/HBoxContainer/Music Toggle"
@onready var sfx_toggle = $"Options/VBoxContainer2/SFX Holder/HBoxContainer/SFX Toggle"
@onready var back_button = $"Options/VBoxContainer2/Back/HBoxContainer/Back Button"

@onready var level_1_button = $"Level Select/Panel/VBoxContainer/World 1/1-1"
@onready var level_back_button = $"Level Select/Panel/VBoxContainer/HBoxContainer4/Back"

var options_loaded : bool = false;
var save_data : Options;

var in_options : bool = false;
var in_levels : bool = false;

@onready var move_sfx = $MoveSFX
@onready var press_sfx = $PressSFX

func _ready():
	save_data = get_tree().current_scene.get_node("/root/SaveLoadHandler") as Options;
	animation_tree.set("parameters/Main Shot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE);
	start_button.grab_focus();
	
	set_sfx();

func set_sfx():
	start_button.focus_entered.connect(move_sfx.play);
	options_button.focus_entered.connect(move_sfx.play);
	quit.focus_entered.connect(move_sfx.play);
	
	fullscreen_toggle.focus_entered.connect(move_sfx.play);
	fullscreen_stretch_toggle.focus_entered.connect(move_sfx.play);
	music_toggle.focus_entered.connect(move_sfx.play);
	sfx_toggle.focus_entered.connect(move_sfx.play);
	back_button.focus_entered.connect(move_sfx.play);
	
	start_button.pressed.connect(press_sfx.play);
	options_button.pressed.connect(press_sfx.play);
	quit.pressed.connect(press_sfx.play);
	
	fullscreen_toggle.pressed.connect(press_sfx.play);
	fullscreen_stretch_toggle.pressed.connect(press_sfx.play);
	music_toggle.pressed.connect(press_sfx.play);
	sfx_toggle.pressed.connect(press_sfx.play);
	back_button.pressed.connect(press_sfx.play);
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

func quit_game():
	get_tree().quit();

func switch_to_options():
	animation_tree.set("parameters/Options Shot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE);
	animation_tree.set("parameters/Blend/blend_amount", 1.0);
	fullscreen_toggle.grab_focus();
	in_options = true;
func switch_to_main():
	if in_options:
		animation_tree.set("parameters/Options Return Shot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE);
	elif in_levels:
		animation_tree.set("parameters/Level Return Shot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE);
	
	in_options = false;
	in_levels = false;
	
	animation_tree.set("parameters/Blend/blend_amount", 0.0);
	options_button.grab_focus();
func switch_to_levels():
	animation_tree.set("parameters/Level Shot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE);
	animation_tree.set("parameters/Blend/blend_amount", -1.0);
	level_1_button.grab_focus();
	in_levels = true;

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

func send_to_level(path):
	get_tree().current_scene.get_node("/root/RoomChanger").change_room(path);
func set_back_neighbors(column : int):
	var bot = "../../World 1/1-" + str(column);
	var top = "../../World 3/3-" + str(column);
	
	level_back_button.focus_neighbor_top = NodePath(top);
	level_back_button.focus_neighbor_bottom = NodePath(bot);
	level_back_button.focus_previous = NodePath(top);
	level_back_button.focus_next = NodePath(bot);
