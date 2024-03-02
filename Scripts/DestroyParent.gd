class_name DestroyParent;
extends Timer

func _ready():
	timeout.connect(func() : get_parent().queue_free());
