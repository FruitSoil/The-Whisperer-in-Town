extends Area3D 

@export var zone = 1
var has_building: bool = false
var current_build: Building
var has_worker: bool = false
var current_worker: Worker

func _ready() -> void:
	$Sprite3D.hide()

func _input_event(camera, event, click_position, click_normal, shape_idx):
	if check_zone_status() and event.is_action_pressed("place"):
		if %BaseUI.building_state and has_building == false:
			place()
		elif %BaseUI.worker_state and has_building and has_worker == false:
			appoint()
		elif has_building:
			click_res()
	elif event.is_action_pressed("displace") and has_building and has_worker:
		disappoint()

func place():
	$Build_part.emitting = true
	%BaseUI.building_state = false
	has_building = true
	current_build = %BaseUI.selected_build
	%BaseUI.selected_build = null
	_mouse_exit()
	print(current_build.name, " поставлено на ", name)
	$Sprite3D.visible = true
	var inst = current_build.model.instantiate()
	var rot = randi_range(0,3)
	match rot:
		0:
			inst.rotation_degrees.y = 0
		1:
			inst.rotation_degrees.y = 90
		2:
			inst.rotation_degrees.y = 180
		3:
			inst.rotation_degrees.y = 270
	add_child(inst)

func appoint():
	%BaseUI.worker_state = false
	has_worker = true
	current_worker = %BaseUI.selected_worker
	get_tree().call_group("Work_panels", "change_work_icon", true, current_worker)
	%BaseUI.selected_worker = null
	_mouse_exit()
	print(current_worker.name," назначен на клетку ", name)
	var wait_time = current_build.res_timer + current_worker.res_timer_change
	if wait_time < 0.5:
		wait_time = 0.5
	$Time_to_res.wait_time = wait_time
	$Time_to_res.start()
	$Sprite3D/Portair.texture = current_worker.icon

func disappoint():
	has_worker = false
	if current_worker.is_unique == false:
		Global.add_to_integer_res_type(2, 10)
		%BaseUI.change_label(2, true)
	get_tree().call_group("Work_panels", "change_work_icon", false, current_worker)
	current_worker = null
	_mouse_exit()
	print("Работник убран с клетки ", name)
	$Time_to_res.stop()
	$Sprite3D/Portair.texture = null
	

func _mouse_enter():
	if check_zone_status():
		var mat = $MeshInstance3D.get_active_material(0).duplicate()
		if %BaseUI.building_state == true and %BaseUI.worker_state == false:
			if !has_building:
				$MeshInstance3D.set_surface_override_material(0, mat)
				var twac = create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
				twac.tween_property(mat, "albedo_color", Color(0.0, 1.164, 0.339, 0.561), 0.5)
			else:
				$MeshInstance3D.set_surface_override_material(0, mat)
				var twac = create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
				twac.tween_property(mat, "albedo_color", Color(1.164, 0.0, 0.0, 0.561), 0.5)
		elif %BaseUI.building_state == false and %BaseUI.worker_state == true:
			if !has_building:
				$MeshInstance3D.set_surface_override_material(0, mat)
				var twac = create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
				twac.tween_property(mat, "albedo_color", Color(1.164, 0.0, 0.0, 0.561), 0.5)
			else:
				$Sprite3D/corner.visible = true
				$MeshInstance3D.set_surface_override_material(0, mat)
				var twac = create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
				twac.tween_property(mat, "albedo_color", Color(0.0, 1.164, 0.339, 0.561), 0.5)

func _mouse_exit():
	var mat = $MeshInstance3D.get_active_material(0).duplicate()
	if mat:
		$Sprite3D/corner.visible = false
		var twac = create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN)
		twac.tween_property(mat, "albedo_color", Color(0.0, 0.0, 0.0, 0.0), 0.15)
		$MeshInstance3D.set_surface_override_material(0, mat)

func _on_time_to_res_timeout() -> void:
	Global.add_to_integer_res_type(current_build.res_type, current_build.res_count_per_timer)
	if current_build.second_res_count_per_timer != 0:
		Global.add_to_integer_res_type(current_build.second_res_type, current_build.second_res_count_per_timer)
		%BaseUI.change_label(current_build.second_res_type,true)
	if current_worker.addit_res_count != 0:
		if current_build.res_type == current_worker.addit_res_type:
			Global.add_to_integer_res_type(current_worker.addit_res_type, current_worker.addit_res_count)
	if current_worker.new_res_count != 0:
		Global.add_to_integer_res_type(current_worker.new_res_type, current_worker.new_res_count)
		%BaseUI.change_label(current_worker.new_res_type,true)
	%BaseUI.change_label(current_build.res_type,true)
	var tws = create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	tws.tween_property($Sprite3D,"pixel_size",0.011,0.3)
	tws.tween_property($Sprite3D,"pixel_size",0.01,0.3)

func click_res():
	var rand = randi_range(0,100)
	if rand <= %BaseUI.chance:
		%BaseUI.chance = 0
		Global.add_to_integer_res_type(2, randi_range(1,2))
		%BaseUI.change_label(2,true)
	else: 
		%BaseUI.chance += 5
	
	%BaseUI.anim_click(get_viewport().get_mouse_position())
	var added_number = randi_range(current_build.res_count_per_click.x,current_build.res_count_per_click.y)
	Global.add_to_integer_res_type(current_build.res_type, added_number)
	%BaseUI.change_label(current_build.res_type,true)

func check_zone_status() ->bool:
	if zone == 1 and Global.is_zone_1_open or zone == 2 and Global.is_zone_2_open or zone == 3 and Global.is_zone_3_open: 
		return true
	else:
		return false
