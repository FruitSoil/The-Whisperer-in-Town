extends Area3D 

@export var zone = 1
@export var has_building: bool = false
@export var current_build: Building
@export var has_worker: bool = false
@export var current_worker: Worker
var current_combo: WorkerOnBuilding
var is_charged: bool = false

func _ready() -> void:
	$Charge_sprite/Charge_feedback.pixel_size = 0.0
	$Charge_sprite.hide()
	$Sprite3D.hide()
	$Res_progress.hide()
	if has_building and current_build:
		place(current_build)
	if has_worker and current_worker:
		appoint(current_worker)
	await RenderingServer.frame_post_draw
	$Res_progress.texture = $SubViewport.get_texture()
	await RenderingServer.frame_post_draw
	lines_update()

func toggle_lines(is_show: bool):
	if is_show:
		if $Collision.disabled == false:
			$grid.show()
		else:
			$grid.hide()
	else:
		$grid.hide()

func lines_update():
	var open_color = Color("e1ffe015")
	var close_color =Color("5b000000")
	if check_zone_status():
		$grid/Line.mesh.material.albedo_color = open_color
		$grid/Line2.mesh.material.albedo_color = open_color
		$grid/Line3.mesh.material.albedo_color = open_color
		$grid/Line4.mesh.material.albedo_color = open_color
	else:
		$grid/Line.mesh.material.albedo_color = close_color
		$grid/Line2.mesh.material.albedo_color = close_color
		$grid/Line3.mesh.material.albedo_color = close_color
		$grid/Line4.mesh.material.albedo_color = close_color

func _process(_delta: float) -> void:
	if $Time_to_res.time_left > 0:
		$SubViewport/TextureProgressBar.value = $Time_to_res.wait_time - $Time_to_res.time_left
	else:
		$SubViewport/TextureProgressBar.value = 0
	
	if $Charge_time.time_left > 0:
		$SubViewport2/TextureProgressBar2.value = $Charge_time.wait_time - $Charge_time.time_left
	else:
		$SubViewport2/TextureProgressBar2.value = 0

func _input_event(_camera, event, _click_position, _click_normal, _shape_idx):
	if check_zone_status() and event.is_action_pressed("place"):
		if %BaseUI.building_state and has_building == false:
			place()
			get_tree().call_group("cell","toggle_lines", false)
		elif %BaseUI.worker_state and has_building and has_worker == false and  current_build != load("uid://cm6r5ofrc0a8"):
			appoint()
			$"../../HUD/PortairDrag".hide()
			get_tree().call_group("cell","toggle_lines", false)
		elif %BaseUI.demolition_state and has_building:
			displace()
			get_tree().call_group("cell","toggle_lines", false)
		elif has_building and is_charged:
			click_res()
			if $"../../HUD/PortairDrag".visible:
				%BaseUI.jigle()
		else:
			%BaseUI.jigle()
	elif event.is_action_pressed("displace") and has_building and has_worker:
		disappoint()
		get_tree().call_group("cell","toggle_lines", false)

func place(building: Building = %BaseUI.selected_build):
	%BaseUI.building_state = false
	has_building = true
	current_build = building
	%BaseUI.selected_build = null
	_mouse_exit()
	print(current_build.name, " поставлено на ", name)
	var inst = current_build.model.instantiate()
	
	if current_build != load("uid://cm6r5ofrc0a8"):
		if $"../../Tutorial".tutorial_stage == -1:
			$"../../Tutorial".pressed(-1)
			$"../../Tutorial".stage_change(-2)
		
		Global.total_buildings.append(building) 
		if Global.total_buildings.size() >= 3 and $"../../Tutorial".tutorial_stage == 77:
			$"../../Tutorial".stage_change(8)
		$Charge_time.start()
		$SubViewport2/TextureProgressBar2.max_value = $Charge_time.wait_time
		$Charge_sprite.show()
		$Charge_sprite/MoneyIcon.hide()
		$Sprite3D.visible = true
		$Build_part.emitting = true
		var twap = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		twap.tween_property(inst, "position", Vector3(0,0,0), 0.5).from(Vector3(0,-2,0))
	
	inst.rotation_degrees.y = randi_range(0,3) * 90
	add_child(inst)
	%QuestLogic.check_for_all()

