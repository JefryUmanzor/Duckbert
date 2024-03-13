extends Camera2D

@export var target : Player;
var target_position : Vector2;
@export_flags_2d_physics var ray_mask : int = 8;
@export var bounds : CollisionShape2D;
var follow_target = true;

func _ready():
	target_position = target.global_position;
	if bounds != null:
		var rect : Rect2 = bounds.shape.get_rect();
		
		limit_left = bounds.global_position.x - (rect.size.x * 0.5)
		limit_right = bounds.global_position.x + (rect.size.x * 0.5)
		limit_bottom = bounds.global_position.y + (rect.size.y * 0.5)
		limit_top = bounds.global_position.y - (rect.size.y * 0.5)

func _physics_process(_delta):
	call_deferred("resolve_movement");

func resolve_movement():
	if follow_target:
		target_position = target.global_position - (Vector2(0.0, 8));
		var final_position : Vector2 = target_position;
		
		global_position = final_position;
