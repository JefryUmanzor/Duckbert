extends Camera2D

@export var target : Player;
var target_position : Vector2;
@export_flags_2d_physics var ray_mask : int = 8;
@export var bounds : CollisionShape2D;

func _ready():
	target_position = target.global_position;
	if bounds != null:
		var rect : Rect2 = bounds.shape.get_rect();
		var width : float = ProjectSettings.get_setting("display/window/size/viewport_width") as float;
		var height : float = ProjectSettings.get_setting("display/window/size/viewport_height") as float;
		
		limit_left = bounds.global_position.x - (rect.size.x * 0.5)
		limit_right = bounds.global_position.x + (rect.size.x * 0.5)
		limit_bottom = bounds.global_position.y + (rect.size.y * 0.5)
		limit_top = bounds.global_position.y - (rect.size.y * 0.5)

func _physics_process(delta):
	call_deferred("resolve_movement");

func resolve_movement():
	target_position = target.global_position - (Vector2(0.0, 8));
	var final_position : Vector2 = target_position;
	
	global_position = final_position;