func displace():
	if has_worker:
		if current_worker.is_unique == false:
			Global.add_to_integer_res_type(2, Global.DEFAULT_WORKER_COST)
			%BaseUI.change_label(2, true)
	get_tree().call_group("Work_panels", "change_work_icon", false, current_worker)
	Global.total_buildings.erase(current_build)
	Global.total_workers.erase(current_worker)
	Global.total_work_on_build.erase(current_combo)
	current_combo = null
	current_worker = null
	has_worker = false
	
	if current_build == preload("res://resources/builds_res/Abandoned_District.tres"):
		if $"../../Tutorial".builduing_displaced != 4:
			$"../../Tutorial".builduing_displaced += 1
			get_tree().call_group("ruin_arrow","check", self)
			print("ruin displaced")
		else:
			$"../../Tutorial".stage_change(3)
			
	
	print("Работник убран с клетки ", name, " из-за сноса района")
	$Time_to_res.stop()
	$Charge_sprite.hide()
	$Charge_time.stop()
	$Sprite3D/Portair.texture = null
	
	$Build_part.emitting = true
	%BaseUI.demolition_state = false
	$Res_progress.hide()
	Global.add_to_integer_res_type(current_build.buy_cost_type, current_build.buy_cost)
	%BaseUI.change_label(current_build.buy_cost_type, true)
	has_building = false
	current_build = null
	_mouse_exit()
	print("район ", name," снесён")
	$Sprite3D.visible = false
	var twap = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	twap.tween_property(get_child(-1), "position", Vector3(0,-4,0), 0.5).from(Vector3(0,0,0))
	%QuestLogic.check_for_all()
	await get_tree().create_timer(0.5).timeout
	get_child(-1).queue_free()

func appoint(work: Worker = %BaseUI.selected_worker):
	if $"../../Tutorial".tutorial_stage == 7:
		$"../../Tutorial".pressed(7)
	
	%BaseUI.worker_state = false
	has_worker = true
	current_worker = work
	get_tree().call_group("Work_panels", "change_work_icon", true, current_worker)
	%BaseUI.selected_worker = null
	_mouse_exit()
	print(current_worker.name," назначен на клетку ", name)
	var wait_time = current_build.res_timer + current_worker.res_timer_change
	if wait_time < 0.25:
		wait_time = 0.25
	Global.total_workers.append(current_worker)
	current_combo = WorkerOnBuilding.new()
	current_combo.worker = work
	current_combo.build = current_build
	Global.total_work_on_build.append(current_combo)
	$Time_to_res.wait_time = wait_time
	$Time_to_res.start()
	$SubViewport/TextureProgressBar.max_value = wait_time
	$Res_progress.show()
	$Sprite3D/Portair.texture = current_worker.icon
	if current_worker.is_unique:
		$Sprite3D/Portair.pixel_size = 0.00025
	else:
		$Sprite3D/Portair.pixel_size = 0.0015
	%QuestLogic.check_for_all()

func disappoint():
	Global.total_workers.erase(current_worker)
	Global.total_work_on_build.erase(current_combo)
	current_combo = null
	has_worker = false
	if current_worker.is_unique == false:
		Global.add_to_integer_res_type(2, Global.DEFAULT_WORKER_COST)
		%BaseUI.change_label(2, true)
	get_tree().call_group("Work_panels", "change_work_icon", false, current_worker)
	current_worker = null
	_mouse_exit()
	print("Работник убран с клетки ", name)
	$Time_to_res.stop()
	$Res_progress.hide()
	$Sprite3D/Portair.texture = null
	%QuestLogic.check_for_all()

