shader_type canvas_item;

// Общая ссылка на экранную текстуру
uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;

// Группа настроек для пикселизации
group_uniforms Pixelation;
// Размер "пикселя". Чем больше число, тем крупнее пиксели.
uniform float pixel_size : hint_range(1.0, 100.0) = 10.0;

// Группа настроек для постеризации
group_uniforms Posterization;
// Количество градаций цвета
uniform float color_levels : hint_range(2.0, 32.0, 1.0) = 5.0;

// Сброс группы (чтобы последующие переменные, если они будут, не попали в группу Posterization)
group_uniforms;

void fragment() {
	// --- ЭТАП 1: ПИКСЕЛИЗАЦИЯ ---
	// Получаем текущие координаты экрана в пикселях
	vec2 screen_size = vec2(textureSize(screen_texture, 0));
	
	// Вычисляем размер шага сетки пикселизации
	vec2 grid_uv = round(SCREEN_UV * screen_size / pixel_size) * pixel_size / screen_size;
	
	// Читаем цвет из экранной текстуры по новой округленной координате
	vec3 pixelated_color = texture(screen_texture, grid_uv).rgb;
	
	// --- ЭТАП 2: ПОСТЕРИЗАЦИЯ ---
	// Ограничиваем количество цветов уже пикселизированного изображения
	vec3 final_color = floor(pixelated_color * color_levels) / color_levels;
	
	// Выводим итоговый результат
	COLOR = vec4(final_color, 1.0);
}
