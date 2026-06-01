extends Panel

@export var ID: int = 0

@onready var label: Label = $Label
@onready var texture_rect: TextureRect = $TextureRect

func update():
	if check_zone_open_status():
		$Label.show()
		$TextureRect.show()

func _ready() -> void:
	$Label.hide()
	$TextureRect.hide()
	update()

#АХАХХААХАХАХАХАХАХАХАХАХАХАХХАХАХАХАХАХААХАХААХАХАХ ЫДШМТШл
func check_zone_open_status() -> bool:
	if Global.is_zone_1_open and ID == 1:
		return true
	elif  Global.is_zone_2_open and ID == 2:
		return true
	elif  Global.is_zone_3_open and ID == 3:
		return true
	elif  Global.is_zone_4_open and ID == 4:
		return true
	elif  Global.is_zone_5_open and ID == 5:
		return true
	else:
		return false
