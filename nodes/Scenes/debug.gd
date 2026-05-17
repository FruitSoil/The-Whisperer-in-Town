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
