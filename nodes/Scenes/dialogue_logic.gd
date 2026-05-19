extends CanvasLayer

@onready var variant_yes: Button = $Panel/VBC/Variant_yes
@onready var variant_later: Button = $Panel/VBC/Variant_later
@onready var variant_no: Button = $Panel/VBC/Variant_no
@onready var dialogue_animation: AnimationPlayer = $Dialogue_animation
@onready var rich_text_label: RichTextLabel = $"../Dialogue/Panel/MC/RichTextLabel"

var character_delay: float = 0.018
var twr 

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
				variant_no.show()
				variant_later.show()
			2:
				type_text(res.text_reject)
				variant_yes.hide()
				variant_no.hide()
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
				variant_no.show()
				variant_later.show()
		
		$Panel/VBC/Variant_yes.text = res.answer_agree
		$Panel/VBC/Variant_later.text = res.answer_wait
		$Panel/VBC/Variant_no.text = res.answer_reject
		
		if res.is_mandatory or res.answer_reject == "":
			$Panel/VBC/Variant_no.hide()
		else:
			$Panel/VBC/Variant_no.show()

func _on_exit_button_pressed() -> void:
	close_window()
	if worker_panel.quest_stage == 1:
		worker_panel.quest_stage = 5
		worker_panel.update_icon()

func open_window(resource: Quest):
	res = resource
	update_data()
	rich_text_label.get_v_scroll_bar().value = 0
	dialogue_animation.play("Show")
	

func close_window():
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
				worker_panel.update_icon()
			if worker_panel.quest_stage == 4:
				close_window()
				worker_panel.quest_res = null
				worker_panel.quest_stage = 0
				worker_panel.update_icon()
		2:
			close_window()
			worker_panel.quest_stage = 5
			worker_panel.update_icon()
		3:
			close_window()
			worker_panel.quest_stage = 2
			worker_panel.update_icon()

func _on_rich_text_label_gui_input(event: InputEvent) -> void:
	if event.is_action_released("place"):
		rich_text_label.visible_ratio = 1.0
		twr.kill()
