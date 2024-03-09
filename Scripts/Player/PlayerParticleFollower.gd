extends GPUParticles2D

var player : Player;

func _ready():
	player = get_parent().get_parent().get_parent().get_parent() as Player;

func _process(_delta):
	texture = player.char_sprite.texture;
	scale.x = -1 if player.char_sprite.flip_h else 1;
	scale.y = -1 if player.char_sprite.flip_v else 1;
