extends Button

@export var res: Worker 
var appointed: bool = false

func _ready() -> void:
	pressed.connect(touch)
	$TextureRect.texture = res.icon

func touch():
	if appointed == false:
		if res.is_unique:
			%BaseUI.switch_to_worker(res)
		else:
			if Global.money >= 10:
				Global.add_to_integer_res_type(2, -10)
				%BaseUI.switch_to_worker(res)
			%BaseUI.change_label(2, false)

func change_work_icon(value: bool, given_res: Worker):
	if given_res == res and res.is_unique:
		if value:
			$Appoint_status.show()
			appointed = true
			disabled = true
		else:
			$Appoint_status.hide()
			appointed = false
			disabled = false
