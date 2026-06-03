extends Panel
class_name  QuestPanel

@onready var button: Button = $Quest/MC/Button
@onready var button_zone: Button = $Zone_quest/MC/Button
@onready var quest_desc: RichTextLabel = $Quest/VBoxContainer/Quest_desc

@export_category("zone_quest")
@export var is_next_zone_quest: bool = false
@export var next_zone: Zone = preload("res://resources/Zones/Zone_2.tres")
@export_category("normal_quest")
@export var quest_res:Quest
@export var worker: WorkerPanel

func _ready() -> void:
	button_zone.pressed.connect(press)
	button.pressed.connect(press)
	update_info()
	$Animator.play("add")

func update_info():
	if is_next_zone_quest:
		$Quest.hide()
		$Zone_quest.show()
		$Zone_label.show()
		if next_zone:
			$Zone_label.text = "Зона " + str(next_zone.number) + " - " + next_zone.name
			$Zone_quest/Icon/Portair.texture = next_zone.icon
			$Zone_quest/MC2/HBC/Icon.texture = Global.get_res_icon(next_zone.first_res_type)
			$Zone_quest/MC2/HBC/Icon2.texture = Global.get_res_icon(next_zone.second_res_type)
			update_quest_res_count()
	else:
		$Quest.show()
		$Zone_quest.hide()
		$Zone_label.hide()
		if quest_res:
			$Quest/VBoxContainer/Quest_name.text = quest_res.quest_name
			$Quest/Icon/Portair.texture = quest_res.icon
			
			update_quset_labels_color()

func update_quest_res_count():
	$Zone_quest/MC2/HBC/Label.text = str(next_zone.first_res_count) + "/" + str(Global.get_res_value(next_zone.first_res_type))
	$Zone_quest/MC2/HBC/Label2.text = str(next_zone.second_res_count) + "/" + str(Global.get_res_value(next_zone.second_res_type))
	$Zone_quest/MC2/HBC/Label.resource = next_zone.first_res_type
	$Zone_quest/MC2/HBC/Label.value = next_zone.first_res_count
	$Zone_quest/MC2/HBC/Label2.resource = next_zone.second_res_type
	$Zone_quest/MC2/HBC/Label2.value = next_zone.second_res_count

func update_quset_labels_color():
	var in_progress: Color = Color(0.796, 0.72, 0.167, 1.0)
	var not_accepted: Color = Color(0.746, 0.746, 0.746, 1.0)
	var not_accepted2: Color = Color(0.569, 0.569, 0.569, 1.0)
	var done: Color = Color("89ffba")
	if worker:
		match worker.quest_stage:
			1:
				$Quest/VBoxContainer/Quest_name.add_theme_color_override("default_color",not_accepted)
				$Quest/VBoxContainer/Quest_desc.add_theme_color_override("default_color",not_accepted2)
				$Quest/MC/Button/Icon.texture = load("res://Images/UI/icons/IMG_20260512_194321_862.png")
			3:
				$Quest/VBoxContainer/Quest_name.add_theme_color_override("default_color",in_progress)
				$Quest/MC/Button/Icon.texture = load("res://Images/UI/icons/IMG_20260512_194322_026.png")
			4:
				$Quest/VBoxContainer/Quest_name.add_theme_color_override("default_color",done)
				$Quest/MC/Button/Icon.texture = load("res://Images/UI/icons/IMG_20260512_194322_323.png")
			5:
				$Quest/VBoxContainer/Quest_name.add_theme_color_override("default_color",not_accepted)
				$Quest/VBoxContainer/Quest_desc.add_theme_color_override("default_color",not_accepted2)
				$Quest/MC/Button/Icon.texture = load("res://Images/UI/icons/IMG_20260512_194321_862.png")
	if worker:
		match worker.quest_stage:
					1:
						$Quest/VBoxContainer/Quest_desc.text = quest_res.character_name + " хочет поговорить с вами. . ."
					3:
						$Quest/VBoxContainer/Quest_desc.text = quest_res.text_progress
					4:
						$Quest/VBoxContainer/Quest_desc.text = quest_res.character_name + " хочет поговорить с вами. . ."
					5:
						$Quest/VBoxContainer/Quest_desc.text = quest_res.character_name + " ждет вашего ответа"

func press():
	if is_next_zone_quest:
		$"../../../../Store_UI".visible = true
		$"../../..".visible = false
		var zones = $"../../../../Store_UI/Zones_View/MC/Zones".get_children()
		for i in zones:
			if i.res == next_zone:
				i.touch()
				break
		$"../../../../Store_UI/Build_scroll_list".visible = false
		$"../../../../Store_UI/Zones_View".visible = true
		$"../../../../Store_UI/HBC/StrechController".press($"../../../../Store_UI/HBC/Zones")
	else:
		$"../../../../../../Dialogue".worker_panel = worker
		$"../../../../../../Dialogue".open_window(quest_res)

func kill_anim():
	$Animator.play("kill")

func _on_timer_timeout() -> void:
	update_quest_res_count()
	update_quset_labels_color()

func close():
	$Timer.stop()
	$Quest.hide()
	$Zone_quest.hide()
	$Zone_label.hide()
