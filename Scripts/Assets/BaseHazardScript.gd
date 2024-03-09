extends Area2D

func _on_body_enter(_node):
	get_tree().call_deferred("reload_current_scene");
