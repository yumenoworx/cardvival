shader_type canvas_item;
render_mode unshaded;

uniform int blurSize : hint_range(0,20);
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment()
{
COLOR = textureLod(SCREEN_TEXTURE, SCREEN_UV, float(blurSize)/10.0);
}