extends CharacterBody3D

var speed = 7.0
var sprint = 1
var y = 20
const y_max = 20
const y_min = 2
@onready var camera: Camera3D = $Camera
@onready var camera_zoom: AudioStreamPlayer = $"../Audio/CameraZoom"
@onready var offset_time: Timer = $"../Audio/CameraZoom/OffsetTime"

var smooth_dir = Vector3.ZERO
var can_sound: bool = true

func _ready() -> void:
	offset_time.timeout.connect(timeout)

func timeout():
	can_sound = true

func _physics_process(delta: float) -> void:
	if get_viewport().gui_get_hovered_control() == null:
		if Input.is_action_just_pressed("zoom-"):
			if y < y_max:
				y += 0.5
				if can_sound:
					can_sound = false
					offset_time.start()
					camera_zoom.pitch_scale = 1.0
					camera_zoom.play()
		if Input.is_action_just_pressed("zoom+"):
			if y > y_min:
				y -= 0.5
				if can_sound:
					can_sound = false
					offset_time.start()
					camera_zoom.pitch_scale = 0.8
					camera_zoom.play()
	camera.size = lerpf(camera.size,y, 0.2)
	
	var input_dir = Input.get_vector("D", "A", "S", "W")
	var target_direction = Vector3(input_dir.x, 0, input_dir.y)
	
	if Input.is_action_pressed("Sprint"):
		sprint = 1.5
	else:
		sprint = 1
		
	if target_direction != Vector3.ZERO:
		target_direction = target_direction.rotated(Vector3.UP, deg_to_rad(45)).normalized()
	
	smooth_dir = smooth_dir.lerp(target_direction, 10.0 * delta)
	var dir = smooth_dir * (speed/10 * camera.size) * sprint * delta
	velocity = dir * 40
	move_and_slide()
