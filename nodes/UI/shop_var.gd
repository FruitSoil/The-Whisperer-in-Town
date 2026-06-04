extends Panel

@export var res: Building 
@export var is_open: bool = false
@onready var condition: Label = $Condition
@onready var description: RichTextLabel = $Description
@onready var buy: Button = $buy

func _ready() -> void:
	description.mouse_entered.connect(desc_enter)
	description.mouse_exited.connect(desc_exit)
	buy.pressed.connect(_on_buy_pressed)
	buy.mouse_entered.connect(sound_hover)
	update()

func update():
	if is_open == false:
		$Tier.text = "Тир ?"
		$Name.text = "?????????"
		$Description.text = "?????????????????? ???????????????"
		$Image.texture = load("res://Images/UI/icons/icon_lock.PNG")
		$buy/Res_label.text = "????"
		$buy/Res_icon.texture = load("res://Images/UI/icons/icon_lock.PNG")
		$buy/Res_label2.text = "????"
		$buy/Res_icon2.texture = load("res://Images/UI/icons/icon_lock.PNG")
		condition.show()
		condition.text = res.unlock_condition_desc
		return
	if res:
		condition.hide()
		$Name.text = res.name
		$Description.text = res.description
		$Image.texture = res.shop_icon
		$buy/Res_label.text = str(res.buy_cost)
		$buy/Res_label.value = res.buy_cost
		$buy/Res_label.resource = res.buy_cost_type
		$buy/Res_icon.texture = Global.get_res_icon(res.buy_cost_type)
		if res.s_buy_cost > 0:
			$buy/Res_label2.text = str(res.s_buy_cost)
			$buy/Res_label2.value = res.s_buy_cost
			$buy/Res_label2.resource = res.s_buy_cost_type
			$buy/Res_icon2.texture = Global.get_res_icon(res.s_buy_cost_type)
		else:
			$buy/Res_label2.text = ""
			$buy/Res_icon2.texture = null
		match res.tier:
			1:
				$Tier.text = "Тир |"
			2:
				$Tier.text = "Тир ||"
			3:
				$Tier.text = "Тир |||"
			4:
				$Tier.text = "[img=36]res://Images/Resources_icons/actual/imperial_res_icon.png[/img]"
			5:
				$Tier.text = "[img=30]res://Images/Resources_icons/actual/cultistic_res_icon.png[/img]"

func _on_buy_pressed() -> void:
	if is_open:
		if Global.get_res_value(res.buy_cost_type) >= res.buy_cost:
			if Global.get_res_value(res.s_buy_cost_type) >= res.s_buy_cost:
				$Audio/Digital_click_pressed.play()
				Global.add_to_integer_res_type(res.buy_cost_type, -res.buy_cost)
				Global.add_to_integer_res_type(res.s_buy_cost_type, -res.s_buy_cost)
				%BaseUI.switch_to_build(res)
				%BaseUI.change_label(res.buy_cost_type,false)
				%BaseUI.change_label(res.s_buy_cost_type,false)
			else:
				no_res()
		else:
			no_res()
	else:
		no_res()

func no_res():
	$Audio/Digital_no_res.play()
	var twp = create_tween().set_trans(Tween.TRANS_ELASTIC)
	var rnd = randf_range(-6,6)
	var twm = create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	twp.tween_property($buy, "position", Vector2(442.0 +rnd ,0+rnd), 0.2).set_ease(Tween.EASE_IN).from(Vector2(442,0))
	twp.tween_property($buy, "position", Vector2(442.0,0), 0.5).set_ease(Tween.EASE_OUT)
	twm.tween_property($buy, "self_modulate", Color(1.0, 1.0, 1.0, 1.0), 0.7).from(Color(1.0, 0.0, 0.0, 1.0))

func desc_exit():
	description.add_theme_color_override("default_color",Color(1.0, 1.0, 1.0, 1.0))

func desc_enter():
	description.add_theme_color_override("default_color",Color(0.528, 0.784, 0.775, 1.0))

func unlock(res_build:Building):
	if res == res_build:
		print(res_build.name," unlocked!")
		is_open = true
		update()

func sound_hover():
	$Audio/Digital_click_hover.play()
