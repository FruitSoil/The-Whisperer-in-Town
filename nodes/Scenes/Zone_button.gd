extends Button

@export var res: Zone

func _ready() -> void:
	pressed.connect(touch)
	change_desc()

func touch():
	if check_zone_open_status_plus_one() or check_zone_open_status():
		change_desc()
		%BaseUI.selected_zone = res
		$"../../Desc/Panel/TextureRect".texture = res.icon
		$"../../Desc/Name".text = res.name
		$"../../Desc/Desc".text = res.description
		if res.bonus_res_count != 0:
			$"../../Desc/HBC/Panel/Label".text = Global.get_res_name(res.bonus_res_type)
			$"../../Desc/HBC/Panel/Res".texture = Global.get_res_icon(res.bonus_res_type)
		else:
			$"../../Desc/HBC/Panel/Label".text = " "
			$"../../Desc/HBC/Panel/Res".texture = null

func change_desc():
	$"../../Desc/HBC/Buy".disabled = check_zone_open_status()
	$Texture.texture = res.icon
	text = "Зона " + str(res.number) + " - " + res.name
	if check_zone_open_status_plus_one() or check_zone_open_status():
		$"Condition".hide()
		disabled = false
	$"../../Desc/HBC/Buy/Res_label".text = str(res.first_res_count)
	$"../../Desc/HBC/Buy/Res_icon".texture = Global.get_res_icon(res.first_res_type)
	$"../../Desc/HBC/Buy/Res_label".value = res.first_res_count
	$"../../Desc/HBC/Buy/Res_label".resource = res.first_res_type
	if res.first_res_count != 0:
		$"../../Desc/HBC/Buy/Res_label".text = str(res.first_res_count)
		$"../../Desc/HBC/Buy/Res_icon".texture = Global.get_res_icon(res.first_res_type)
		$"../../Desc/HBC/Buy/Res_label".value = res.first_res_count
		$"../../Desc/HBC/Buy/Res_label".resource = res.first_res_type
	else:
		$"../../Desc/HBC/Buy/Res_label".text = " "
		$"../../Desc/HBC/Buy/Res_icon".texture = null
	if res.second_res_count != 0:
		$"../../Desc/HBC/Buy/Res_label2".text = str(res.second_res_count)
		$"../../Desc/HBC/Buy/Res_icon2".texture = Global.get_res_icon(res.second_res_type)
		$"../../Desc/HBC/Buy/Res_label2".value = res.second_res_count
		$"../../Desc/HBC/Buy/Res_label2".resource = res.second_res_type
	else:
		$"../../Desc/HBC/Buy/Res_label2".text = " "
		$"../../Desc/HBC/Buy/Res_icon2".texture = null

func check_zone_open_status() -> bool:
	if Global.is_zone_1_open and res.number == 1:
		return true
	elif  Global.is_zone_2_open and res.number == 2:
		return true
	elif  Global.is_zone_3_open and res.number == 3:
		return true
	elif  Global.is_zone_4_open and res.number == 4:
		return true
	elif  Global.is_zone_5_open and res.number == 5:
		return true
	else:
		return false

func check_zone_open_status_plus_one() -> bool:
	if Global.is_zone_1_open and res.number == 2:
		return true
	elif  Global.is_zone_2_open and res.number == 3:
		return true
	elif  Global.is_zone_3_open and res.number == 4:
		return true
	elif  Global.is_zone_4_open and res.number == 5:
		return true
	elif  Global.is_zone_5_open and res.number == 6:
		return true
	else:
		return false

func check(resource: Zone):
	if res == resource:
		icon = load("res://Images/UI/icons/IMG_20260512_194321_716.png")
	if check_zone_open_status_plus_one() or check_zone_open_status():
		$"Condition".hide()
