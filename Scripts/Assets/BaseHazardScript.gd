extends Area2D

func _on_body_enter(_node):
	var player : Player = (_node as Player)
	if player.can_control:
		player.start_death();
