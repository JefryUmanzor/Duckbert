extends Area2D

@export var action_index: int = 0;

func _ready():
	body_entered.connect(on_player_enter);

func on_player_enter(node):
	var player = node as Player;
	
	player.change_ability(action_index);
