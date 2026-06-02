extends Node2D

@export_multiline() var imperial_ending_text = "Хорошая работа, Олег"
@export_multiline() var cultistic_ending_text = "-Это пизда или нормалды? \n- Нет это не нормалды, это пизда \n- Хааахаахаааа... Это пизда!!!! \n  - 'Меллстройность'"

@onready var description: RichTextLabel = $CanvasLayer/Description
@onready var cultistic: TextureRect = $CanvasLayer/Cultistic
@onready var imperial: TextureRect = $CanvasLayer/Imperial
@onready var to_menu_button: Button = $CanvasLayer/ToMenuButton

var character_delay = 0.04

func _ready() -> void:
	to_menu_button.pressed.connect(to_menu)
	description.text = ""
	to_menu_button.hide()
	if Global.is_current_ending_imper:
		cultistic.hide()
		imperial.show()
	else:
		cultistic.show()
		imperial.hide()
	$Fade/Fade.play("Fade_out")

func label_start():
	if Global.is_current_ending_imper:
		description_tween(imperial_ending_text)
	else:
		description_tween(cultistic_ending_text)

func description_tween(new_text: String):
	description.text = new_text
	description.visible_ratio = 0.0
	var total_duration = description.get_parsed_text().length() * character_delay
	var twr = create_tween().set_trans(Tween.TRANS_LINEAR)
	twr.tween_property(description, "visible_ratio", 1.0, total_duration)
	await get_tree().create_timer(total_duration + 2).timeout
	to_menu_button.show()
	to_menu_button.modulate = Color(1.0, 1.0, 1.0, 0.0)
	var twrt = create_tween().set_trans(Tween.TRANS_LINEAR)
	twrt.tween_property(to_menu_button, "modulate", Color(1.0, 1.0, 1.0, 1.0), 1)

func to_menu():
	$Fade/Fade.play("Fade_in")
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://nodes/Scenes/Main_menu.tscn")
