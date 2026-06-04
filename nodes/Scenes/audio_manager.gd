extends Node

var button_paths: Array = [
	"../HUD/BaseUI/Demolition",
	"../HUD/BaseUI/Quest",
	"../HUD/BaseUI/Store",
	"../HUD/BaseUI/Button",
	"../Dialogue/Panel/Exit_button",
	"../HUD/BaseUI/Panel/Exit"
]

var digital_buttons: Array = [
	"../Pause/VBC/Continue",
	"../Pause/VBC/Settings",
	"../Pause/VBC/Exit_to main",
	"../Dialogue/Panel/VBC/Variant_yes",
	"../Dialogue/Panel/VBC/Variant_no",
	"../Dialogue/Panel/VBC/Variant_later",
	"../HUD/BaseUI/Store_UI/HBC/Buildings",
	"../HUD/BaseUI/Store_UI/HBC/Zones",
	"../HUD/BaseUI/Store_UI/Zones_View/МС/Desc/HBC/Buy",
	"../HUD/BaseUI/workers_panel/Default_worker",
	"%ADMIN",
	"%worker",
	"%worker2",
	"%worker3",
	"%worker4",
	"%worker5",
	"%worker6",
]

var zones: Array = [
	"../HUD/BaseUI/Store_UI/Zones_View/MC/Zones/Zone_5",
	"../HUD/BaseUI/Store_UI/Zones_View/MC/Zones/Zone_4",
	"../HUD/BaseUI/Store_UI/Zones_View/MC/Zones/Zone_3",
	"../HUD/BaseUI/Store_UI/Zones_View/MC/Zones/Zone_2",
	"../HUD/BaseUI/Store_UI/Zones_View/MC/Zones/Zone_1"
]

func _ready() -> void:
	# металлические кнопки
	for path in button_paths:
		var btn := get_node_or_null(path) as Button
		if btn:
			btn.mouse_entered.connect(metal.bind(0))
			btn.pressed.connect(metal.bind(1))
			btn.button_up.connect(metal.bind(2))

	# цифровые кнопки
	for path in digital_buttons:
		var btn := get_node_or_null(path) as Button
		if btn:
			btn.mouse_entered.connect(digital.bind(0))
			btn.pressed.connect(digital.bind(1))
	
	for path in zones:
		var btn := get_node_or_null(path) as Button
		if btn:
			btn.mouse_entered.connect(digital.bind(0))
			btn.pressed.connect(zone.bind(1))

func metal(ID: int) -> void:
	match ID:
		0:
			$Metal_click_hover.play()
		1:
			$Metal_click_pressed.play()
		2:
			$Metal_click_released.play()

func digital(ID: int) -> void:
	match ID:
		0:
			$Digital_click_hover.play()
		1:
			$Digital_click_pressed.play()

func zone(ID) -> void:
	match ID:
		1:
			$Digital_zone_click.play()

func state_broke():
	$BuildDemolitionStateBroke.play()

func work_broke():
	$WorkerStateBroke.play()

func tutor():
	$TutorilaSound.play()

func blink():
	$Blink.play()
