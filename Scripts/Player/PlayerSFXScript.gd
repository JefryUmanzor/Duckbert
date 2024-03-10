class_name PlayerSFX
extends Node
@onready var step_sfx = $"Step SFX"
@export var step_pitch_min : float = 1.1;
@export var step_pitch_max : float = 1.4;

@onready var land_sfx = $"Land SFX"

@onready var jump_sfx = $"Jump SFX"
@export var jump_pitch_min : float = 0.8;
@export var jump_pitch_max : float = 1.1;

@onready var gravity_sfx = $"Gravity SFX"
@export var gravity_pitch_min : float = 1.0;
@export var gravity_pitch_max : float = 1.2;

@onready var flap_sfx = $"Flap SFX"
@export var flap_pitch_min : float = 0.8;
@export var flap_pitch_max : float = 1.15;

@onready var fall_sfx = $"Fall SFX"
@onready var fall_land_sfx = $"Fall Land SFX"

func play_fall_sfx():
	fall_sfx.play();
func stop_fall_sfx():
	fall_sfx.stop();
func play_fall_land_sfx():
	fall_land_sfx.play();

func play_step_sfx():
	step_sfx.stop();
	step_sfx.pitch_scale = randf_range(step_pitch_min, step_pitch_max);
	step_sfx.play();

func play_gravity_sfx():
	gravity_sfx.stop();
	gravity_sfx.pitch_scale = randf_range(gravity_pitch_min, gravity_pitch_max);
	gravity_sfx.play();

func play_jump_sfx():
	jump_sfx.stop();
	jump_sfx.pitch_scale = randf_range(jump_pitch_min, jump_pitch_max);
	jump_sfx.play();

func play_flap_sfx():
	flap_sfx.stop();
	flap_sfx.pitch_scale = randf_range(flap_pitch_min, flap_pitch_max);
	flap_sfx.play();

func play_land_sfx():
	land_sfx.stop();
	land_sfx.pitch_scale = randf_range(step_pitch_min, step_pitch_max);
	land_sfx.play();
