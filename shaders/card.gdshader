shader_type canvas_item;

uniform float width = 64;
uniform float height = 64;
uniform vec2 mouse_position = vec2(0, 0);

void fragment() {
	vec2 uv = UV;

	// map skew to [-0.5, 0.5]
	float skew_x = mouse_position.x / width;
	float skew_y = mouse_position.y / height;
	
	// map to [-0.5, 0.5]
	uv.x = (uv.x - 0.5);
	uv.y = (uv.y - 0.5);
	
	// ratio - how far are currnet point from mouse position
	float sx = 1.0 - (uv.x * skew_x);
	float sy = 1.0 - (uv.y * skew_y);
	
	// calculate z (depth) depending on ratio
	float z = 1.0 + (sx * sy) / 2.0;
	// correct perspective for given point
	uv.x = uv.x / z;
	uv.y = uv.y / z;
	
	// scale a bit down a reset mapping from [-0.5, 0.5] to [0, 1]
	uv.x = uv.x / 0.45 + 0.5;
	uv.y = uv.y / 0.45 + 0.5;
	COLOR = texture(TEXTURE, uv);
	
	// if uv outside texture - then use transparent color
	if (uv.x < 0.0 || uv.x > 1.0) {
		COLOR.a = 0.0;
	} else if (uv.y < 0.0 || uv.y > 1.0) {
		COLOR.a = 0.0;
	} else {
		// brightness
		float brightness = 1.0 - mouse_position.y / (height / 2.0) * 0.2;
		COLOR.rgb = texture(TEXTURE, uv, 1.0).rgb * brightness;
		
		COLOR.a = texture(TEXTURE, uv, 1.0).a;
	}
}