extends CanvasLayer

@onready var menu_button: OptionButton = $MenuButton

@onready var speed_0_5: Button = $speed0_5
@onready var speed_1: Button = $speed1
@onready var speed_2: Button = $speed2
@onready var speed_5: Button = $speed5

func _ready() -> void:
	speed_0_5.pressed.connect(speed_change.bind(0))
	speed_1.pressed.connect(speed_change.bind(1))
	speed_2.pressed.connect(speed_change.bind(2))
	speed_5.pressed.connect(speed_change.bind(3))
	
	$".".hide()

func speed_change(speed: int):
	match speed:
		0:
			Engine.time_scale = 0.5
		1:
			Engine.time_scale = 1.0
		2:
			Engine.time_scale = 2.0
		3:
			Engine.time_scale = 5.0

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

func _pressed() -> void:
	var add_count: int
	if menu_button.selected == 2:
		add_count = 10
	elif menu_button.selected == 5 or menu_button.selected == 6:
		add_count = 10
	else:
		add_count = 1000
	Global.add_to_integer_res_type(menu_button.selected, add_count)
	%BaseUI.change_label(menu_button.selected,true)

func _on_full_pressed() -> void:
	for i in 5:
		Global.add_to_integer_res_type(i, 99999)
	%BaseUI.change_all_label(true)
