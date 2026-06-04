extends CanvasLayer

@onready var exit: Button = $Exit
@onready var reset: Button = $Default/Reset

@onready var percents: Array[Label] = [
	$Sounds/Master/Master/Percent,
	$Sounds/VBC/VBC2/UI/Percent,
	$Sounds/VBC/VBC2/SFX/Percent,
	$Sounds/VBC/VBC/Music/Percent,
	$Sounds/VBC/VBC/Ambient/Percent,
]

@onready var sliders: Array[HSlider] = [
	$Sounds/Master/MasterSlider,
	$Sounds/VBC/VBC2/UISlider,
	$Sounds/VBC/VBC2/SFXSlider,
	$Sounds/VBC/VBC/MusicSlider,
	$Sounds/VBC/VBC/AmbientSlider,
]

func _ready() -> void:
	exit.mouse_entered.connect(sound_hovered)
	reset.mouse_entered.connect(sound_hovered)
	exit.pressed.connect(sound_pressed)
	reset.pressed.connect(sound_pressed)
	
	for i in range(sliders.size()):
		var bus_db_value = AudioServer.get_bus_volume_db(i)
		sliders[i].value = bus_db_value
		
		sliders[i].drag_started.connect(sound_pressed)
		sliders[i].value_changed.connect(change_volume.bind(i))
		update_percent_label(bus_db_value, i)
	
	reset.pressed.connect(reset_audio)
	exit.pressed.connect(_on_button_pressed)
	hide()

func reset_audio() -> void:
	var default_db: float = 0.0
	for i in range(sliders.size()):
		sliders[i].value = default_db
		AudioServer.set_bus_volume_db(i, default_db)
		update_percent_label(default_db, i)

func change_volume(value: float, bus_id: int) -> void:
	AudioServer.set_bus_volume_db(bus_id, value)
	update_percent_label(value, bus_id)

func update_percent_label(db_value: float, bus_id: int) -> void:
	var percentage = round(remap(db_value, -80.0, 10.0, 0.0, 100.0))
	percents[bus_id].text = str(percentage)

func _on_button_pressed() -> void:
	hide()

func sound_hovered():
	$Audio/Digital_click_hover.play()

func sound_pressed():
	$Audio/Digital_click_pressed.play()
