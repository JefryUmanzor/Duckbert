class_name PlayerAction
extends Node

@export var palette_path : String  = "res://Palettes/PAL Grey.png";
@export var action_name : String = "None";
@onready var sprite_handler : PlayerAnimationHandler = $"../../Sprite"

signal on_activated;

var palette_texture : Texture2D;
var active = false;

func _ready():
	palette_texture = load(palette_path) as Texture2D;

func _activate(_player : Player):
	pass;
func _on_release(_player : Player):
	pass;

func _on_death(_player : Player):
	pass;

func _on_enable_action(first):
	if not first:
		on_activated.emit();
	active = true;
	sprite_handler.set_palette(palette_texture);
	RenderingServer.global_shader_parameter_set("player_current_palette", palette_texture);

func _on_disable_action():
	active = false;
