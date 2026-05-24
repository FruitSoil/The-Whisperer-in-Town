extends Node
class_name CompJuice

@export var trans: Tween.TransitionType = Tween.TRANS_QUART
@export var ease: Tween.EaseType = Tween.EASE_OUT
@export var time: float = 0.07
@export var scale_value: Vector2 = Vector2(1.1,1.1)

@onready var control: Control = get_parent()

var tw: Tween

func _ready() -> void:
	control.mouse_entered.connect(_on_mouse_hovered.bind(true))
	control.mouse_exited.connect(_on_mouse_hovered.bind(false))


func _on_mouse_hovered(is_hovered: bool):
	set_tween()
	tw.tween_property(control, "scale", scale_value if is_hovered else Vector2.ONE, time)

func set_tween():
	if tw:
		tw.kill()
	tw = create_tween().set_ease(ease).set_trans(trans).set_parallel(true)
