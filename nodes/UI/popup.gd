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
		"EmpG":
			$CL/Popup/VBC/Name.text = "Великая Астурская империя"
			$CL/Popup/VBC/Description.text = "Ныне величайшая империя, что под своей опекой держит все материки мира."
		"Boss":
			$CL/Popup/VBC/Name.text = "Руководство"
			$CL/Popup/VBC/Description.text = "Высшее руководство, состоящие из династийных чиновников. Они даровали вам эту должность."
		"Robert":
			$CL/Popup/VBC/Name.text = "Роберт Гийом"
			$CL/Popup/VBC/Description.text = "Ныне покойный, основатель Великой Астурской империи, олицетворение закона и справедливости - Робер Гийом."
		"Loyal":
			$CL/Popup/VBC/Name.text = "Лояльность"
			$CL/Popup/VBC/Description.text = "'Лояльность - это главное оружие в руках правителя' - Роберт Гийом."
		"Must":
			$CL/Popup/VBC/Name.text = "Указ"
			$CL/Popup/VBC/Description.text = "Официальный и подписанный руководством указ. В какой-то степени можно считать это приказом."
		"Should":
			$CL/Popup/VBC/Name.text = "Просьба"
			$CL/Popup/VBC/Description.text = "Не официальная и зачастую личная просьба. Исполнять её или нет, это вам решать."
		_:
			%Popup.hide()
