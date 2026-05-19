@icon("res://Images/quest_res_icon.png")
extends Resource
class_name Quest

@export_category("ДИАЛОГ")
@export var icon: Texture ##Текустурка персонажа что будет показыватся в диалоговом окне
@export var quest_name: String ##Название квеста
@export var is_mandatory: bool = true ##Является ли квест обязательным?
@export var character_name: String ##Как зовут персонажа

##Когда игрок получает квест - игра проверяет какие квесты игрок уже прошёл. Если некоторые не были пройдены - квест не начинается
@export_category("ЗАВИСИМОСТИ") 
@export var done_quest_dependencies: Array[Quest] ##От какий ВЫПОЛНЕНЫХ квестов будет зависит то, что игрок получит этот квест
@export var any_quest_dependencies: Array[Quest] ##От какий СКИПНУТЫХ ИЛИ ВЫПОЛНЕНЫХ квестов будет зависит то, что игрок получит этот квест

@export_category("ЭТАПЫ КВЕСТОВ") 
@export_category("Стадия 1. Приветствие")
@export_multiline() var text_greetings: String 
@export_multiline() var answer_agree: String 
@export_multiline() var answer_wait: String 
@export_multiline() var answer_reject: String 

@export_category("Стадия 2. Отклонено")
@export_multiline() var text_reject: String 


@export_category("Стадия 3. В процессе")
@export_multiline() var text_progress: String 

@export_category("Стадия 4. Готово")
@export_multiline() var text_finish: String 

@export_category("НАГРАДА ЗА ВЫПОЛНЕНИЕ КВЕСТА")
@export var reward_res_type: Global.res_types ## Тип ресурса который игрок получит за выполнение квеста
@export var reward_res_count: int ## Количество ресурса который игрок получит за выполнение квеста
@export var sec_reward_res_type: Global.res_types ## Второй тип ресурса который игрок получит за выполнение квеста
@export var sec_reward_res_count: int ## Количество второго ресурса который игрок получит за выполнение квеста
@export var building_unlock_res: Building ## Какое здание разблокируется в магазине за выполнение квеста 
