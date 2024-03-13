extends Area2D

@onready var bg = $"../ParallaxBackground/BG/BG"
@onready var animation_player = $"../ParallaxBackground/BG/BG/AnimationPlayer"

func trigger_color_change(_body):
	if bg.blend <= 0.5:
		animation_player.play("ChangeToBrown");
	else:
		animation_player.play("ChangeToGray");
