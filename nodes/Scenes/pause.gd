extends CanvasLayer

func _ready() -> void:
	$"../Fade".show()
	$".".hide()
	get_tree().paused = false
	await get_tree().create_timer(1).timeout
	$"../Fade/Fade".play("Fade_in")

func _input(event: InputEvent) -> void:
	if event.is_action_released("Pause"):
		if $".".visible:
			$".".hide()
			get_tree().paused = false
			Settings.hide()
		else:
			$".".show()
			get_tree().paused = true

func _on_continue_pressed() -> void:
	$".".hide()
	get_tree().paused = false
	Settings.hide()

func _on_settings_pressed() -> void:
	Settings.show()

func _on_exit_to_main_pressed() -> void:
	$ConfirmationDialog.show()

func exit():
	Global.is_ending = false
	get_tree().paused = false
	$"../Fade/Fade".play("Fade_out")

func _on_button_base_ui_pressed() -> void:
	$".".show()
	get_tree().paused = true

func _on_fade(anim_name: StringName) -> void:
	if anim_name == "Fade_out":
		if Global.is_ending:
			get_tree().change_scene_to_file("res://nodes/Scenes/endings.tscn")
		else:
			get_tree().change_scene_to_file("res://nodes/Scenes/Main_menu.tscn")

func _on_confirmation_dialog_confirmed() -> void:
	exit()

func _on_confirmation_dialog_canceled() -> void:
	$ConfirmationDialog.hide()
