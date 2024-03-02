extends PlayerAction

@export var acceleration : float = 1200;
@export_range(0.0, 1.0) var start_hover_scale : float = 0.75;

var holding : bool = false;
var m_player : Player;

func _activate(player : Player):
	player.gravity_scale = 0.0;
	holding = true;
	m_player = player;
	if player.velocity.y > 0:
		player.velocity.y *= start_hover_scale;

func _on_release(player : Player):
	player.gravity_scale = 1.0;
	holding = false;

func _process(_delta):
	if m_player != null and active:
		if abs(m_player.move_input) > 0.05:
			m_player.char_sprite.flip_h = m_player.move_input < 0

func _physics_process(delta):
	if holding:
		m_player.velocity.y -= acceleration * delta;
