extends ColorRect

@export var camera: Camera3D
@export var sensitivity: float = 0.4 
@export var zoom_sensitivity: float = 0.5 # Чувствительность размытия при зуме

var last_position: Vector3 = Vector3.ZERO
var last_rotation: Vector3 = Vector3.ZERO
var last_size: float = 0.0

func _ready() -> void:
	if camera:
		last_position = camera.global_position
		last_rotation = camera.global_rotation
		last_size = camera.size

func _process(delta: float) -> void:
	if not camera or delta <= 0.0:
		return
		
	# 1. Расчет линейной и угловой скоростей
	var pos_velocity = (camera.global_position - last_position) / delta
	var local_pos_vel = camera.global_transform.basis.inverse() * pos_velocity
	var rot_velocity = (camera.global_rotation - last_rotation) / delta
	
	# 2. Вычисляем стандартный вектор сдвига
	var target_blur = Vector2(
		-rot_velocity.y + local_pos_vel.x, 
		rot_velocity.x - local_pos_vel.y
	) * sensitivity
	
	# 3. Расчет скорости зума для ортогональной камеры
	var target_zoom_blur: float = 0.0
	
	if camera.projection == Camera3D.PROJECTION_ORTHOGONAL:
		var cam_size = max(camera.size, 0.001)
		
		# Как быстро меняется размер камеры (size) за секунду
		var zoom_velocity = (camera.size - last_size) / delta
		
		# Сила размытия зависит от скорости изменения размера
		target_zoom_blur = zoom_velocity * zoom_sensitivity
		
		# Корректируем обычный сдвиг под текущий масштаб
		target_blur /= cam_size
	
	# 4. Интерполяция и сглаживание микро-рывков
	var mat = material as ShaderMaterial
	
	var current_blur = mat.get_shader_parameter("blur_dir") as Vector2
	if current_blur == null: current_blur = Vector2.ZERO
	current_blur = current_blur.lerp(target_blur, 15.0 * delta)
	
	var current_zoom_blur = mat.get_shader_parameter("zoom_blur_amount") as float
	if current_zoom_blur == null: current_zoom_blur = 0.0
	current_zoom_blur = lerp(current_zoom_blur, target_zoom_blur, 15.0 * delta)
	
	# 5. Передача параметров в шейдер
	mat.set_shader_parameter("blur_dir", current_blur)
	mat.set_shader_parameter("zoom_blur_amount", current_zoom_blur)
	
	# Обновление истории
	last_position = camera.global_position
	last_rotation = camera.global_rotation
	last_size = camera.size
