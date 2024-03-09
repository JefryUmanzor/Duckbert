class_name Options
extends Node

var options_save : OptionsData;

var options_loaded : bool = false;

func _ready():
	load_options();
	apply_options();

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
	var fullscreen : bool = options_save.options.is_fullscreen;
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN);
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED);
	
	get_tree().root.content_scale_stretch = options_save.options.stretch_mode as int;
	
	AudioServer.set_bus_mute(1, options_save.options.music_on as bool);
	AudioServer.set_bus_mute(2, options_save.options.sfx_on as bool);
	
	options_loaded = true;
