extends CanvasLayer

@onready var res_panel: Control = $"../HUD/BaseUI/res_panel"

@onready var variant_yes: Button = $Panel/VBC/Variant_yes
@onready var variant_later: Button = $Panel/VBC/Variant_later
@onready var variant_no: Button = $Panel/VBC/Variant_no
@onready var dialogue_animation: AnimationPlayer = $Dialogue_animation
@onready var rich_text_label: RichTextLabel = $Panel/MC/RichTextLabel

const ADMIN_EV2_2 = preload("uid://b5qdl6plgdx2l")
const EV_2 = preload("uid://p72rumrqgqhh")
const V = preload("uid://cr44o6eo2njb1")
const END = preload("uid://bdkjdx3u8i44s")

var res: Quest
var worker_panel: WorkerPanel

func _ready() -> void:
	rich_text_label.meta_clicked.connect(show_popup)
	rich_text_label.meta_hover_ended.connect(hide_popup)
	variant_yes.pressed.connect(answer.bind(1))
	variant_later.pressed.connect(answer.bind(2))
	variant_no.pressed.connect(answer.bind(3))
	close_window()

func update_data():
	if res:
		$Panel/Quest_name.text = res.quest_name
		$Panel/Fon/Portair.texture = res.icon
		$Panel/Fon/Shadow.texture = res.icon
		$Panel/Character_name.text = res.character_name
		
		variant_yes.text = res.answer_agree
		variant_later.text = res.answer_wait
		variant_no.text = res.answer_reject
		
		print(worker_panel.quest_stage)
		match worker_panel.quest_stage:
			1:
				type_text(res.text_greetings)
				variant_yes.show()
				variant_later.show()
				
				if res.is_mandatory:
					variant_no.hide()
				else:
					variant_no.show()
				
				if res.complete_condition == 0:
					variant_later.hide()
					variant_no.hide()
			2:
				type_text(res.text_reject)
				variant_yes.hide()
				variant_no.show()
				variant_later.hide()
			3:
				type_text(res.text_progress)
				variant_yes.hide()
				variant_no.hide()
				variant_later.hide()
			4:
				type_text(res.text_finish)
				variant_yes.show()
				variant_yes.text = "(Закончить квест)"
				variant_no.hide()
				variant_later.hide()
			5:
				rich_text_label.text = res.text_greetings
				rich_text_label.visible_ratio = 1.0
				twr.stop()
				variant_yes.show()
				variant_later.show()
				if res.is_mandatory:
					variant_no.hide()
				else:
					variant_no.show()
				
				if res.complete_condition == 0:
					variant_later.hide()
					variant_no.hide()

func _on_exit_button_pressed() -> void:
	close_window()
	if worker_panel.quest_stage == 1:
		worker_panel.quest_stage = 5
		worker_panel.update_icon()

func open_window(resource: Quest):
	res = resource
	rich_text_label.get_v_scroll_bar().value = 0
	dialogue_animation.play("Show")
	update_data()

func close_window():
	rich_text_label.visible_ratio = 1.0
	twr.kill()
	dialogue_animation.play("Hide")

