extends Area2D

func _on_body_enter(_node):
	if (_node as Player).can_control:
		get_tree().call_deferred("reload_current_scene");
