class_name HUD
extends CanvasLayer

@onready var animation_tree = $AnimationTree

@onready var next_level = $"Base/Level Clear Holder/VBoxContainer/HBoxContainer/Next Level"
@onready var level_select = $"Base/Level Clear Holder/VBoxContainer/HBoxContainer/Level Select"

func level_clear():
	animation_tree.set("parameters/Level Clear Shot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE);
	animation_tree.set("parameters/UI Blend/blend_amount", 1.0);
	
	next_level.grab_focus();
