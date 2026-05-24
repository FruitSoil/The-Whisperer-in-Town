extends CanvasLayer

@onready var touch_1: Button = $Control/CG/Slide_1/Touch1
@onready var touch_2: Button = $Control/CG/Slide_2/Touch1
@onready var touch_3: Button = $Control/CG/Slide_3/Touch3
@onready var touch_4: Button = $Control/CG/Slide_4/Touch3
@onready var touch_5: Button = $Control/CG/Slide_5/Touch5

var tutorial_stage: int

var builduing_displaced: int = 0

func _ready() -> void:
	$Control/CG/Slide_1.hide()
	$Control/CG/Slide_2.hide()
	$Control/CG/Slide_3.hide()
	$Control/CG/Slide_4.hide()
	$Control/CG/Slide_5.hide()
	touch_1.pressed.connect(pressed.bind(1))
	touch_2.pressed.connect(pressed.bind(2))
	touch_3.pressed.connect(pressed.bind(3))
	touch_4.pressed.connect(pressed.bind(4))
	touch_5.pressed.connect(pressed.bind(5))
	stage_change(1)

func stage_change(stage: int = tutorial_stage):
	tutorial_stage = stage
	match tutorial_stage:
		1:
			$Control/CG/Slide_1.show()
			twmf($Control/CG/Slide_1/Label,2)
		2:
			$Control/CG/Slide_2.show()
			await get_tree().create_timer(4).timeout
			twmf($Control/CG/Slide_2/Label,2)
			twmf($Control/CG/Slide_2,4)
		3:
			$Control/CG/Slide_3.show()
			twmf($Control/CG/Slide_3/Label,2)
		4:
			$Control/CG/Slide_4.show()
			twmf($Control/CG/Slide_4,2)
			twmf($Control/CG/Slide_4/Label,2)
		-1:
			$"../HUD/Arrow".show()
		-2:
			await get_tree().create_timer(2).timeout
			$"../HUD/Arrow2".show()
		5:
			$Control/CG/Slide_5.show()
			twmf($Control/CG/Slide_5/Label,2)


func twmf(node, time: int):
	if node is ColorRect:
		var twm = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		twm.tween_property(node, "color", Color(0.0, 0.0, 0.0, 0.655), time).from(Color(0.0, 0.0, 0.0, 0.0))
	else:
		var twm = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		twm.tween_property(node, "modulate", Color(1.0, 1.0, 1.0, 1.0), time).from(Color(1.0, 1.0, 1.0, 0.0))

func pressed(ID: int):
	match ID:
		1:
			$Control/CG/Slide_1.hide()
			stage_change(2)
			
			%ADMIN.get_dialogue()
		2:
			$Control/CG/Slide_2.hide()
			stage_change(5)
			
			$"../Dialogue/Panel/VBC/Variant_yes".emit_signal("pressed")
		3:
			$Control/CG/Slide_3.hide()
			%BaseUI._on_store_pressed()
			stage_change(4)
		4:
			$Control/CG/Slide_4.hide()
			$"../HUD/BaseUI/Store_UI/Build_scroll_list/VBС/lvl"._on_buy_pressed()
			stage_change(-1)
		-1:
			$"../HUD/Arrow".hide()
		-2:
			$"../HUD/Arrow2".hide()
		5:
			$Control/CG/Slide_5.hide()
			$"../HUD/BaseUI/Demolition".emit_signal("pressed")
			stage_change(3)
