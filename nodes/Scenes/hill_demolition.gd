extends Node3D

var is_shaking: bool = false
var shake: float = 0.025

var dynamic_pos: Vector3 

func _ready():
	dynamic_pos = position

func _process(_delta):
	if is_shaking:
		var offset = Vector3(
			randf_range(-shake, shake),
			randf_range(-shake, shake),
			randf_range(-shake, shake))
		position = dynamic_pos + offset

func start_demolition():
	$Demolition_parts.emitting = true
	is_shaking = true
	
	var twp = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	twp.tween_property(self, "dynamic_pos", Vector3(dynamic_pos.x, -12, dynamic_pos.z), 4)
	await get_tree().create_timer(5).timeout
	is_shaking = false
