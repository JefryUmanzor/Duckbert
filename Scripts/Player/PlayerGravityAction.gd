extends PlayerAction

@export var negative_palette_path : String = "res://Sprites/Palettes/PAL Blue.png"
@export_range(-1.0, 1.0) var y_vel_scale = 0.5;
var flipped : bool = false; 

var negative_palette_texture : Texture2D;

const GRAVITY_DOWN_PARTICLE = preload("res://Packed Scenes/Particles/Gravity Down Particle.tscn")
const GRAVITY_UP_PARTICLE = preload("res://Packed Scenes/Particles/Gravity Up Particle.tscn")

@onready var m_player = $"../.."

func _ready():
	super._ready();
	negative_palette_texture = load(negative_palette_path) as Texture2D

func _activate(player : Player):
	if player.is_on_floor() or player.coyote_timer > 0:
		player.sfx.play_gravity_sfx()
		player.reset_coyote_timer();
		
		player.velocity.y *= y_vel_scale;
		player.gravity_scale *= -1;
		player.up_direction *= -1;
		
		player.anim.play_jump();
		player.anim.play_flap();
		
		flipped = !flipped;
		player.char_sprite.flip_v = flipped; 
		if abs(player.move_input) > 0.05:
			player.char_sprite.flip_h = player.move_input < 0
		
		spawn_particle(flipped);
		sprite_handler.set_palette(palette_texture if player.gravity_scale == 1 else negative_palette_texture);

func _on_death(_player : Player):
	if _player.gravity_scale < 0:
		_player.velocity.y *= y_vel_scale;
		_player.gravity_scale *= -1;
		_player.up_direction *= -1;
		
		flipped = false;
		_player.char_sprite.flip_v = flipped; 
		sprite_handler.set_palette(palette_texture);

func _on_disable_action():
	if m_player.gravity_scale < 0:
		m_player.velocity.y *= y_vel_scale;
		m_player.gravity_scale *= -1;
		m_player.up_direction *= -1;
		
		flipped = false;
		m_player.char_sprite.flip_v = flipped; 
	
	active = false;

func spawn_particle(up):
	var particle = (GRAVITY_UP_PARTICLE if up else GRAVITY_DOWN_PARTICLE).instantiate();
	m_player.add_child(particle);
