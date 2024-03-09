extends Node2D

func on_touch_player(_player):
	get_tree().current_scene.get_node("GUI").level_clear();
	(_player as Player).can_control = false;
