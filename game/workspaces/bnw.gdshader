shader_type canvas_item;

void fragment() {
    vec4 color = texture(TEXTURE, UV);
    float grayscale = dot(color.rgb, vec3(0.299, 0.587, 0.114));
    COLOR = vec4(grayscale, grayscale, grayscale, color.a);
}