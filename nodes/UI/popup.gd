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
		"Z1D3":
			$CL/Popup/VBC/Name.text = "Конвейерный сектор"
			$CL/Popup/VBC/Description.text = "Громадный завод, символ труда и мануфактуры."
			
		"Alpha":
			$CL/Popup/VBC/Name.text = "Класс А"
			$CL/Popup/VBC/Description.text = "Наивысший чин в сфере науки."
		"SnowSc":
			$CL/Popup/VBC/Name.text = "Снегонаука"
			$CL/Popup/VBC/Description.text = "Снегонаука - это новый и инновационный способ выработки электроэнергии путем использования снега. Во время процессов генерируется микроток, который в дальнейшем аккумулируется в общую электросеть."
		"Z2D1":
			$CL/Popup/VBC/Name.text = "Сборщик снежинок"
			$CL/Popup/VBC/Description.text = "Район, спроектированный учёными, позволяет вырабатывать из снега немного электроэнергии."
		"Z2D2":
			$CL/Popup/VBC/Name.text = "Собиратель Метелей"
			$CL/Popup/VBC/Description.text = "Переработка механизма Сборщика Снежинок позволила установить большее количество ЛЭП, а вместе с этим cоответственно увеличить производимый ресурс."
		"Z2D3":
			$CL/Popup/VBC/Name.text = "Покоритель вьюг"
			$CL/Popup/VBC/Description.text = "Величайшее творение в сфере электротехнологии, массивное сооружение, способное запитать электричеством целые районы."
		"RezeRE":
			$CL/Popup/VBC/Name.text = "Рецидивисты"
			$CL/Popup/VBC/Description.text = "Преступник, который умышлено второй раз нарушает закон после шрафов и наказаний."
		"DeboRE":
			$CL/Popup/VBC/Name.text = "Дебоширы"
			$CL/Popup/VBC/Description.text = "Люди, которые нарушают общественный порядок."
		"Science":
			$CL/Popup/VBC/Name.text = "Научный коллектив"
			$CL/Popup/VBC/Description.text = "О.Ф. или же учёные - это отобранные империей специалисты с опытом и множеством знаний."
		"Radio":
			$CL/Popup/VBC/Name.text = "Радио"
			$CL/Popup/VBC/Description.text = "Технология, что была распрастронена в Тёмные века, когда Империи ещё не было."
		"LighC":
			$CL/Popup/VBC/Name.text = "????"
			$CL/Popup/VBC/Description.text = "??????.???.08?"
		"AgeOf":
			$CL/Popup/VBC/Name.text = "Эпоха"
			$CL/Popup/VBC/Description.text = "В данный момент идёт Благо-имперская эпоха. 
Начало её дотируется со основания Великой Астурской империей Робертом Гийомом, 200 лет назад."
		"SunC":
			$CL/Popup/VBC/Name.text = "&&&&???1??"
			$CL/Popup/VBC/Description.text = "??*???**?*"
		"Throw":
			$CL/Popup/VBC/Name.text = "Отправить"
			$CL/Popup/VBC/Description.text = "Назначить работника (ЛКМ) на нужный район."
		"SongC":
			$CL/Popup/VBC/Name.text = "Песни"
			$CL/Popup/VBC/Description.text = "Песни, что доносились ветром"
		"Cuelt":
			$CL/Popup/VBC/Name.text = "Культ"
			$CL/Popup/VBC/Description.text = "В Великой Астуркой империи запрещена любая вера. Нарушителей называют язычниками или же культистами."
		"Comp3":
			$CL/Popup/VBC/Name.text = "Высокие Технологие"
			$CL/Popup/VBC/Description.text = "Сложные и комплексные механизмы"
		"TrES":
			$CL/Popup/VBC/Name.text = "TrES - тайная полиция"
			$CL/Popup/VBC/Description.text = "Тайная имперская полиция, которая занимается расследованиями и выявлением врагов режима."
		"Mison":
			$CL/Popup/VBC/Name.text = ""
			$CL/Popup/VBC/Description.text = ""
		"Z3D3":
			$CL/Popup/VBC/Name.text = "Электросхемный квартал"
			$CL/Popup/VBC/Description.text = "Апофеоз слова контроль. Громадная цитадель пронзает небеса, под ней копошатся домики."
		"Rock":
			$CL/Popup/VBC/Name.text = "#44566.1"
			$CL/Popup/VBC/Description.text = "Расшифровка: облелиск, треугольнообразной формы."
		"Destroy":
			$CL/Popup/VBC/Name.text = "#Штормовой-Прилив.8"
			$CL/Popup/VBC/Description.text = "Расшифровка: План по уничтожению обелиска-монолита."
		"Start":
			$CL/Popup/VBC/Name.text = "Код #4335 - префикс старт"
			$CL/Popup/VBC/Description.text = "Расшифровка: Производство Тяжёлых компонентов успешный старт"
		"NStart":
			$CL/Popup/VBC/Name.text = "Код #4335. "
			$CL/Popup/VBC/Description.text = "Расшифровка: Производство Тяжёлых компонентов"
		"ZStart":
			$CL/Popup/VBC/Name.text = "Код #4335 - префикс Старт 2.0"
			$CL/Popup/VBC/Description.text = "Расшифровка: Производство Тяжёлых компонентов - второй успешный старт"
		"Scrap":
			$CL/Popup/VBC/Name.text = "Ржавая Жесть"
			$CL/Popup/VBC/Description.text = "Ржавая жесть - продукт производства Старых заводов. Представляет собой различный металлолом, порой даже он нужен."
		"ElSnow":
			$CL/Popup/VBC/Name.text = "Электроснег"
			$CL/Popup/VBC/Description.text = "Электроснег - продукт Снегонаучного производства. Представляет собой сгусток электричества, используется для запитывания домов и станций."
		"Highcom":
			$CL/Popup/VBC/Name.text = "Высококачественные Электросхемы"
			$CL/Popup/VBC/Description.text = "Высококачественные Электросхемы - это продукт Высоких Технологий. Представляют собой сложный комплекс из плат, контактных дорожек и процессеров."
		"Heavyco":
			$CL/Popup/VBC/Name.text = "Арсенал"
			$CL/Popup/VBC/Description.text = "Арсенал - продукт комплекса из заводов Военная мощь. Оружия нужны всегда. Будь это война, или же мирная жизнь."
		"EmPower":
			$CL/Popup/VBC/Name.text = "Астурская Мощь"
			$CL/Popup/VBC/Description.text = "Мощь служения Великой Астурской Империи"
		"CuPower":
			$CL/Popup/VBC/Name.text = "Культистская Мощь"
			$CL/Popup/VBC/Description.text = "Мощь почитания Великого Нъхорфаада."
			%Popup.hide()
