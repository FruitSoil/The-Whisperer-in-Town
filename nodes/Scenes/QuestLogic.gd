extends Node

@onready var workers: Array[WorkerPanel] = [%ADMIN,%worker,%worker2,%worker4,%worker3,%worker5,%worker6]
@onready var base_ui: Control = %BaseUI

func _ready() -> void:
	var tutor = load("res://resources/Quests/ADMIN/TutorialPart1.tres")
	ql_wait_to_next(1, tutor, Global.workers.ADMIN)

##Добавить квест типа new_quest персонажу worker через wait_time секунд
func ql_wait_to_next(wait_time: float, new_quest: Quest, worker: Global.workers) -> void:
	await get_tree().create_timer(wait_time).timeout
	ql_set_quest(new_quest, worker)

##Добавить персонажу worker_ID квест типа quest. В случае уже существующего квеста у персонажа вызывает !BREAKPOINT!
func ql_set_quest(quest: Quest, worker_ID:Global.workers) -> void:
	if workers[worker_ID]:
		
		if workers[worker_ID].quest_res:
			push_warning(workers[worker_ID].res.name, " УЖЕ ИМЕЕТ ЗАПУЩЕННЫЙ КВЕСТ ",workers[worker_ID].quest_res.quest_name ," - КВЕСТ ",quest.quest_name , " НЕ БУДЕТ ВЫЗВАН ")
			print(workers[worker_ID].res.name, " УЖЕ ИМЕЕТ ЗАПУЩЕННЫЙ КВЕСТ ",workers[worker_ID].quest_res.quest_name ,", ПРОВЕРЬ ПРАВИЛЬНУЮ ПОСЛЕДОВАТЕЛЬНОСТИ КВЕСТОВ")
		
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
			%BaseUI.add_quest(quest,workers[worker_ID])
		else:
			# debug
			print(" ")
			print("ДЛЯ ВЫЗОВА КВЕСТА ",quest.quest_name," НЕ БЫЛИ ПРОЙДЕНЫ/ВЫПОЛНЕНЫ ВСЕ ОСТАЛЬНЫЕ КВЕСТЫ НИЖЕ")
			print("НЕОБЯЗАТЕЛЬНЫЕ:")
			for i in quest.any_quest_dependencies:
				print(" - ", i.quest_name)
			print("ОБЯЗАТЕЛЬНЫЕ:")
			for i in quest.done_quest_dependencies:
				print(" - ", i.quest_name)
			print("ПОВТОРНЫЙ ВЫЗОВ ДРУГИМ УСЛОВИЕМ МОЖЕТ ВЫЗВАТЬ КВЕСТ ЕСЛИ В ТОТ МОМЕНТ ОСТАЛЬНЫЕ КВЕСТЫ БУДУТ ПРОЙДЕНЫ/ВЫПОЛНЕНЫ")

func check_for_all():
	var count: int = -1
	for i in workers:
		count += 1
		if i.quest_res and i.quest_stage == 3:
			check_quest_done_status(i.quest_res, count as Global.workers)
			print("ПРОВЕРКА КВЕСТА НА ВЫПОЛНЕНОСТЬ У РАБОТНИКА ", count as Global.workers)

func check_quest_done_status(quest: Quest, worker_ID:Global.workers):
	match quest.complete_condition:
		0:
			quest_done(worker_ID)
		1:
			if Global.total_buildings.size() >= quest.int_value:
				quest_done(worker_ID)
		2:
			var count: int = 0
			for i in Global.total_buildings:
				for o in quest.building_type:
					if o == i:
						count += 1
						break
			
			if count >= quest.int_value:
				quest_done(worker_ID)
		3:
			if Global.total_workers.size() >= quest.int_value:
				quest_done(worker_ID)
		4:
			var count: int = 0
			for i in Global.total_workers:
				if i == quest.worker_type:
					count += 1
				if i.worker.resource_name == "Default" and quest.worker_type.resource_name == "Default":
					count += 1
			
			if count >= quest.int_value:
				quest_done(worker_ID)
		5:
			var count: int = 0
			for i in Global.total_work_on_build:
				if i.build:
					for o in quest.building_type:
						if o == i.build:
							if i.worker == quest.worker_type:
								count += 1
							if i.worker.resource_name == "Default" and quest.worker_type.resource_name == "Default":
								count += 1
							break
			
			if count >= quest.int_value:
				quest_done(worker_ID)
		6:
			match quest.int_value:
				2:
					if Global.is_zone_2_open:
						quest_done(worker_ID)
				3:
					if Global.is_zone_3_open:
						quest_done(worker_ID)
				4:
					if Global.is_zone_4_open:
						quest_done(worker_ID)
				5:
					if Global.is_zone_5_open:
						quest_done(worker_ID)

func quest_done(worker_ID:Global.workers):
	$"../Audio/QuestDone".play()
	workers[worker_ID].can_be_placed = false
	workers[worker_ID].quest_stage = 4
	workers[worker_ID].update_icon()
