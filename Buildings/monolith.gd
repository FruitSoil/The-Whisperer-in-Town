extends Node3D

func _ready() -> void:
	play()

func play():
	if $AnimationPlayer.is_playing() == false:
		$AnimationPlayer.play("Plane_012|Action")

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	await get_tree().create_timer(6).timeout
	play()
