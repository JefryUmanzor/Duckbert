extends PlayerAction

@export var jump_strength : float = -300;
@export_range(0.0, 1.0) var jump_release_scale : float = 0.35;
const JUMP_PARTICLE = preload("res://Packed Scenes/Particles/Jump Particle.tscn")

var jumping = false;

var m_player : Player;

func _activate(player : Player):
	m_player = player;
	
	if (player.is_on_floor() and not player.is_on_spring) or player.coyote_timer > 0:
		player.reset_coyote_timer();
		player.sfx.play_jump_sfx();
		
		create_jump_particle();
		
		player.anim.play_jump();
		player.anim.play_flap();
		
		jumping = true;
		player.velocity.y = jump_strength;

func create_jump_particle():
	var particle = JUMP_PARTICLE.instantiate();
	get_tree().current_scene.get_node("Pausable").add_child(particle);
	particle.global_position = m_player.global_position;

func _on_release(player : Player):
	if jumping:
		jumping = false;
		player.velocity.y *= jump_release_scale;

func _process(_delta):
	if active:
		if jumping:
			if m_player.velocity.y >= 0:
				jumping = false;
