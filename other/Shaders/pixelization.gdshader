shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;

group_uniforms Pixelation;
uniform float pixel_size : hint_range(1.0, 100.0) = 10.0;

group_uniforms Posterization;
uniform float color_levels : hint_range(2.0, 32.0, 1.0) = 5.0;

group_uniforms Motion_Blur;
uniform vec2 blur_dir = vec2(0.0, 0.0);
uniform float zoom_blur_amount = 0.0;
uniform int blur_iterations : hint_range(4, 32) = 8;
uniform float blur_intensity : hint_range(0.0, 5.0) = 1.0;

group_uniforms;

void fragment() {
	vec2 screen_size = vec2(textureSize(screen_texture, 0));
	
	// --- ЭТАП 1: ОКРУГЛЕНИЕ СЕТКИ ЭКРАНА ---
	// Базовая пиксельная координата
	vec2 grid_uv = floor(SCREEN_UV * screen_size / pixel_size) * pixel_size / screen_size;
	// Смещение к центру "большого пикселя", чтобы выборка была стабильной
	grid_uv += (pixel_size / screen_size) * 0.5;
	
	// --- ЭТАП 2: РАСЧЕТ НАПРАВЛЕНИЙ (БЕЗ РЯБИ) ---
	// Переводим силу размытия в масштаб пикселей
	vec2 step_dir = (blur_dir * blur_intensity) * SCREEN_PIXEL_SIZE;
	
	// Вектор зума относительно центра экрана
	vec2 center_vector = grid_uv - vec2(0.5);
	vec2 zoom_dir = center_vector * (zoom_blur_amount * blur_intensity * 0.1);
	
	// --- ЭТАП 3: СБОР ЦВЕТА (ПЛАВНЫЙ СЭМПЛИНГ БЕЗ ROUND ВНУТРИ ЦИКЛА) ---
	vec3 blurred_color = vec3(0.0);
	float iterations_f = float(blur_iterations);
	
	for (int i = 0; i < blur_iterations; i++) {
		float offset_factor = (float(i) / (iterations_f - 1.0)) - 0.5;
		
		// Сдвигаем UV плавно. Никаких round() здесь! 
		// Так как мы начали из центра пикселя (grid_uv), смещение будет мягким.
		vec2 sample_uv = grid_uv + (step_dir * offset_factor) + (zoom_dir * offset_factor);
		
		// Мягко удерживаем в границах экрана
		sample_uv = clamp(sample_uv, vec2(0.001), vec2(0.999));
		
		blurred_color += texture(screen_texture, sample_uv).rgb;
	}
	blurred_color /= iterations_f;
	
	// --- ЭТАП 4: ПОСТЕРИЗАЦИЯ ---
	vec3 final_color = floor(blurred_color * color_levels) / color_levels;
	
	COLOR = vec4(final_color, 1.0);
}
