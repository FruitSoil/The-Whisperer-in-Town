shader_type canvas_item;

// Ссылка на то, что сейчас рендерится на экране
uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;
// Количество градаций цвета
uniform float color_levels : hint_range(2.0, 32.0, 1.0) = 5.0;

void fragment() {
    // Получаем цвет текущего пикселя экрана
    vec3 screen_color = texture(screen_texture, SCREEN_UV).rgb;
    
    // Ограничиваем количество цветов
    vec3 posterized = floor(screen_color * color_levels) / color_levels;
    
    COLOR = vec4(posterized, 1.0);
}
