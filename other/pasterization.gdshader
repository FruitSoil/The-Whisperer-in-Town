shader_type spatial;
// Исправлено: blend_mix вместо blends_mix
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_lambert, specular_schlick_ggx;

// Группа основных настроек материала
group_uniforms Base_Material;
uniform vec4 albedo_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform sampler2D albedo_texture : source_color, filter_nearest;

// Группа настроек Cel-shading (Сегментация света)
group_uniforms Toon_Lighting;
// Порог перехода в тень (0.0 — ровно половина объекта)
uniform float shadow_threshold : hint_range(-1.0, 1.0) = 0.0;
// Жесткость границы (чем меньше значение, тем резче линия тени)
uniform float shadow_smoothness : hint_range(0.0, 0.5) = 0.02;
// Яркость затененных участков (0.0 — полностью черная тень)
uniform float shadow_darkness : hint_range(0.0, 1.0) = 0.3;

group_uniforms;

void fragment() {
	// Считываем текстуру и базовый цвет
	vec4 tex_color = texture(albedo_texture, UV);
	ALBEDO = albedo_color.rgb * tex_color.rgb;
	
	// Делаем поверхность матовой, чтобы реалистичные блики не ломали 2D стиль
	ROUGHNESS = 1.0;
	SPECULAR = 0.0;
}

// Кастомный расчет освещения для каждого источника света в сцене
void light() {
	// Базовое распределение света по Ламберту
	float dot_product = dot(NORMAL, LIGHT);
	
	// Создаем жесткую границу тени
	float light_intensity = smoothstep(shadow_threshold, shadow_threshold + shadow_smoothness, dot_product);
	
	// Подмешиваем минимальную яркость для темных зон
	light_intensity = mix(shadow_darkness, 1.0, light_intensity);
	
	// Вычисляем финальное влияние источника света с учетом затенения (ATTENUATION)
	vec3 final_light = LIGHT_COLOR * ATTENUATION * light_intensity;
	
	// Применяем результат к объекту
	DIFFUSE_LIGHT += ALBEDO * final_light;
}