func answer(ID: int):
	match ID:
		1:
			if worker_panel.quest_stage == 1 or worker_panel.quest_stage == 5:
				if res == ADMIN_EV2_2:
					close_window()
					%worker3.quest_res = EV_2
					%worker3.quest_stage = 3
					%worker3.update_icon()
					%worker3.can_be_placed = true
				elif res == V:
					verdict_logic(true)
					close_window()
					worker_panel.quest_res = null
					worker_panel.quest_stage = 0
					worker_panel.update_icon()
					return
				elif res == END:
					res_panel.final_stage_show()
					close_window()
					worker_panel.quest_res = null
					worker_panel.quest_stage = 0
					worker_panel.update_icon()
					return
				
				close_window()
				worker_panel.quest_stage = 3
				if res.open_after_accept:
					worker_panel.can_be_placed = true
				worker_panel.update_icon()
				
				if res.complete_condition == 0:
					%QuestLogic.check_for_all()
			if worker_panel.quest_stage == 4:
				Global.quest_done.append(res)
				%BaseUI.erase_quest(res)
				close_window()
				if res.quest_after:
					for i in res.quest_after:
						if i:
							var path = load(i)
							%QuestLogic.ql_wait_to_next(1,path,path.worker)
				if res.reward_res_count > 0:
					print("1 НАГРАДА ПОЛУЧЕНА")
					Global.add_to_integer_res_type(res.reward_res_type, res.reward_res_count)
					%BaseUI.change_label(res.reward_res_type, true)
				if res.sec_reward_res_count > 0:
					print("2 НАГРАДА ПОЛУЧЕНА")
					Global.add_to_integer_res_type(res.sec_reward_res_type, res.sec_reward_res_count)
					%BaseUI.change_label(res.sec_reward_res_type, true)
				if res.building_unlock_res:
					get_tree().call_group("lvl","unlock",res.building_unlock_res)
				if res.zone_res:
					var zone = res.zone_res
					zone.bonus_res_type = res.zone_bonus_resource_type
					zone.bonus_res_count  = res.zone_bonus_resource_count
					print(zone.name, " установлен бонус на ресурс ", Global.get_res_name(zone.bonus_res_type), " на ",zone.bonus_res_count  ," за каждую выроботку района с этим ресурсом")
				worker_panel.quest_res = null
				worker_panel.quest_stage = 0
				worker_panel.update_icon()
		2:
			if res == V:
				verdict_logic(false)
				close_window()
				worker_panel.quest_res = null
				worker_panel.quest_stage = 0
				worker_panel.update_icon()
				return
			close_window()
			worker_panel.quest_stage = 5
			worker_panel.update_icon()
		3:
			if worker_panel.quest_stage != 2:
				worker_panel.can_be_placed = false
				type_text(res.text_reject) 
				variant_yes.hide()
				variant_no.show()
				variant_no.text = "(Продолжить)"
				variant_later.hide()
				worker_panel.quest_stage = 2
				worker_panel.update_icon()
				
			else:
				%BaseUI.erase_quest(res)
				Global.quest_skip.append(res)
				variant_no.text = "(Продолжить)"
				for i in res.reject_other_quest_skip:
					if i:
						var path = load(i)
						Global.quest_skip.append(path)
				if res == EV_2:
					%QuestLogic.ql_wait_to_next(2,ADMIN_EV2_2,ADMIN_EV2_2.worker)
					close_window()
					worker_panel.quest_res = null
					worker_panel.quest_stage = 0
					worker_panel.update_icon()
					return
				if res.quest_after:
						for i in res.quest_after:
							if i:
								var path = load(i)
								%QuestLogic.ql_wait_to_next(4,path,path.worker)
				close_window()
				worker_panel.quest_res = null
				worker_panel.quest_stage = 0
				worker_panel.update_icon()

var character_delay: float = 0.018
var twr = create_tween().set_trans(Tween.TRANS_LINEAR)

func _on_rich_text_label_gui_input(event: InputEvent) -> void:
	if event.is_action_released("place"):
		if twr and twr.is_valid():
			twr.kill()
		rich_text_label.visible_ratio = 1.0

func type_text(new_text: String) -> void:
	if twr and twr.is_valid():
		twr.kill()
	rich_text_label.text = new_text
	rich_text_label.visible_ratio = 0.0
	await get_tree().process_frame
	var total_duration = rich_text_label.get_parsed_text().length() * character_delay
	twr = create_tween().set_trans(Tween.TRANS_LINEAR)
	twr.tween_property(rich_text_label, "visible_ratio", 1.0, total_duration)

func _anim_finished(anim_name: StringName) -> void:
	if anim_name == "Hide":
		%QuestLogic.check_for_all()

func show_popup(meta: Variant) -> void:
	if meta != null:
		Popups.ShowPopup(str(meta))

func hide_popup(_meta: Variant) -> void:
	Popups.hidePopup()

func verdict_logic(is_art_bell: bool):
	var art = preload("res://resources/Quests/Radio/TR2.tres")
	var keterin = preload("res://resources/Quests/Agent/TR1.tres")
	var verdict_quest = preload("res://resources/Quests/Radio/V.tres")
	
	Global.quest_done.append(verdict_quest)
	%BaseUI.erase_quest(verdict_quest)
	res_panel.verdict_change_side(is_art_bell)
	if is_art_bell:
		print("art selected")
		%QuestLogic.ql_wait_to_next(4,art,art.worker)
	else:
		print("keterin selected")
		%QuestLogic.ql_wait_to_next(4,keterin,keterin.worker)
