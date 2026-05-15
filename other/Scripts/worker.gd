## Имеет данные работника, имя, описание и прочее
@icon("res://Images/Worker_res_icon.png")
extends Resource
class_name Worker


@export_category("Параметры руководителя")
@export var name: String ##Имя работника
@export var is_unique: bool = false ##Является ли работник уникальным
@export var icon: Texture ##Портрет работника
@export_category("Бонусы/Ухудшения")
@export_multiline var Description: String ##Описание бонусов руководителя
@export var addit_res_type: Global.res_types ##Какой тип ресурса будет изменять свою выработку
@export var addit_res_count: int ##На сколько ресурса в единицах будет производится больше 
##На сколько в секундах будет дольше производится ресурс. 
##Можно ставить отрицательные знач., но будьте осторожно чтобы значение таймера в итоге не было отрицательным - 
##иначе балансу пиздец
@export var res_timer_change: float 
@export var new_res_type: Global.res_types ##Тип дополнительного ресурса что здание будет производить
@export var new_res_count: int ##На сколько дополнительного ресурса в единицах будет производится больше 
@export_category("Нарратив")
@export var nickname: String ##Прозвище/Должность работника, 1-3 слова.
@export_multiline var narrative_description: String ##Нарративное описание работника. Кто это, откуда и кем является.
