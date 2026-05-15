extends RigidBody3D

var speed = 7.0
var sprint = 1
var y = 14.0
const y_max = 20
const y_min = 2
@onready var camera: Camera3D = $Camera

func _physics_process(delta: float) -> void:
	if get_viewport().gui_get_hovered_control() == null:
		if Input.is_action_just_pressed("zoom-"):
			if y < y_max:
				y += 0.5
		if Input.is_action_just_pressed("zoom+"):
			if y > y_min:
				y -= 0.5
	camera.size = lerpf(camera.size,y, 0.2)
	
	var input_dir = Input.get_vector("D", "A", "S", "W")
	var direction = Vector3(input_dir.x, 0, input_dir.y)
	if Input.is_action_pressed("Sprint"):
		sprint = 1.5
	else:
		sprint = 1
	if direction != Vector3.ZERO:
		direction = direction.rotated(Vector3.UP, deg_to_rad(45)).normalized()
		var dir = direction * (speed/10 * camera.size) * sprint * delta
		move_and_collide(dir)
