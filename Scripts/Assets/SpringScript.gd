extends Node2D

@export var bounce_strength : float = -300;
@onready var animation_tree = $AnimationTree
@onready var animatable_body_2d = $AnimatableBody2D
@onready var area_2d = $AnimatableBody2D/Area2D

@onready var bounce_sfx = $"Bounce SFX"
@onready var down_sfx = $"Down SFX"

var up_direction;
var actual_player : Node2D;
var player : Player = null;

var started_bounce = false;

func _ready():
	up_direction = sign(-transform.y.y);
	actual_player = get_tree().current_scene.get_node("Pausable").get_node("Player");

func on_player_enter(body):
	player = body as Player;
func on_player_exit(_body):
	player.is_on_spring = false;
	player = null;

func _process(_delta):
	if player != null and started_bounce:
		player.is_on_spring = true;
	
	if player != null and not started_bounce:
		if up_direction < 0:
			if actual_player.global_position.y <= area_2d.global_position.y and player.velocity.y >= 0.0: 
				if player:
					player.is_on_spring = true;
				started_bounce = true;
				down_sfx.pitch_scale = randf_range(0.9,1.1);
				down_sfx.play();
				animation_tree.set("parameters/Bounce Shot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE);
		else:
			if actual_player.global_position.y >= area_2d.global_position.y + 16 and player.velocity.y <= 0.0:
				if player:
					player.is_on_spring = true;
				down_sfx.pitch_scale = randf_range(0.9,1.1);
				down_sfx.play();
				started_bounce = true; 
				animation_tree.set("parameters/Bounce Shot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE);

func apply_bounce():
	if player != null:
		player.is_on_spring = false;
		player.velocity.y = bounce_strength * up_direction;
		player.anim.play_jump();
		animatable_body_2d.constant_linear_velocity = Vector2.ZERO;
	bounce_sfx.pitch_scale = randf_range(0.9,1.1);
	bounce_sfx.play();
	started_bounce = false;
