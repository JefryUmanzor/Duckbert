class_name MusicManager;
extends Node
@export_flags("Intro", "Menu", "Music1") var music_playing : int = 0;

@onready var menu_music = $"Menu Music"
@onready var music_1_intro = $"Music 1 Intro"
@onready var music_1_loop = $"Music 1 Loop"

var stopping_track : AudioStreamPlayer = null;
var stop_amount = 1.0;

var buffer_change_track = false;
var ready_to_change = false;

func _enter_tree():
	buffer_change_track = true;

func ready_buffer():
	buffer_change_track = true;

func _ready():
	get_tree().current_scene.get_node("/root/RoomChanger").on_room_change.connect(ready_buffer);
	ready_to_change = true;

func stop_all_tracks():
	for track : AudioStreamPlayer in get_children():
			if track.playing:
				track.stop();

func change_track(scene_name):
	buffer_change_track = false;
	stopping_track = null;
	
	if scene_name == "Main Menu":
		stop_all_tracks()
		music_playing = 2;
		menu_music.play();
		return;
	if scene_name == "Level 1":
		stop_all_tracks();
		return;
	if scene_name == "World 1":
		if music_playing & 4 != 0:
			return;
		music_playing = 4;
	
	for track : AudioStreamPlayer in get_children():
		if track.playing:
			track.stop();
	
	start_intro_music();

func _process(delta):
	if buffer_change_track and ready_to_change:
		change_track(get_tree().current_scene.name);
	
	stop_amount -= min(stop_amount, (1.0 / 0.5) * delta);
	if stopping_track != null:
		stopping_track.volume_db = lerp(-80.0, 0.0, stop_amount);
		if stop_amount <= 0.1:
			stopping_track.stop;
			stopping_track.volume_db = 0.0;
			stopping_track = null;

func start_1_music():
	music_playing = 4;
	music_1_loop.stop();
	start_intro_music();

func start_intro_music():
	if music_playing & 1 == 0:
		music_playing = music_playing | 1;
	
	if music_playing & 4:
		music_1_intro.play();

func switch_to_loop():
	if music_playing & 1 == 1:
		music_playing = music_playing ^ 1;
	
	if music_playing & 4:
		music_1_loop.play();

func loop_track():
	if music_playing & 4:
		music_1_loop.play();
