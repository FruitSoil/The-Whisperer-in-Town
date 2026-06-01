extends Button

@export var res: Zone

const check_icon = preload("res://Images/UI/icons/icon_check.PNG")

@onready var desc_name: Label = $"../../../МС/Desc/Name"
@onready var desc: RichTextLabel = $"../../../МС/Desc/Desc"
@onready var texture_rect: TextureRect = $"../../../МС/Desc/Panel/TextureRect"
@onready var label: Label = $"../../../МС/Desc/HBC/Panel/Label"
@onready var res_panel: TextureRect = $"../../../МС/Desc/HBC/Panel/Res"
@onready var buy: Button = $"../../../МС/Desc/HBC/Buy"

@onready var res_label: Label = $"../../../МС/Desc/HBC/Buy/Res_label"
@onready var res_icon: TextureRect = $"../../../МС/Desc/HBC/Buy/Res_icon"
@onready var res_label_2: Label = $"../../../МС/Desc/HBC/Buy/Res_label2"
@onready var res_icon_2: TextureRect = $"../../../МС/Desc/HBC/Buy/Res_icon2"

@onready var icon_: TextureRect = $Icon
@onready var condition: Label = $Condition
@onready var back_buffer: BackBufferCopy = $BackBuffer
@onready var zone_name: Label = $ZoneName

func _ready() -> void:
	pressed.connect(touch)
	change_desc()
	check(res)

func touch():
	if check_zone_open_status_plus_one() or check_zone_open_status():
		change_desc()
		%BaseUI.selected_zone = res
		texture_rect.texture = res.icon
		desc_name.text = res.name
		desc.text = res.description
		if res.bonus_res_count != 0:
			label.text = Global.get_res_name(res.bonus_res_type)
			res_panel.texture = Global.get_res_icon(res.bonus_res_type)
		else:
			label.text = " "
			res_panel.texture = null

func change_desc():
	buy.disabled = check_zone_open_status()
	$Texture.texture = res.icon
	zone_name.text = "Зона " + str(res.number) + " - " + res.name
	if check_zone_open_status_plus_one() or check_zone_open_status():
		$"Condition".hide()
		disabled = false
	else:
		zone_name.text = ""
		icon_.hide()
	res_label.text = str(res.first_res_count)
	res_icon.texture = Global.get_res_icon(res.first_res_type)
	res_label.value = res.first_res_count
	res_label.resource = res.first_res_type
	if res.first_res_count != 0:
		res_label.text = str(res.first_res_count)
		res_icon.texture = Global.get_res_icon(res.first_res_type)
		res_label.value = res.first_res_count
		res_label.resource = res.first_res_type
	else:
		res_label.text = " "
		res_icon.texture = null
	if res.second_res_count != 0:
		res_label_2.text = str(res.second_res_count)
		res_icon_2.texture = Global.get_res_icon(res.second_res_type)
		res_label_2.value = res.second_res_count
		res_label_2.resource = res.second_res_type
	else:
		res_label_2.text = " "
		res_icon_2.texture = null

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
	change_desc()
	if res == resource:
		zone_name.show()

	if check_zone_open_status():
		icon_.show()
		condition.hide()
		if check_zone_open_status_plus_one():
			zone_name.show()
			condition.hide()
