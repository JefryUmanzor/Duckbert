class_name HUD
extends CanvasLayer

@onready var animation_tree = $AnimationTree

@onready var next_level = $"Base/Level Clear Holder/VBoxContainer/HBoxContainer/Next Level"
@onready var level_select = $"Base/Level Clear Holder/VBoxContainer/HBoxContainer/Level Select"

var level_cleared = false;
var focused = false;

var paused = false;

@onready var resume = $"Base/Pause Panel/HBoxContainer/VBoxContainer/Resume"
@onready var restart = $"Base/Pause Panel/HBoxContainer/VBoxContainer/Restart"
@onready var options = $"Base/Pause Panel/HBoxContainer/VBoxContainer/Options"
@onready var pause_level_select = $"Base/Pause Panel/HBoxContainer/VBoxContainer/Level Select"
@onready var main_menu = $"Base/Pause Panel/HBoxContainer/VBoxContainer/Main Menu"

var player : Player = null;

@onready var action_text = $Base/Hud/ActionText

func _ready():
	player = get_tree().current_scene.get_node("Pausable").get_node("Player") as Player;

func _process(delta):
	if Input.is_action_just_pressed("Pause") and not level_cleared:
		paused = !paused;
		if paused:
			player.can_control = false;
			animation_tree.set("parameters/UI Blend/blend_amount", -1.0);
			animation_tree.set("parameters/Pause Shot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE);
			
			resume.grab_focus();
		else:
			unpause();

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

func restart_scene():
	get_tree().reload_current_scene();

func go_to_main_menu():
	get_tree().change_scene_to_file("res://Rooms/Main Menu.tscn");

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