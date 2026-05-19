extends Button
class_name WorkerPanel

@export var res: Worker 
var appointed: bool = false
var icons_pool: Array[Texture] = [
	preload("res://Images/portairs/Default/default_worker1.png"),
	preload("res://Images/portairs/Default/default_worker2.png"),
	preload("res://Images/portairs/Default/default_worker3.png")
]

var quest_res: Quest
var quest_stage: int = 0
@export var can_be_placed: bool = false

func _ready() -> void:
	if res.is_unique == false:
		$Res_icon.texture = Global.get_res_icon(2)
	gui_input.connect(quest)
	pressed.connect(touch)
	$TextureRect.texture = res.icon
	update_icon()

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

func update_icon():
	match quest_stage:
		1:
			$Dialogue_status.texture = load("res://Images/UI/icons/IMG_20260512_194321_862.png")
			$Dialogue_status.show()
		2:
			$Dialogue_status.hide()
		3:
			$Dialogue_status.texture = load("res://Images/UI/icons/IMG_20260512_194322_026.png")
			$Dialogue_status.show()
		4:
			$Dialogue_status.texture = load("res://Images/UI/icons/IMG_20260512_194322_323.png")
			$Dialogue_status.show()
		5:
			$Dialogue_status.texture = load("res://Images/UI/icons/IMG_20260512_194321_862.png")
			$Dialogue_status.show()
		0:
			$Dialogue_status.hide()

func add_quest(qst: Quest):
	quest_res = qst
	quest_stage = 1
	update_icon()

func quest(event: InputEvent):
	if event.is_action_released("displace") and quest_res != null:
		%Dialogue.worker_panel = self
		%Dialogue.open_window(quest_res)
