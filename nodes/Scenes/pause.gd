extends CanvasLayer

func _ready() -> void:
	$"../Fade".show()
	$Control.hide()
	$".".hide()
	get_tree().paused = false
	await get_tree().create_timer(1).timeout
	$"../Fade/Fade".play("Fade_in")

func _input(event: InputEvent) -> void:
	if event.is_action_released("Pause"):
		if $".".visible:
			$".".hide()
			get_tree().paused = false
		else:
			$".".show()
			get_tree().paused = true

func _on_continue_pressed() -> void:
	$".".hide()
	get_tree().paused = false

func _on_settings_pressed() -> void:
	$Control.show()

func _on_exit_to_main_pressed() -> void:
	$"../Fade/Fade".play("Fade_out")
	get_tree().paused = false

func _on_button_pressed() -> void:
	$Control.hide()

func _on_button_base_ui_pressed() -> void:
	$".".show()
	get_tree().paused = true

func _on_fade(anim_name: StringName) -> void:
	if anim_name == "Fade_out":
		get_tree().change_scene_to_file("res://nodes/Scenes/Main_menu.tscn")
