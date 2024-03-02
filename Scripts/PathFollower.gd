extends PathFollow2D

@export var duration : float = 1.0;
@export var transition_type : Tween.TransitionType;
@export var ease_type : Tween.EaseType;
var elapsed_time : float = 0.0;
var back = false;

func _process(delta):
	back = elapsed_time >= 0.5 * duration;
	
	if not back:
		progress_ratio = Tween.interpolate_value(0.0, 1.0, elapsed_time, duration * 0.5, transition_type, ease_type);
	else:
		progress_ratio = Tween.interpolate_value(1.0, -1.0, elapsed_time - (duration * 0.5), duration * 0.5, transition_type, ease_type);
	
	elapsed_time += delta;
	if elapsed_time >= duration:
		elapsed_time = wrap(elapsed_time, 0.0, duration);
