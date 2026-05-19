extends Node

@onready var workers: Array[WorkerPanel] = [%ADMIN,%worker,%worker2,%worker3,%worker4,%worker5,%worker6]

func _ready() -> void:
	ql_wait_to_next(3, load("res://resources/Quests/TutorialPart1.tres"),Global.workers.ADMIN)

##Добавить квест типа new_quest персонажу worker через wait_time секунд
func ql_wait_to_next(wait_time: float, new_quest: Quest, worker: Global.workers) -> void:
	await get_tree().create_timer(wait_time).timeout
	ql_set_quest(new_quest, worker)

##Добавить персонажу worker_ID квест типа quest. В случае уже существующего квеста у персонажа вызывает !BREAKPOINT!
func ql_set_quest(quest: Quest, worker_ID:Global.workers) -> void:
	if workers[worker_ID]:
		
		if workers[worker_ID].quest_res:
			print(workers[worker_ID].res.name, " УЖЕ ИМЕЕТ ЗАПУЩЕННЫЙ КВЕСТ ",workers[worker_ID].quest_res.quest_name ,", ПРОВЕРЬ ПРАВИЛЬНУЮ ПОСЛЕДОВАТЕЛЬНОСТИ КВЕСТОВ")
			breakpoint
		
		var done_coincidences := 0
		var any_coincidences := 0
		
		if quest.done_quest_dependencies:
			for i in quest.done_quest_dependencies:
				if Global.quest_done.has(i):
					done_coincidences += 1
		
		if quest.any_quest_dependencies:
			for i in quest.any_quest_dependencies:
				if Global.quest_skip.has(i):
					any_coincidences += 1
			for o in quest.any_quest_dependencies:
				if Global.quest_done.has(o):
					any_coincidences += 1
		
		if done_coincidences == quest.done_quest_dependencies.size() and any_coincidences == quest.any_quest_dependencies.size():
			workers[worker_ID].add_quest(quest)
		else:
			# debug
			print("ДЛЯ ВЫЗОВА КВЕСТА ",quest.quest_name," НЕ БЫЛИ ПРОЙДЕНЫ/ВЫПОЛНЕНЫ ВСЕ ОСТАЛЬНЫЕ КВЕСТЫ НИЖЕ")
			print("НЕОБЯЗАТЕЛЬНЫЕ:")
			for i in quest.any_quest_dependencies:
				print(" - ", i.quest_name)
			print("ОБЯЗАТЕЛЬНЫЕ:")
			for i in quest.done_quest_dependencies:
				print(" - ", i.quest_name)
			print("ПОВТОРНЫЙ ВЫЗОВ ДРУГИМ УСЛОВИЕМ МОЖЕТ ВЫЗВАТЬ КВЕСТ ЕСЛИ В ТОТ МОМЕНТ ОСТАЛЬНЫЕ КВЕСТЫ БУДУТ ПРОЙДЕНЫ/ВЫПОЛНЕНЫ")
