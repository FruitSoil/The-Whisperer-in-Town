extends CanvasLayer

func _input(event: InputEvent) -> void:
	if event.is_action_released("debug_R"):
		get_tree().reload_current_scene()
		Global.is_zone_1_open = false
		Global.is_zone_2_open = false
		Global.is_zone_3_open = false
		Global.is_zone_4_open = false
		Global.is_zone_5_open = false
