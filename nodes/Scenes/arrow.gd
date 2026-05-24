extends TextureRect

@export var target: Node3D

func _process(_delta):
	if target and visible:
		var cam = get_viewport().get_camera_3d()
		var time = Time.get_ticks_msec() / 1000.0
		match name:
			"Arrow":
				var wave = sin(time * 4.0) * 15.0
				global_position = cam.unproject_position(target.global_position) + Vector2(0, wave) + Vector2(size.x/2, -size.y)
			"Arrow2":
				var wave = sin(time * 12.0) * 5.0
				global_position = cam.unproject_position(target.global_position) + Vector2(0, wave) + Vector2(size.x * 2.75, -size.y * 1.1)
		if has_meta("ruin"):
			var wave = sin(time * 12.0) * 5.0
			global_position = cam.unproject_position(target.global_position) + Vector2(0, wave) + Vector2(size.x/3, -size.y)

func check(node: Node3D):
	if target == node:
		hide()
