extends CanvasLayer

@onready var touch_1: Button = $Control/CG/Slide_1/Touch1
@onready var touch_2: Button = $Control/CG/Slide_2/Touch1
@onready var touch_3: Button = $Control/CG/Slide_3/Touch3
@onready var touch_4: Button = $Control/CG/Slide_4/Touch3
@onready var touch_5: Button = $Control/CG/Slide_5/Touch5
@onready var touch_6: Button = $Control/CG/Slide_6/Touch5

var arrows_ruin: Array

var tutorial_stage: int

var builduing_displaced: int = 0

func _ready() -> void:
	$Control/CG/Slide_1.hide()
	$Control/CG/Slide_2.hide()
	$Control/CG/Slide_3.hide()
	$Control/CG/Slide_4.hide()
	$Control/CG/Slide_5.hide()
	$Control/CG/Slide_6.hide()
	touch_1.pressed.connect(pressed.bind(1))
	touch_2.pressed.connect(pressed.bind(2))
	touch_3.pressed.connect(pressed.bind(3))
	touch_4.pressed.connect(pressed.bind(4))
	touch_5.pressed.connect(pressed.bind(5))
	touch_6.pressed.connect(pressed.bind(6))
	stage_change(1)
	await get_tree().create_timer(1).timeout
	arrows_ruin = [$"../HUD/RuinArrow", $"../HUD/RuinArrow2", $"../HUD/RuinArrow3", $"../HUD/RuinArrow4", $"../HUD/RuinArrow5"]

func stage_change(stage: int = tutorial_stage):
	tutorial_stage = stage
	print("tutorial stage: ", tutorial_stage)
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
			for i in arrows_ruin:
				i.hide()
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
			
		6:
			twmf($Control/CG/Slide_6,2)
			$Control/CG/Slide_6.show()
			

func twmf(node, time: float,to_black: bool = true):
	if node is ColorRect:
		if to_black:
			var twm = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			twm.tween_property(node, "color", Color(0.0, 0.0, 0.0, 0.655), time).from(Color(0.0, 0.0, 0.0, 0.0))
		else:
			var twm = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			twm.tween_property(node, "color", Color(0.0, 0.0, 0.0, 0.0), time).from(Color(0.0, 0.0, 0.0, 0.655))
	else:
		if to_black:
			var twm = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			twm.tween_property(node, "modulate", Color(1.0, 1.0, 1.0, 1.0), time).from(Color(1.0, 1.0, 1.0, 0.0))
		else:
			var twm = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			twm.tween_property(node, "modulate", Color(1.0, 1.0, 1.0, 0.0), time).from(Color(1.0, 1.0, 1.0, 1.0))

func pressed(ID: int):
	match ID:
		1:
			stage_change(2)
			
			%ADMIN.get_dialogue()
			$Control/CG/Slide_1.mouse_filter = 2
			twmf($Control/CG/Slide_1,1,false)
			twmf($Control/CG/Slide_1/Label,0.5,false)
			await get_tree().create_timer(1).timeout
			$Control/CG/Slide_1.hide()
		2:
			$Control/CG/Slide_2.hide()
			stage_change(5)
			
			$"../Dialogue/Panel/VBC/Variant_yes".emit_signal("pressed")
		3:
			$Control/CG/Slide_3.hide()
			%BaseUI._on_store_pressed()
			stage_change(4)
		4:
			
			$"../HUD/BaseUI/Store_UI/Build_scroll_list/VBС/lvl"._on_buy_pressed()
			stage_change(-1)
			$Control/CG/Slide_4.mouse_filter = 2
			twmf($Control/CG/Slide_4,0.5,false)
			twmf($Control/CG/Slide_4/Label,0.5,false)
			await get_tree().create_timer(0.5).timeout
			$Control/CG/Slide_4.hide()
		-1:
			$"../HUD/Arrow".hide()
		-2:
			$"../HUD/Arrow2".hide()
			stage_change(6)
		5:
			
			$"../HUD/BaseUI/Demolition".emit_signal("pressed")
			for i in arrows_ruin:
				i.visible = true
			
			$Control/CG/Slide_5.mouse_filter = 2
			twmf($Control/CG/Slide_5,1,false)
			twmf($Control/CG/Slide_5/Label,0.5,false)
			await get_tree().create_timer(1).timeout
			$Control/CG/Slide_5.hide()
		6:
			$"../HUD/BaseUI/workers_panel/Default_worker".emit_signal("pressed")
			$Control/CG/Slide_6.hide()
