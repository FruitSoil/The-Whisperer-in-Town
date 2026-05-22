extends Panel
class_name  QuestPanel

@onready var button: Button = $Quest/MC/Button

@export_category("zone_quest")
@export var is_next_zone_quest: bool = false
@export var next_zone: Zone = preload("res://resources/Zones/Zone_2.tres")
@export_category("normal_quest")
@export var quest_res:Quest
@export var worker: WorkerPanel


func _ready() -> void:
	button.pressed.connect(press)
	$Animator.play("add")
	update_info()

func update_info():
	if is_next_zone_quest:
		$Quest.hide()
		$Zone_quest.show()
	else:
		$Quest.show()
		$Zone_quest.hide()
		if quest_res:
			$Quest/VBoxContainer/Quest_desc.text = quest_res.text_progress
			$Quest/VBoxContainer/Quest_name.text = quest_res.quest_name
			$Quest/Icon/Portair.texture = quest_res.icon

func press():
	if is_next_zone_quest:
		$Store_UI.visible = true
		$Quest_UI.visible = false
		$Panel.visible = true
		$"../../../../Store_UI/Zones_View/Zones/Zone_1".touch()
		$"../../../../Store_UI/Build_scroll_list".visible = false
		$"../../../../Store_UI/Zones_View".visible = true
	else:
		$"../../../../../../Dialogue".worker_panel = worker
		$"../../../../../../Dialogue".open_window(quest_res)

func kill_anim():
	$Animator.play("kill")
