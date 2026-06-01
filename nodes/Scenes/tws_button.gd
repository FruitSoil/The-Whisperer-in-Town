extends Node
class_name CompJuice

@export var trans: Tween.TransitionType = Tween.TRANS_QUART
@export var ease_: Tween.EaseType = Tween.EASE_OUT
@export var time: float = 0.07
@export var scale_value: Vector2 = Vector2(1.1,1.1)
@export var small_scale_value: Vector2 = Vector2(1.1,1.1)
@export var init_scale: Vector2 = Vector2(1,1)

@onready var control: Control = get_parent()

var tw: Tween

func _ready() -> void:
	control.mouse_entered.connect(_on_mouse_hovered.bind(true))
	control.mouse_exited.connect(_on_mouse_hovered.bind(false))

func _on_mouse_hovered(is_hovered: bool):
	if set_tween():
		if control is BaseButton:
			if control.disabled:
				tw.tween_property(control, "scale", small_scale_value if is_hovered else init_scale, time)
			if control.has_meta("buy"):
				if control.get_parent().is_open == false:
					tw.tween_property(control, "scale", small_scale_value if is_hovered else init_scale, time)
		tw.tween_property(control, "scale", scale_value if is_hovered else init_scale, time)

func set_tween() -> bool:
	if tw:
		tw.kill()
	tw = create_tween().set_ease(ease_).set_trans(trans).set_parallel(true)
	return true
