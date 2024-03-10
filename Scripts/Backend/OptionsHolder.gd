class_name Options
extends Node

var options_save : OptionsData;

var options_loaded : bool = false;
var max_scale : int = 2;

const BASE_WIDTH : int = 256;
const BASE_HEIGHT : int = 224;

func _ready():
	get_max_scale();
	load_options();
	apply_options();

func get_max_scale():
	max_scale = 1;
	
	var screen_resolution = DisplayServer.screen_get_size();
	var max_res = min(screen_resolution.x / (BASE_WIDTH as float), screen_resolution.y / (BASE_HEIGHT as float));
	
	max_scale = get_closest_power_of_two(max_res);
	
	print(max_scale);

func get_closest_power_of_two(val : float) -> int:
	var n : int = ceili(val);
	var found = false;
	
	while not found:
		found = ceil(log(n) / log(2)) == floor(log(n) / log(2));
		if not found:
			n -= 1;
	return n;

func save_options():
	var new_save = FileAccess.open("user://options.save", FileAccess.WRITE);
	var json_string = JSON.stringify(options_save.options);
	new_save.store_line(json_string);

func toggle_fullscreen(value):
	options_save.options.is_fullscreen = value;
	save_options();
func switch_stretch(value):
	options_save.options.stretch_mode = value;
	save_options();
func toggle_music(value):
	options_save.options.music_on = value;
	save_options();
func toggle_sfx(value):
	options_save.options.sfx_on = value;
	save_options();

func load_options():
	options_save = OptionsData.new();
	
	if not FileAccess.file_exists("user://options.save"):
		save_options();
		return;
	var options_loaded = FileAccess.open("user://options.save", FileAccess.READ);
	
	var json_string = options_loaded.get_line();
	var json = JSON.new();
	
	var parse_result : Dictionary = json.parse_string(json_string);
	
	options_save.options = parse_result;

func apply_options():
	var window_size : Vector2i = Vector2i(BASE_WIDTH * max_scale, BASE_HEIGHT * max_scale);
	DisplayServer.window_set_size(window_size);
	var size : Vector2i = DisplayServer.screen_get_size(0) / 2;
	DisplayServer.window_set_position((DisplayServer.screen_get_position(0) + size)  - (window_size / 2));
	
	var fullscreen : bool = options_save.options.is_fullscreen;
	
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN);
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED);
	
	get_tree().root.content_scale_stretch = options_save.options.stretch_mode as int;
	
	AudioServer.set_bus_mute(1, not(options_save.options.music_on as bool));
	AudioServer.set_bus_mute(2, not(options_save.options.sfx_on as bool));
	
	options_loaded = true;
