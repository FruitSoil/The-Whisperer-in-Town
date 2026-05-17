// made by kanaverum on godotshaders.com/shader/basic-background-blur-4-3/ , thank you!
shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform float blur = 2.0;

void fragment() {
	COLOR = texture(screen_texture, SCREEN_UV, blur);
}
