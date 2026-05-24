extends CanvasLayer

@onready var variant_yes: Button = $Panel/VBC/Variant_yes
@onready var variant_later: Button = $Panel/VBC/Variant_later
@onready var variant_no: Button = $Panel/VBC/Variant_no
@onready var dialogue_animation: AnimationPlayer = $Dialogue_animation
@onready var rich_text_label: RichTextLabel = $"../Dialogue/Panel/MC/RichTextLabel"

var character_delay: float = 0.018
var twr = create_tween().set_trans(Tween.TRANS_LINEAR)

var res: Quest
var worker_panel: WorkerPanel

func _ready() -> void:
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
		
		$Panel/VBC/Variant_yes.text = res.answer_agree
		$Panel/VBC/Variant_later.text = res.answer_wait
		$Panel/VBC/Variant_no.text = res.answer_reject

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

func type_text(new_text: String) -> void:
	rich_text_label.text = new_text
	rich_text_label.visible_ratio = 0.0
	await get_tree().process_frame
	var total_duration = rich_text_label.get_parsed_text().length() * character_delay
	twr = create_tween().set_trans(Tween.TRANS_LINEAR)
	twr.tween_property(rich_text_label, "visible_ratio", 1.0, total_duration)

func answer(ID: int):
	match ID:
		1:
			if worker_panel.quest_stage == 1 or worker_panel.quest_stage == 5:
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
				worker_panel.quest_res = null
				worker_panel.quest_stage = 0
				worker_panel.update_icon()
		2:
			close_window()
			worker_panel.quest_stage = 5
			worker_panel.update_icon()
		3:
			if worker_panel.quest_stage != 2:
				worker_panel.can_be_placed = false
				type_text(res.text_reject) 
				variant_yes.hide()
				variant_no.show()
				variant_later.hide()
				worker_panel.quest_stage = 2
				worker_panel.update_icon()
			else:
				%BaseUI.erase_quest(res)
				Global.quest_skip.append(res)
				if res.quest_after:
						for i in res.quest_after:
							if i:
								var path = load(i)
								%QuestLogic.ql_wait_to_next(4,path,path.worker)
				close_window()
				worker_panel.quest_res = null
				worker_panel.quest_stage = 0
				worker_panel.update_icon()

func _on_rich_text_label_gui_input(event: InputEvent) -> void:
	if event.is_action_released("place"):
		rich_text_label.visible_ratio = 1.0
		twr.kill()


func _anim_finished(anim_name: StringName) -> void:
	if anim_name == "Hide":
		%QuestLogic.check_for_all()

func _dialogue_text_hover_start(meta: Variant) -> void:
	if meta != null:
		Popups.ShowPopup(str(meta))

func _dialogue_text_hover_end(meta: Variant) -> void:
	Popups.hidePopup()
