extends PlayerAction

@export var jump_strength : float = -300;
@export_range(0.0, 1.0) var gravity_scale = 0.5;

@export var max_vertical_speed = 250;
var player_max_v_speed = 300;

@onready var m_player = $"../.."
const FLAP_PARTICLE = preload("res://Packed Scenes/Particles/Flap Particle.tscn")

func _activate(player : Player):
	if not player.is_on_spring:
		player.sfx.play_flap_sfx();
		player.velocity.y = jump_strength;
		player.anim.play_jump();
		player.anim.play_flap();
		create_flap_particle()

func _on_enable_action():
	super._on_enable_action();
	m_player.gravity_scale = gravity_scale;
	player_max_v_speed = m_player.max_vertical_speed;
	m_player.max_vertical_speed = max_vertical_speed;

func _on_disable_action():
	super._on_disable_action();
	m_player.gravity_scale = 1.0;
	m_player.max_vertical_speed = player_max_v_speed;

func create_flap_particle():
	var particle = FLAP_PARTICLE.instantiate();
	get_tree().current_scene.get_node("Pausable").add_child(particle);
	particle.global_position = m_player.global_position - Vector2(0.0, 8.0);

func _process(_delta):
	if active:
		if abs(m_player.move_input) > 0.05:
			m_player.char_sprite.flip_h = m_player.move_input < 0
