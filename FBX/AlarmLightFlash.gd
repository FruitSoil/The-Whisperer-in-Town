extends OmniLight3D
func _process(_delta: float) -> void:
	var time = Time.get_ticks_msec() / 1000.0
	var wave = sin(time * 4.0) * 5.0
	light_energy = wave + 5
