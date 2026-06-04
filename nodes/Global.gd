extends Node

signal change_ending_progress

const DEFAULT_WORKER_COST: int = 7

var total_buildings: Array[Building] = []
var total_workers: Array[Worker] = []
var total_work_on_build: Array[WorkerOnBuilding] = []

var quest_done: Array[Quest]
var quest_skip: Array[Quest]
var quest_in_progress: Array[Quest]

var rusted: int = 0
var electrosnow: int = 0
var money: int = 6
var highqualityelectrical: int = 0
var heavycomponents: int = 0
var imperial_might: int = 0:
	set(value):
		imperial_might = value
		change_ending_progress.emit()
var cultist_might: int = 0:
	set(value):
		cultist_might = value
		change_ending_progress.emit()

var is_zone_1_open:bool = true
var is_zone_2_open:bool = false
var is_zone_3_open:bool = false
var is_zone_4_open:bool = false
var is_zone_5_open:bool = false

var is_ending: bool = false
var is_current_ending_imper: bool 

enum res_types {
	rusted = 0, ##Ржавая жесть, ресурс первой зоны. Получается со зданий. Нужен для постройки районов
	electrosnow = 1, ##Электроснег, ресурс второй зоны. Получается со зданий. Нужен для постройки районов
	money = 2, ##Деньги, уникальный ресурс. Получается с клика по зданиям и от уник. работников. Нужен для найма
	highqualityelectrical = 3, ##Высококачественные электросхемы, ресурс третьей зоны. Получается со зданий. Нужен для постройки районов
	heavycomponents = 4, ##Тяжёные компоненты, ресурс четвертой зоны. Получается со зданий. Нужен для постройки районов
	imperial_might = 5, ##Ресурс империи, нужен для финального этапа игры, определяет концовку
	cultist_might = 6, ##Ресурс культа, нужен для финального этапа игры, определяет концовку
	}

enum workers {
	ADMIN = 0, ##Администрация
	WORKER = 1, ##Сэд Клинтвуд
	SCIENTIST = 2, ##Говард Ист
	AGENT = 4, ##Кэтэрин Коллар
	RADIOHOST = 3, ##Арт Белл
	MILITARY = 5, ##Тони Вайсо
	TRAITOR = 6 ##Джеймс Бэккет
}

##Добавить к инт переменной res_type значение add_value
func add_to_integer_res_type(res_type: int, add_value: int):
	match res_type:
		0:
			rusted += add_value
		1:
			electrosnow += add_value
		2:
			money += add_value
		3:
			highqualityelectrical += add_value
		4:
			heavycomponents += add_value
		5:
			imperial_might += add_value
		6:
			cultist_might += add_value
		_:
			print("GLOBAL: функция перевода получила несущ. ресурс")

## Возвращает иконку ресурса res_type
##ВАЖНО!! Размер иконки у ресурсов разный, так что для начала настройте texture rect 
## Expand mode - Ignore size, Stretch Mode - Keep Aspect
func get_res_icon(res_type: int) -> Texture:
	match res_type:
		0:
			return load("res://Images/Resources_icons/Colored/icon_rusty_tin.png")
		1:
			return load("res://Images/Resources_icons/Colored/icon_electrosnow.png")
		2:
			return load("res://Images/Resources_icons/Colored/icon_money.png")
		3:
			return load("res://Images/Resources_icons/Colored/icon_wiring_diagram.png")
		4:
			return load("res://Images/Resources_icons/Colored/icon_the_power_of_the_military.png")
		5:
			return load("res://Images/Resources_icons/Colored/icon_the_power_of_the_empire.png")
		6:
			return load("res://Images/Resources_icons/Colored/icon_the_power_of_the_ancients.png")
		_:
			return load("res://Images/Resources_icons/no_res_icon.png")

func get_res_name(res_type: int) -> String:
	match res_type:
		0:
			return "Ржавая жесть"
		1:
			return "Электроснег"
		2:
			return "Деньги"
		3:
			return "Высококачественные Электросхемы"
		4:
			return "Тяжелые компоненты"
		5:
			return "Имперская мощь"
		6:
			return "Культистская мощь"
		_:
			return "-"

func get_res_value(res_type: int) -> int:
	match res_type:
		0:
			return rusted
		1:
			return electrosnow
		2:
			return money
		3:
			return highqualityelectrical
		4:
			return heavycomponents
		5:
			return imperial_might
		6:
			return cultist_might
		_:
			return 0

func get_zone(ID: int) -> Zone:
	match ID:
		1:
			return load("res://resources/Zones/Zone_1.tres")
		2:
			return load("res://resources/Zones/Zone_2.tres")
		3:
			return load("res://resources/Zones/Zone_3.tres")
		4:
			return load("res://resources/Zones/Zone_4.tres")
		5:
			return load("res://resources/Zones/Zone_5.tres")
		_:
			return null

func zero():
	total_buildings.clear()
	total_workers.clear()
	total_work_on_build.clear()
	
	quest_done.clear()
	quest_skip.clear()
	quest_in_progress.clear()
	
	is_zone_1_open = true
	is_zone_2_open = false
	is_zone_3_open = false
	is_zone_4_open = false
	is_zone_5_open = false
	
	rusted= 0
	electrosnow = 0
	money= 6
	highqualityelectrical = 0
	heavycomponents= 0
	imperial_might = 0
	cultist_might = 0
	
	is_current_ending_imper = true
	is_ending = false
