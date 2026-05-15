extends Panel

@export var res: Building 
@export var is_open: bool = false
@onready var condition: Label = $Condition

func _ready() -> void:
	$buy.pressed.connect(_on_buy_pressed)
	update()

func update():
	if is_open == false:
		$Name.text = "?????????"
		$Description.text = "?????????????????? ???????????????"
		$Image.texture = load("res://materials/Lock_build.png")
		$buy/Res_label.text = "????"
		$buy/Res_icon.texture = load("res://materials/Lock_build.png")
		$buy/Res_label2.text = "????"
		$buy/Res_icon2.texture = load("res://materials/Lock_build.png")
		$BG/MC/VBC/Star_1.hide()
		$BG/MC/VBC/Star_2.hide()
		$BG/MC/VBC/Star_3.hide()
		$Condition.show()
		return
	if res:
		$Condition.hide()
		$Name.text = res.name
		$Description.text = res.description
		$Image.texture = res.shop_icon
		$buy/Res_label.text = str(res.buy_cost)
		$buy/Res_label.value = res.buy_cost
		$buy/Res_label.resource = res.buy_cost_type
		$buy/Res_icon.texture = Global.get_res_icon(res.buy_cost_type)
		$buy/Res_label2.text = str(res.buy_cost)
		$buy/Res_label2.value = res.buy_cost
		$buy/Res_label2.resource = res.buy_cost_type
		$buy/Res_icon2.texture = Global.get_res_icon(res.buy_cost_type)
		match res.tier:
			1:
				$BG/MC/VBC/Star_1.show()
				$BG/MC/VBC/Star_2.hide()
				$BG/MC/VBC/Star_3.hide()
			2:
				$BG/MC/VBC/Star_1.show()
				$BG/MC/VBC/Star_2.show()
				$BG/MC/VBC/Star_3.hide()
			3:
				$BG/MC/VBC/Star_1.show()
				$BG/MC/VBC/Star_2.show()
				$BG/MC/VBC/Star_3.show()

func _on_buy_pressed() -> void:
	if is_open:
		if Global.get_res_value(res.buy_cost_type) >= res.buy_cost:
			Global.add_to_integer_res_type(res.buy_cost_type, -res.buy_cost)
			%BaseUI.switch_to_build(res)
		else:
			no_res()
		%BaseUI.change_label(res.buy_cost_type,false)
	else:
		no_res()

func no_res():
	var twp = create_tween().set_trans(Tween.TRANS_ELASTIC)
	var rnd = randf_range(-6,6)
	var twm = create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	twp.tween_property($buy, "position", Vector2(430.0 +rnd ,0+rnd), 0.2).set_ease(Tween.EASE_IN).from(Vector2(427,0))
	twp.tween_property($buy, "position", Vector2(430.0,0), 0.5).set_ease(Tween.EASE_OUT)
	twm.tween_property($buy, "self_modulate", Color(1.0, 1.0, 1.0, 1.0), 0.7).from(Color(1.0, 0.0, 0.0, 1.0))
