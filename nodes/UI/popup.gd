extends Control

func _process(_delta: float) -> void:
	if visible:
		%Popup.position.x = get_global_mouse_position().x + %Popup.size.x / 12
		%Popup.position.y = get_global_mouse_position().y - %Popup.size.y / 12
		%Popup.size.x = 0
		%Popup.size.y = 0

func hidePopup():
	%Popup.hide()

func ShowPopup(meta:String):
	%Popup.popup()
	match meta:
		"imper":
			$CL/Popup/VBC/Name.text = "Империя"
			$CL/Popup/VBC/Description.text = "Хепи берздей дэниэл"
		"slivi":
			$CL/Popup/VBC/Name.text = "ВЫВЫ"
			$CL/Popup/VBC/Description.text = "выввы"
