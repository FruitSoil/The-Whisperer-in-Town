extends CanvasLayer

@onready var variant_yes: Button = $Panel/VBC/Variant_yes
@onready var variant_later: Button = $Panel/VBC/Variant_later
@onready var variant_no: Button = $Panel/VBC/Variant_no
@onready var dialogue_animation: AnimationPlayer = $Dialogue_animation
@onready var rich_text_label: RichTextLabel = $"../Dialogue/Panel/MC/RichTextLabel"

var character_delay: float = 0.018

var res: Quest

func _ready() -> void:
	variant_yes.pressed.connect(answer.bind(1))
	variant_later.pressed.connect(answer.bind(2))
	variant_no.pressed.connect(answer.bind(3))
	
	res = preload("res://resources/Quests/WorkerPart1.tres")
	open_window()
	update_data()

func _process(delta: float) -> void:
	pass

func update_data():
	if res:
		$Panel/Quest_name.text = res.quest_name
		$Panel/Fon/Portair.texture = res.icon
		$Panel/Fon/Shadow.texture = res.icon
		$Panel/Character_name.text = res.character_name
		
		
		$Panel/VBC/Variant_yes.text = res.answer_agree
		$Panel/VBC/Variant_later.text = res.answer_wait
		$Panel/VBC/Variant_no.text = res.answer_reject
		
		if res.is_mandatory or res.answer_reject == "":
			$Panel/VBC/Variant_no.hide()
		else:
			$Panel/VBC/Variant_no.show()

func _on_exit_button_pressed() -> void:
	close_window()

func open_window():
	dialogue_animation.play("Show")
	type_text(res.text_greetings)

func close_window():
	dialogue_animation.play("Hide")

func type_text(new_text: String) -> void:
	rich_text_label.text = new_text
	rich_text_label.visible_ratio = 0.0
	await get_tree().process_frame
	var total_duration = rich_text_label.get_parsed_text().length() * character_delay
	
	var twr = create_tween().set_trans(Tween.TRANS_LINEAR)
	twr.tween_property(rich_text_label, "visible_ratio", 1.0, total_duration)


func answer(ID: int):
	match ID:
		1:
			close_window()
		2:
			close_window()
		3:
			close_window()
