extends Control

var building_state: bool = false 
var selected_build: Building = null
var worker_state: bool = false 
var selected_worker: Worker = null
var demolition_state: bool = false
var chance: int = 0
var selected_zone: Zone

var store_scroll_max: float = -1450.0 
var quest_scroll_max: float = -350.0 

func _ready() -> void:
	change_all_label(false)
	_on_exit_pressed()

func _input(event: InputEvent) -> void:
	if event.is_action_released("displace") and building_state:
		get_tree().call_group("cell", "_mouse_exit")
		building_state = false
		Global.add_to_integer_res_type(selected_build.buy_cost_type,selected_build.buy_cost)
		change_all_label(true)
	if event.is_action_released("displace") and worker_state:
		get_tree().call_group("cell", "_mouse_exit")
		if selected_worker.resource_name == "Default":
			Global.add_to_integer_res_type(2,10)
			change_label(2,true)
		worker_state = false

func _on_quest_pressed() -> void:
	if $Quest_UI.visible == false:
		$Quest_UI.visible = true
		if $Store_UI.visible == false:
			$"../UI_animator".play("From")
		$Store_UI.visible = false
		$Panel.visible = true
	else:
		_on_exit_pressed()

func _on_store_pressed() -> void:
	if $Store_UI.visible == false:
		$Store_UI.visible = true
		if $Quest_UI.visible == false:
			$"../UI_animator".play("From")
		$Quest_UI.visible = false
		$Panel.visible = true
	else:
		_on_exit_pressed()

func _on_exit_pressed() -> void:
	$"../UI_animator".play("To")

func anim_finish(anim_name: StringName) -> void:
	if anim_name == "To":
		$Quest_UI.visible = false
		$Store_UI.visible = false
		$Panel.visible = false

func switch_to_build(selected: Building):
	selected_build = selected
	_on_exit_pressed()
	building_state = true
	worker_state = false

func switch_to_worker(selected: Worker):
	selected_worker = selected
	_on_exit_pressed()
	worker_state = true
	building_state = false

func change_all_label(is_added: bool):
	for i in 7:
		change_label(i,is_added)

func change_label(type: int, is_added: bool):
	match type:
		0:
			$res_panel/HBC/res1/Label.text = str(Global.rusted)
			$res_panel/HBC/res1/TextureRect.texture = Global.get_res_icon(type)
			if is_added:
				anim_add($res_panel/HBC/res1/Label)
			else:
				anim_decr($res_panel/HBC/res1/Label)
		1:
			$res_panel/HBC/res2/Label.text = str(Global.electrosnow)
			$res_panel/HBC/res2/TextureRect.texture = Global.get_res_icon(type)
			if is_added:
				anim_add($res_panel/HBC/res2/Label)
			else:
				anim_decr($res_panel/HBC/res2/Label)
		2:
			$res_panel/HBC/res3/Label.text = str(Global.money)
			$res_panel/HBC/res3/TextureRect.texture = Global.get_res_icon(type)
			if is_added:
				anim_add($res_panel/HBC/res3/Label)
			else:
				anim_decr($res_panel/HBC/res3/Label)
		3:
			$res_panel/HBC/res4/Label.text = str(Global.highqualityelectrical)
			$res_panel/HBC/res4/TextureRect.texture = Global.get_res_icon(type)
			if is_added:
				anim_add($res_panel/HBC/res4/Label)
			else:
				anim_decr($res_panel/HBC/res4/Label)
		4:
			$res_panel/HBC/res5/Label.text = str(Global.heavycomponents)
			$res_panel/HBC/res5/TextureRect.texture = Global.get_res_icon(type)
			if is_added:
				anim_add($res_panel/HBC/res5/Label)
			else:
				anim_decr($res_panel/HBC/res5/Label)
		5:
			$res_panel/HBC/res6/Label.text = str(Global.imperial_might)
			$res_panel/HBC/res6/TextureRect.texture = Global.get_res_icon(type)
			if is_added:
				anim_add($res_panel/HBC/res6/Label)
			else:
				anim_decr($res_panel/HBC/res6/Label)
		6:
			$res_panel/HBC/res7/Label.text = str(Global.cultist_might)
			$res_panel/HBC/res7/TextureRect.texture = Global.get_res_icon(type)
			if is_added:
				anim_add($res_panel/HBC/res7/Label)
			else:
				anim_decr($res_panel/HBC/res7/Label)

func anim_add(label: Node):
	var tws = create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT).set_parallel(true)
	tws.tween_property(label, "scale",Vector2(1,1), 1).from(Vector2(1.3,1.3))
	tws.tween_property(label, "modulate",Color(1.0, 1.0, 1.0, 1.0), 1).from(Color(0.0, 0.803, 0.0, 1.0))

func anim_decr(label:Node):
	var tws = create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT).set_parallel(true)
	tws.tween_property(label, "scale",Vector2(1,1), 1).from(Vector2(1.3,1.3))
	tws.tween_property(label, "modulate",Color(1.0, 1.0, 1.0, 1.0), 1).from(Color(1.0, 0.0, 0.0, 1.0))

func anim_click(position):
		$"../click".set_position(position - $"../click".size / 2) 
		var twm = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN).set_parallel(true)
		twm.tween_property($"../click","modulate",Color(1.0, 1.0, 1.0, 0.0), 0.15).from(Color(1.0, 1.0, 1.0, 1.0))
		twm.tween_property($"../click","scale", Vector2(0.8,0.8), 0.2).from(Vector2(0.2,0.2))

