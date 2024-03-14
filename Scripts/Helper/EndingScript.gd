extends CanvasLayer


func _process(delta):
	if Input.is_action_just_pressed("PlayerAction"):
		(get_node("/root/RoomChanger") as RoomManager).change_room("res://Rooms/Main Menu.tscn");
