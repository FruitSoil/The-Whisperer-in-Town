extends CanvasLayer

@onready var menu_button: OptionButton = $MenuButton

func _ready() -> void:
	$".".hide()

func _input(event: InputEvent) -> void:
	if event.is_action_released("debug_R"):
		get_tree().reload_current_scene()
		Global.is_zone_1_open = true
		Global.is_zone_2_open = false
		Global.is_zone_3_open = false
		Global.is_zone_4_open = false
		Global.is_zone_5_open = false
	if event.is_action_released("debug_panel"):
		if $".".visible:
			$".".hide()
		else:
			$".".show()
			print("РАЙОН")
			for i in Global.total_buildings:
				print(" - ",i.name)
			print("РАБОЧИЕ")
			for i in Global.total_workers:
				print(" - ",i.name)
			print("КОМБИНАЦИИ РАБОЧИЙ-РАЙОН")
			for i in Global.total_work_on_build:
				print(" - ",i.worker.name, " в районе ", i.build.name)
			print("КВЕСТЫ ВЫПОЛНЕНЫЕ")
			for i in Global.quest_done:
				print(" - ",i.quest_name)
			print("КВЕСТЫ СКИПНУТЫЕ")
			for i in Global.quest_skip:
				print(" - ",i.quest_name)
	if event.is_action_released("debug_quest_test"):
		%ADMIN.add_quest(load("res://resources/Quests/TutorialPart1.tres"))
	if event.is_action_released("debug_quest_test2"):
		%ADMIN.quest_stage = 4
		%ADMIN.update_icon()

func _pressed() -> void:
	var add_count: int
	if menu_button.selected == 2:
		add_count = 10
	elif menu_button.selected == 5 or menu_button.selected == 6:
		add_count = 1
	else:
		add_count = 1000
	Global.add_to_integer_res_type(menu_button.selected, add_count)
	%BaseUI.change_label(menu_button.selected,true)

func _on_full_pressed() -> void:
	for i in 7:
		Global.add_to_integer_res_type(i, 99999)
	%BaseUI.change_all_label(true)
