extends TextureRect

@export var target: Node3D

func _ready():
	pivot_offset = size / 2

func _process(_delta):
	if not target or not is_visible_in_tree():
		return
		
	var cam = get_viewport().get_camera_3d()
	if not cam:
		return
	
	var screen_pos = cam.unproject_position(target.global_position)
	var time = Time.get_ticks_msec() / 1000.0
	
	var offset = - (size / 2)
	
	if has_meta("ruin"):
		var wave = sin(time * 12.0) * 5.0
		offset += Vector2(size.x, -size.y + wave)
	elif name == "Arrow" or name == "Arrow3":
		var wave = sin(time * 4.0) * 15.0
		offset += Vector2(0, -size.y + wave)
	else:
		var wave = sin(time * 12.0) * 5.0
		offset += Vector2(177, -size.y + wave + 25)
		
	global_position = screen_pos + offset

func check(node: Node3D):
	if target == node:
		hide()
