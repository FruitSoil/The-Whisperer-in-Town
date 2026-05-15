## Имеет все данные о здании, которые автоматически используются в UI и в объектах cell 
@icon("res://Images/Building_res_icon.png")
extends Resource
class_name Building 

@export_category("Данные здания")
@export var res_type: Global.res_types ## Тип ресурса
@export var res_count_per_timer: int ##Количество ресурсов за выработку по таймеру
@export var res_count_per_click: Vector2i ##Количество ресурсов за клик X-минимум, Y-максимум
@export var res_timer: float = 3.0 ##Время выработки ресурса
@export var model: PackedScene ##Модель что используется зданием
@export_category("Дополнительная выработка")
@export var second_res_type: Global.res_types ## Дополнительный тип ресурса
@export var second_res_count_per_timer: int ##Количество дополнительного ресурса за выработку по таймеру
@export_category("В магазине")
@export_range(1,3) var tier: int ##Тир здания от 1 до 3, определяет только кол-во звезд в магазине
@export var buy_cost: int ##За сколько здание покупается
@export var buy_cost_type: Global.res_types ##За какой тип ресурса здание покупается
@export var name: String ## Название района в магазине
@export_multiline var description: String ## Описание района в магазине
@export var shop_icon: Texture2D ## Иконка в магазине
