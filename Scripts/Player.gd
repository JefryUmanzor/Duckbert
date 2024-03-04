class_name Player
extends CharacterBody2D

var grav_path = "physics/2d/default_gravity"
var grav_dir_path = "physics/2d/default_gravity_vector"

@export var top_speed : float = 500;
@export var acceleration : float = 200;
@export var turnaround_accel : float = 500;
@export var decceleration : float = 500;

@onready var actions = $Actions
@export var starting_action : int = 0;
@onready var anim : PlayerAnimationHandler = $Sprite
@onready var char_sprite : Sprite2D = $Sprite/Sprite2D

@export var max_vertical_speed : float = 1000;
var gravity_scale : float = 1.0;

var current_action : PlayerAction;
var move_input : int = 0;
var grounded = true;

var moving = false;
var step_timer = 0.0;
@export var max_step_time : float = 0.25;

const STEP_PARTICLE = preload("res://Packed Scenes/Particles/Step Particle.tscn")
const GRAV_STEP_PARTICLE = preload("res://Packed Scenes/Particles/Grav Step Particle.tscn")
const ABILITY_CHANGE_PARTICLE = preload("res://Packed Scenes/Particles/Ability Change Particle.tscn")

var start_timer = 0.05;
var start_step_timer = 0.02;

var coyote_timer = 0.0;
@export var max_coyote_time = 0.15;
var is_on_spring = false;
var turning_around = false;

@onready var sfx : PlayerSFX = $SFX

func _ready():
	starting_action = wrapi(starting_action, 0, actions.get_child_count());
	current_action = actions.get_child(starting_action) as PlayerAction;
	current_action._on_enable_action();

func _process(delta):
	if Input.is_action_just_pressed("PlayerAction"):
		current_action._activate(self);
	if Input.is_action_just_released("PlayerAction"):
		current_action._on_release(self);
	
	if is_on_floor() and not grounded and start_timer <= 0:
		anim.play_land_squash();
		if not is_on_spring:
			sfx.play_land_sfx();
	
	if not is_on_floor() and grounded:
		coyote_timer = max_coyote_time;
	
	grounded = is_on_floor();
	
	if not moving and move_input != 0 and grounded and start_step_timer > 0.0:
		create_step_particle();
	moving = move_input != 0 and grounded and abs(velocity.x) > 0.02;
	
	if move_input != 0:
		start_step_timer -= delta;
	else:
		start_step_timer = 0.01;
	
	if moving:
		step_timer += delta;
		if turning_around:
			step_timer *= 1.5;
	else:
		step_timer = 0.0;
		
	if step_timer >= max_step_time:
		step_timer = 0.0;
		create_step_particle();
	
	coyote_timer -= min(delta, coyote_timer);
	start_timer -= delta;
	
	if abs(velocity.y) > 0.0 and sign(velocity.y) == sign(up_direction.y):
		coyote_timer = 0.0; 

func reset_coyote_timer():
	coyote_timer = 0.0;

func create_step_particle():
	if is_on_floor():
		sfx.play_step_sfx();
		var on_floor = up_direction.y < 0;
		var particle = (STEP_PARTICLE if on_floor else GRAV_STEP_PARTICLE).instantiate();
		get_tree().current_scene.get_node("Pausable").add_child(particle);
		particle.global_position = global_position + (Vector2.UP * (0.0 if on_floor else 16.0));

func create_ability_particle():
	var particle = ABILITY_CHANGE_PARTICLE.instantiate();
	char_sprite.add_child(particle);

func _physics_process(delta):
	var gravity = (ProjectSettings.get_setting(grav_dir_path) as Vector2) * (ProjectSettings.get_setting(grav_path) as float)
	velocity += gravity * gravity_scale * delta;
	
	if abs(velocity.y) > max_vertical_speed:
		if sign(velocity.y) != sign(up_direction.y):
			velocity.y = max_vertical_speed * -sign(up_direction.y);
	
	move_input = sign(Input.get_axis("PlayerLeft", "PlayerRight"));
	var target_speed = top_speed * sign(move_input);
	var slowing = abs(velocity.x) > abs(target_speed);
	
	var accel = 0.0;
	
	if is_on_floor() and abs(move_input) > 0.05:
		char_sprite.flip_h = move_input < 0
	
	if slowing:
		accel = min(decceleration * delta, abs(target_speed - velocity.x)) * -sign(velocity.x);
	else:
		turning_around = sign(velocity.x) != sign(move_input);
		if turning_around:
			accel = turnaround_accel * delta * sign(move_input);
		else:
			accel = acceleration * delta * sign(move_input);
	
	velocity.x += accel;
	
	move_and_slide();
	
	if is_on_floor():
		velocity.y = 0.0;

func change_ability(action_index):
	action_index = wrapi(action_index, 0, actions.get_child_count());
	var target_action = actions.get_child(action_index);
	
	if current_action != target_action:
		current_action._on_disable_action();
		
		current_action =  target_action as PlayerAction;
		current_action._on_enable_action();
		
		if start_timer <= 0:
			create_ability_particle();
