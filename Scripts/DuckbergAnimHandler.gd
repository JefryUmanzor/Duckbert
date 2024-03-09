class_name PlayerAnimationHandler
extends Node2D

@onready var sprite_animation = $"Sprite Animation/AnimationTree"
@onready var scale_animation = $"Squash Animation/AnimationPlayer"

@onready var player = $".."
@onready var sprite = $Sprite2D

const LAND_PARTICLE = preload("res://Packed Scenes/Particles/Land Particle.tscn")

func _process(delta):
	var walk_blend = sprite_animation.get("parameters/Walk Blend/blend_position") as float;
	if player.is_on_floor():
		walk_blend = clampf(abs(player.velocity.x) / player.top_speed, 0.0, 1.0);
	else:
		walk_blend = move_toward(walk_blend, 0.0, (1.0/0.2) * delta)
	
	sprite_animation.set("parameters/Gravity Switched/blend_amount", 1.0 if player.up_direction.y > 0.0 else 0.0)
	sprite_animation.set("parameters/Walk Blend/blend_position", walk_blend);
	sprite_animation.set("parameters/Grav Walk Blend/blend_position", walk_blend);
	
	if walk_blend <= 0.05:
		sprite_animation.set("parameters/SPR Scale/scale", 0.0);
		sprite_animation.set("parameters/SPR Time/seek_request", 0.0);
	else:
		sprite_animation.set("parameters/SPR Scale/scale", 1.0)

func set_palette(palette_texture : Texture2D):
	sprite.material.set_shader_parameter("use_palette", true);
	sprite.material.set_shader_parameter("current_palette", palette_texture)
func remove_palette():
	sprite.material.set_shader_parameter("use_palette", true);

func create_land_particle():
	var floor_down = player.up_direction.y < 0;
	var particle = LAND_PARTICLE.instantiate();
	get_tree().current_scene.get_node("Pausable").add_child(particle);
	particle.global_position = player.global_position + (Vector2.UP * (0.0 if floor_down else 12.0));

func play_jump():
	if scale_animation.is_playing():
		scale_animation.stop();
	scale_animation.play("Jump");
func play_land_squash():
	if scale_animation.is_playing():
		scale_animation.stop();
	
	create_land_particle();
	scale_animation.play("Land");

func play_flap():
	sprite_animation.set("parameters/Flap Shot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE);
