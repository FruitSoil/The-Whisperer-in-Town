extends RigidBody3D

var speed = 20.0
var sprint = 1
var y = 14.0
const y_max = 28
const y_min = 5
@onready var camera: Camera3D = $Camera

func _ready() -> void:
	speed = 20

func _physics_process(delta: float) -> void:
	if get_viewport().gui_get_hovered_control() == null:
		if Input.is_action_just_pressed("zoom-"):
			if y < y_max:
				y += 1
		if Input.is_action_just_pressed("zoom+"):
			if y > y_min:
				y -= 1
	camera.size = lerpf(camera.size,y, 0.2)
	
	var input_dir = Input.get_vector("D", "A", "S", "W")
	var direction = Vector3(input_dir.x, 0, input_dir.y)
	if Input.is_action_pressed("Sprint"):
		sprint = 2
	else:
		sprint = 1
	if direction != Vector3.ZERO:
		direction = direction.rotated(Vector3.UP, deg_to_rad(45)).normalized()
		var dir = direction * (speed/20 * position.y) * sprint * delta
		move_and_collide(dir)
