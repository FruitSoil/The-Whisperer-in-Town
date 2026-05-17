extends Button

@export var res: Worker 
var appointed: bool = false
var icons_pool: Array[Texture] = [
	preload("res://Images/portairs/Default/default_worker1.png"),
	preload("res://Images/portairs/Default/default_worker2.png"),
	preload("res://Images/portairs/Default/default_worker3.png")
]

func _ready() -> void:
	if res.is_unique == false:
		$Res_icon.texture = Global.get_res_icon(2)
	pressed.connect(touch)
	$TextureRect.texture = res.icon

func touch():
	if appointed == false:
		if res.is_unique:
			%BaseUI.switch_to_worker(res)
		else:
			if Global.money >= 10:
				var given_res: Worker = res
				given_res = res.duplicate()
				res.icon = icons_pool[randi_range(0,2)]
				$TextureRect.texture = res.icon
				Global.add_to_integer_res_type(2, -10)
				%BaseUI.switch_to_worker(given_res)
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
