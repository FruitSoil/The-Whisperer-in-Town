extends TextureRect

signal clicked

func _input(event):
	if event is InputEventMouseButton and event.is_action_pressed("displace"):
		if get_global_rect().has_point(event.global_position):
			print("Клик зафиксирован внутри UI, и он летит дальше!")
			clicked.emit()