func _mouse_enter():
	if check_zone_status():
		var mat = $MeshInstance3D.get_active_material(0).duplicate()
		if %BaseUI.building_state == true and %BaseUI.worker_state == false and %BaseUI.demolition_state == false:
			if !has_building:
				change_cell_color(2,mat)
			else:
				change_cell_color(1,mat)
		elif %BaseUI.building_state == false and %BaseUI.worker_state == true and %BaseUI.demolition_state == false:
			if !has_building:
				change_cell_color(1,mat)
			elif current_build != load("uid://cm6r5ofrc0a8"):
				$Sprite3D/corner.visible = true
				change_cell_color(2,mat)
			else:
				change_cell_color(1,mat)
		elif %BaseUI.building_state == false and %BaseUI.worker_state == false and %BaseUI.demolition_state == true:
			if !has_building:
				change_cell_color(1,mat)
			else:
				change_cell_color(3,mat)

func change_cell_color(ID: int, mat):
	match ID:
		1:
			$MeshInstance3D.set_surface_override_material(0, mat)
			var twac = create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
			twac.tween_property(mat, "albedo_color", Color(1.164, 0.0, 0.0, 0.561), 0.5)
		2:
			$MeshInstance3D.set_surface_override_material(0, mat)
			var twac = create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
			twac.tween_property(mat, "albedo_color", Color(0.0, 1.164, 0.339, 0.561), 0.5)
		3:
			$MeshInstance3D.set_surface_override_material(0, mat)
			var twac = create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
			twac.tween_property(mat, "albedo_color", Color(1.164, 1.164, 0.339, 0.561), 0.5)

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
	tws.tween_property($Sprite3D,"pixel_size",0.0065,0.3)
	tws.tween_property($Sprite3D,"pixel_size",0.006,0.3)

func charge_timeout() -> void:
	print(self.name, " зарядился")
	$Charge_sprite/MoneyIcon.show()
	is_charged = true
	var size
	if has_worker:
		size = 0.0025
	else:
		size = 0.002
	var twps = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	twps.tween_property($Charge_sprite/Charge_feedback, "pixel_size", size, 0.6)

func click_res():
	if $"../../Tutorial".tutorial_stage == -2:
			$"../../Tutorial".pressed(-2)
	
	var twps = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	twps.tween_property($Charge_sprite/Charge_feedback, "pixel_size", 0.0, 0.6)
	
	$Charge_part.emitting = true
	is_charged = false
	$Charge_time.wait_time = 15 + randf_range(-5,5)
	$Charge_sprite/MoneyIcon.hide()
	$SubViewport2/TextureProgressBar2.max_value = $Charge_time.wait_time
	$Charge_time.start()
	var rand = randi_range(0,100)
	if rand <= %BaseUI.chance:
		%BaseUI.chance = 0
		Global.add_to_integer_res_type(2, 2)
		%BaseUI.change_label(2,true)
		$Charge_part2.emitting = true
	else: 
		%BaseUI.chance += 4
		Global.add_to_integer_res_type(2, 1)
		%BaseUI.change_label(2,true)
	
	%BaseUI.anim_click()
	var added_number = randi_range(current_build.res_count_per_click.x,current_build.res_count_per_click.y)
	Global.add_to_integer_res_type(current_build.res_type, added_number)
	%BaseUI.change_label(current_build.res_type,true)

func check_zone_status() ->bool:
	if zone == 1 and Global.is_zone_1_open == true:
		return true
	elif zone == 2 and Global.is_zone_2_open == true:
		return true
	elif zone == 3 and Global.is_zone_3_open == true: 
		return true
	elif zone == 4 and Global.is_zone_4_open == true: 
		return true
	elif zone == 5 and Global.is_zone_5_open == true:
		return true
	else:
		return false

func dis(value: bool) -> void:
	if has_meta("do_not_disable_on_tutor") and get_meta("do_not_disable_on_tutor") == true:
		return
	$Collision.disabled = value
