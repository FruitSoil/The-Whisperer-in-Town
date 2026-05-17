extends CanvasLayer

func _ready() -> void:
	$Control.hide()
	$".".hide()
	get_tree().paused = false

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
	get_tree().paused = false

func _on_button_pressed() -> void:
	$Control.hide()

func _on_button_base_ui_pressed() -> void:
	$".".show()
	get_tree().paused = true