func _on_buildings_pressed() -> void:
	$Store_UI/Build_scroll_list.visible = true
	$Store_UI/Zones_View.visible = false

func _on_zones_pressed() -> void:
	$Store_UI/Build_scroll_list.visible = false
	$Store_UI/Zones_View.visible = true

func _on_zone_buy() -> void:
	if selected_zone.first_res_count <= Global.get_res_value(selected_zone.first_res_type):
		if selected_zone.second_res_count <= Global.get_res_value(selected_zone.second_res_type):
			Global.add_to_integer_res_type(selected_zone.first_res_type,-selected_zone.first_res_count)
			Global.add_to_integer_res_type(selected_zone.second_res_type,-selected_zone.second_res_count)
			change_label(selected_zone.first_res_type, false)
			change_label(selected_zone.second_res_type, false)
			print(selected_zone.name, " разблокирован!")
			_on_buildings_pressed()
			$Store_UI/Slider.value = 100
			var twp = create_tween().set_trans(Tween.TRANS_LINEAR)
			get_tree().call_group("zone_button", "check", selected_zone)
			match selected_zone.number:
				2:
					Global.is_zone_2_open = true
					twp.tween_property($"../../Walls/Zone_1/Wall3","position", $"../../Walls/Zone_1/Wall3".position + Vector3(0,-2,0), 5)
					$"Store_UI/Build_scroll_list/VBС/lvl4".is_open = true
					$"Store_UI/Build_scroll_list/VBС/lvl4".update()
					$"Store_UI/Build_scroll_list/VBС/lvl5".is_open = true
					$"Store_UI/Build_scroll_list/VBС/lvl5".update()
					$"Store_UI/Build_scroll_list/VBС/lvl6".is_open = true
					$"Store_UI/Build_scroll_list/VBС/lvl6".update()
				3:
					Global.is_zone_3_open = true
					twp.tween_property($"../../Walls/Zone_2/Wall","position", $"../../Walls/Zone_2/Wall".position + Vector3(0,-2,0), 5)
					$"Store_UI/Build_scroll_list/VBС/lvl7".is_open = true
					$"Store_UI/Build_scroll_list/VBС/lvl7".update()
					$"Store_UI/Build_scroll_list/VBС/lvl8".is_open = true
					$"Store_UI/Build_scroll_list/VBС/lvl8".update()
					$"Store_UI/Build_scroll_list/VBС/lvl9".is_open = true
					$"Store_UI/Build_scroll_list/VBС/lvl9".update()
				4:
					Global.is_zone_4_open = true
					twp.tween_property($"../../Walls/Zone_3/Wall2","position", $"../../Walls/Zone_3/Wall2".position + Vector3(0,-2,0), 5)
					$"Store_UI/Build_scroll_list/VBС/lvl10".is_open = true
					$"Store_UI/Build_scroll_list/VBС/lvl10".update()
				5:
					Global.is_zone_5_open = true
					twp.tween_property($"../../Walls/Zone_4/Wall","position", $"../../Walls/Zone_4/Wall".position + Vector3(0,-2,0), 5)
					$"Store_UI/Build_scroll_list/VBС/lvl11".is_open = true
					$"Store_UI/Build_scroll_list/VBС/lvl11".update()
					$"Store_UI/Build_scroll_list/VBС/lvl12".is_open = true
					$"Store_UI/Build_scroll_list/VBС/lvl12".update()
		else:
			no_res()
	else:
		no_res()


func no_res():
	var twp = create_tween().set_trans(Tween.TRANS_ELASTIC)
	var rnd = randf_range(-6,6)
	var twm = create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	twp.tween_property($Store_UI/Zones_View/Desc/HBC/Buy, "position", Vector2(108 +rnd ,0+rnd), 0.2).set_ease(Tween.EASE_IN).from(Vector2(108,0))
	twp.tween_property($Store_UI/Zones_View/Desc/HBC/Buy, "position", Vector2(108,0), 0.5).set_ease(Tween.EASE_OUT)
	twm.tween_property($Store_UI/Zones_View/Desc/HBC/Buy, "self_modulate", Color(1.0, 1.0, 1.0, 1.0), 0.7).from(Color(1.0, 0.0, 0.0, 1.0))

func slider_changed(value: float) -> void:
	$"Store_UI/Build_scroll_list/VBС".position.y = store_scroll_max / 100 * value

func slider_quest_changed(value: float) -> void:
	$Quest_UI/Quest_scroll_list/VBoxContainer.position.y = quest_scroll_max / 100 * value

func _on_store_gui_input(event: InputEvent) -> void:
	slider_mouse(true, event)

func _on_quest_gui_input(event: InputEvent) -> void:
	slider_mouse(false, event)

func slider_mouse(is_store: bool, event: InputEvent):
	var speed: float = 5
	var slider: Node
	if is_store:
		slider = $Store_UI/Slider
	else:
		slider = $Quest_UI/Slider
	
	if event.is_action_pressed("zoom-"):
		slider.value += speed
	elif event.is_action_pressed("zoom+"):
		slider.value -= speed

func _on_demolition_toggled() -> void:
	demolition_state = true
	building_state = false
	worker_state = false
