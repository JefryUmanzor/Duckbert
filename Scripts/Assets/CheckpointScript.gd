class_name Checkpoint;
extends Node2D

@onready var animation_tree = $AnimationTree
var activated = false;

signal on_touch(this : Checkpoint);

func on_touch_player(_player):
	if not activated:
		activated = true;
		animation_tree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE);
		animation_tree.set("parameters/Blend2/blend_amount", 1.0);
		on_touch.emit(self);
