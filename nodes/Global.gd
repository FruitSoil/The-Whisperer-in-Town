extends Node

var rusted: int = 9999999
var electrosnow: int = 9999999
var money: int = 9999999
var highqualityelectrical: int = 9999999
var heavycomponents: int = 9999999
var imperial_might: int = 9999999
var cultist_might: int = 9999999

var is_zone_1_open:bool = true
var is_zone_2_open:bool = false
var is_zone_3_open:bool = false
var is_zone_4_open:bool = false
var is_zone_5_open:bool = false

enum res_types {
	rusted = 0, ##Ржавая жесть, ресурс первой зоны. Получается со зданий. Нужен для постройки районов
	electrosnow = 1, ##Электроснег, ресурс второй зоны. Получается со зданий. Нужен для постройки районов
	money = 2, ##Деньги, уникальный ресурс. Получается с клика по зданиям и от уник. работников. Нужен для найма
	highqualityelectrical = 3, ##Высококачественные электросхемы, ресурс третьей зоны. Получается со зданий. Нужен для постройки районов
	heavycomponents = 4, ##Тяжёные компоненты, ресурс четвертой зоны. Получается со зданий. Нужен для постройки районов
	imperial_might = 5, ##Ресурс империи, нужен для финального этапа игры, определяет концовку
	cultist_might = 6, ##Ресурс культа, нужен для финального этапа игры, определяет концовку
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
			return load("res://Images/Resources_icons/actual/Rusted_res_icon.png")
		1:
			return load("res://Images/Resources_icons/actual/Electrosnow_res_icon.png")
		2:
			return load("res://Images/Resources_icons/actual/money_res_icon.png")
		3:
			return load("res://Images/Resources_icons/actual/highqualityelectronic_res_icon.png")
		4:
			return load("res://Images/Resources_icons/heavycomponent_res_icon.png")
		5:
			return load("res://Images/Resources_icons/imperial_res_icon.png")
		6:
			return load("res://Images/Resources_icons/cultistic_res_icon.png")
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
