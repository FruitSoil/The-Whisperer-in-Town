extends Node2D

const GAMEPLAY = preload("uid://c2hucdshe8xtu")
const MAIN_MENU = preload("uid://cg5c1mvtux802")

@onready var continue_: TextureButton = $Menu/Continue
@onready var start: TextureButton = $Menu/Start
@onready var settings: TextureButton = $Menu/Settings
@onready var exit_to_main: Button = $Menu/Exit

func _ready() -> void:
	$Fade.show()
	continue_.pressed.connect(pressed.bind(0))
	settings.pressed.connect(pressed.bind(2))
	exit_to_main.pressed.connect(pressed.bind(3))
	start.pressed.connect(pressed.bind(1))
	
	continue_.mouse_entered.connect(sounds.bind(1))
	start.mouse_entered.connect(sounds.bind(1))
	settings.mouse_entered.connect(sounds.bind(1))
	
	exit_to_main.mouse_entered.connect(sounds.bind(2))
	
	await get_tree().create_timer(1).timeout
	$Fade/Fade.play("Fade_in")

func pressed(ID: int ):
	match ID:
		1:
			$Fade/Fade.play("Fade_out")
		2:
			pass
		3:
			get_tree().quit()

func _on_fade_anim(anim_name: StringName) -> void:
	if anim_name == "Fade_out":
		get_tree().change_scene_to_packed(GAMEPLAY)

func sounds(value: int):
	match value:
		1:
			$Button_hovered.play()
		2:
			$PC_hovered.play()
