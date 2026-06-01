extends CanvasLayer

@onready var exit: Button = $Exit
@onready var master_percent: Label = $Sounds/Master/Master/Percent
@onready var percents: Array[Label]
@onready var sliders: Array[HSlider] = [
	$Sounds/Master/MasterSlider,
	
]

func _ready() -> void:
	for i in range(sliders.size()):
		var bus_db_value = AudioServer.get_bus_volume_db(i)
		sliders[i].value = bus_db_value
		sliders[i].value_changed.connect(change_volume.bind(i))
		
		if i == 0:
			update_percent_label(bus_db_value)
	
	exit.pressed.connect(_on_button_pressed)
	hide()

func change_volume(value: float, bus_id: int) -> void:
	AudioServer.set_bus_volume_db(bus_id, value)
	
	if bus_id == 0:
		update_percent_label(value)

func update_percent_label(db_value: float) -> void:
	var linear_val = db_to_linear(db_value)
	var percentage = round(linear_val * 100)
	master_percent.text = str(percentage)

func _on_button_pressed() -> void:
	hide()
