## Данные зоны
@icon("res://Images/Zone_res_icon.png")
extends Resource
class_name Zone

@export_range(0,7) var number: int ##Номер зоны для кода
@export_category("Описание")
@export var name: String ##Нарративное название Зоны
@export_multiline var description: String ##Нарративное описание зоны
@export var icon: Texture ##Картинка
@export_category("Цена")
@export var first_res_type: Global.res_types ##Тип ресурса для первого ценника
@export var first_res_count: int ##Колво ресурса для первого ценника
@export var second_res_type: Global.res_types ##Тип ресурса для второго ценника
@export var second_res_count: int ##Колво ресурса для второго ценника
@export_category("Бонусы")
@export var bonus_res_type: Global.res_types ##Тип ресурса который увеличивается в этой зоне
@export var bonus_res_count: int ##Бонус ресурса в единицах
