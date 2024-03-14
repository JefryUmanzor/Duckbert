class_name SaveLoad
extends Node

var options_save : OptionsData;
var game_save : GameData;

var options_loaded : bool = false;
var game_save_loaded : bool = false;
var max_scale : int = 2;

const BASE_WIDTH : int = 256;
const BASE_HEIGHT : int = 224;

func _ready():
	get_max_scale();
	load_game();
	load_options();
	apply_options();

func get_max_scale():
	max_scale = 1;
	
	var screen_resolution = DisplayServer.screen_get_size();
	var max_res = min(screen_resolution.x / (BASE_WIDTH as float), screen_resolution.y / (BASE_HEIGHT as float));
	
	max_scale = get_closest_power_of_two(max_res);

func get_closest_power_of_two(val : float) -> int:
	var n : int = ceili(val);
	var found = false;
	
	while not found:
		found = ceil(log(n) / log(2)) == floor(log(n) / log(2));
		if not found:
			n -= 1;
	return n;

func load_game():
	game_save = GameData.new();
	
	if not FileAccess.file_exists("user://game.save"):
		save_game();
		game_save_loaded = true;
		return;
	var game_loaded = FileAccess.open("user://game.save", FileAccess.READ);
	
	var json_string = game_loaded.get_line();
	var json = JSON.new();
	
	var parse_result : int = json.parse_string(json_string);
	
	game_save.save = parse_result;
	game_loaded.close();
	game_save_loaded = true;

func write_save(level_bit):
	if game_save.save & level_bit == 0:
		game_save.save = game_save.save | level_bit;
		save_game();

func save_game():
	var new_save = FileAccess.open("user://game.save", FileAccess.WRITE);
	var json_string = JSON.stringify(game_save.save);
	new_save.store_line(json_string);
	new_save.close();

func save_options():
	var new_save = FileAccess.open("user://options.save", FileAccess.WRITE);
	var json_string = JSON.stringify(options_save.options);
	new_save.store_line(json_string);
	new_save.close();

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
	var options_file_loaded = FileAccess.open("user://options.save", FileAccess.READ);
	
	var json_string = options_file_loaded.get_line();
	var json = JSON.new();
	
	var parse_result : Dictionary = json.parse_string(json_string);
	
	options_save.options = parse_result;
	options_file_loaded.close();

func set_windowed_size():
	var window_size : Vector2i = Vector2i(BASE_WIDTH * max_scale, BASE_HEIGHT * max_scale);
	DisplayServer.window_set_size(window_size);
	var size : Vector2i = DisplayServer.screen_get_size(0) / 2;
	DisplayServer.window_set_position((DisplayServer.screen_get_position(0) + size)  - (window_size / 2));

func reset_window_size():
	var window_size : Vector2i = Vector2i(BASE_WIDTH, BASE_HEIGHT);
	DisplayServer.window_set_size(window_size);
	DisplayServer.window_request_attention();

func apply_options():
	set_windowed_size();
	
	var fullscreen : bool = options_save.options.is_fullscreen;
	
	if fullscreen:
		reset_window_size()
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN);
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED);
	
	get_tree().root.content_scale_stretch = options_save.options.stretch_mode as int;
	
	AudioServer.set_bus_mute(1, not(options_save.options.music_on as bool));
	AudioServer.set_bus_mute(2, not(options_save.options.sfx_on as bool));
	
	options_loaded = true;
