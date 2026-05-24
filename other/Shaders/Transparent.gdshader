shader_type canvas_item;
render_mode blend_sub; // Этот режим вычитает цвет кнопки из фона

void fragment() {
    // Получаем стандартную текстуру кнопки (её цвет и альфа-канал)
    vec4 tex_color = texture(TEXTURE, UV);
    
    // Делаем так, чтобы вырезалась строго по форме иконки/текста кнопки
    COLOR = vec4(tex_color.rgb * tex_color.a, tex_color.a);
}
