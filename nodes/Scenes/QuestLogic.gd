extends Node

@onready var workers: Array[WorkerPanel] = [%ADMIN,%worker,%worker2,%worker3,%worker4,%worker5,%worker6]

func _ready() -> void:
	ql_wait_to_next(7, load("res://resources/Quests/TutorialPart1.tres"),Global.workers.ADMIN)

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
		
		workers[worker_ID].add_quest(quest)
