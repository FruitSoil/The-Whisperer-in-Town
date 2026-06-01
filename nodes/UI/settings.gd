extends CanvasLayer

@onready var exit: Button = $Exit

@onready var master_percent: Label = $Sounds/Master/Master/Percent

@onready var sliders: Array[HSlider] = [
	$Sounds/Master/MasterSlider
]

func _ready() -> void:
	var index: int = -1
	
	for slider in sliders:
		index += 1
		slider.value_changed.connect(change_volume.bind(index))
		slider.value = AudioServer.get_bus_volume_db(index)
	
	exit.pressed.connect(_on_button_pressed)
	hide()

func change_volume(value: int, ID: int):
	match ID:
		1:
			AudioServer.set_bus_volume_db(0,value)
			master_percent.text = str(value)

func _on_button_pressed() -> void:
	hide()
