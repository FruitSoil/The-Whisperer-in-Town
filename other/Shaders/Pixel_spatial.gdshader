shader_type spatial;
render_mode unshaded; 

uniform sampler2D albedo_texture : source_color, filter_nearest;
uniform vec2 pixel_resolution = vec2(64.0, 64.0); 

void fragment() {
    vec2 pixelated_uv = floor(UV * pixel_resolution) / pixel_resolution;

    vec4 tex_color = texture(albedo_texture, pixelated_uv);
    
    ALBEDO = tex_color.rgb;
    ALPHA = tex_color.a;
}
