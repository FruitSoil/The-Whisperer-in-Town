shader_type spatial;
render_mode unshaded; // Отключаем стандартный свет для ретро-вида

uniform sampler2D albedo_texture : source_color, filter_nearest;
uniform vec2 pixel_resolution = vec2(64.0, 64.0); // Количество "пикселей" на объекте

void fragment() {
    // Округляем UV-координаты модели
    vec2 pixelated_uv = floor(UV * pixel_resolution) / pixel_resolution;
    
    // Читаем текстуру по новым координатам
    vec4 tex_color = texture(albedo_texture, pixelated_uv);
    
    ALBEDO = tex_color.rgb;
    ALPHA = tex_color.a;
}
