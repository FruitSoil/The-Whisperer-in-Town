extends CanvasLayer

@onready var _1_slide: Control = $"Control/1_slide"
@onready var touch_zone_1: TextureRect = $"Control/1_slide/TouchZone"

var tutorial_stage: int

func _ready() -> void:
	stage_change(0)
	touch_zone_1.clicked.connect(element_done.bind(1))

func stage_change(stage: int = tutorial_stage):
	tutorial_stage = stage
	match tutorial_stage:
		0:
			_1_slide.show()
		1:
			pass
		2:
			pass

func element_done(stage: int):
	match stage:
		1:
			_1_slide.hide()
		2:
			pass
