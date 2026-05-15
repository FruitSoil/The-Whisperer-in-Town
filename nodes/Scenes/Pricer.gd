extends Label

@export var resource: Global.res_types
@export var value: int

func _process(delta: float) -> void:
	if Global.get_res_value(resource) >= value:
		self_modulate = Color(1.0, 1.0, 1.0, 1.0)
	else:
		self_modulate = Color(1.0, 0.0, 0.0, 1.0)
