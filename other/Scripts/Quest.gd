@icon("res://Images/quest_res_icon.png")
extends Resource
class_name Quest

enum complete_type {
	READ_DIALOGUE = 0, ##ПРИ ВЫБОРЕ ЭТОГО ТИПА ДИАЛОГ ПОКАЖЕТ ТОЛЬКО text_greetings + кнопку answer_agree, при нажатию по которой квест автоматически закончится и окно закроется
	PLACE_BUILD_ANY = 1, ##Поставить int_value любых районов
	PLACE_BUILD_TYPE = 2, ##Поставить int_value районов ОПРЕДЕЛЁННОГО типа building_type
	APPOINT_WORKER_ANY = 3, ##Назначить int_value любых работников
	APPOINT_WORKER_TYPE = 4, ##Назначить int_value ОПРЕДЕЛЁННЫХ работников типа worker_type в любые районы
	APPOINT_SPECIAL = 5 ##Назначить ОПРЕДЕЛЁННОГО работника типа worker_type в ОПРЕДЕЛЁННЫЙ район типа building_type
}

@export_category("ДИАЛОГ")
@export var icon: Texture ##Текустурка персонажа что будет показыватся в диалоговом окне
@export var quest_name: String ##Название квеста
@export var is_mandatory: bool = true ##Является ли квест обязательным?
@export var character_name: String ##Как зовут персонажа
@export var worker: Global.workers ##Чисто айди работника. Нужен только чтобы при вызове этого квеста при выполнении другого, другой квест понимал ID работника у которого квест нужно вызвать.

##Когда игрок получает квест - игра проверяет какие квесты игрок уже прошёл. Если некоторые не были пройдены - квест не начинается
@export_category("ЗАВИСИМОСТИ") 
@export var done_quest_dependencies: Array[Quest] ##От какий ВЫПОЛНЕНЫХ квестов будет зависит то, что игрок получит этот квест
@export var any_quest_dependencies: Array[Quest] ##От какий СКИПНУТЫХ ИЛИ ВЫПОЛНЕНЫХ квестов будет зависит то, что игрок получит этот квест

@export_category("ПОСЛЕДУЮЩИЕ КВЕСТЫ")
@export var quest_after: Array[String] ##Путь к тому какие квесты будут вызыватся на проверку после выполнения или скипа квеста

@export_category("ПЕРВОЕ УСЛОВИЕ ВЫПОЛНЕНИЯ")
@export var complete_condition: complete_type ##Какое условие чтобы выполнить квест
@export var int_value: int ##Применение зависит от типа выполнения. Смотри типы квестов
@export var building_type: Building ##Тип района, применение зависит от типа выполнения. Смотри типы квестов
@export var worker_type: Worker ##Тип работника, применение зависит от типа выполнения. Смотри типы квестов

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
