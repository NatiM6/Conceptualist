shader_type canvas_item;

uniform bool visible = false;

bool hasContraryNeighbour(vec2 uv, vec2 texture_pixel_size, sampler2D texture) {
	if (!visible) return false;
	
	for (float i = -5.; i <= 5.; i++) {
		float x = abs(i) > 5. ? 5. * sign(i) : i;
		float offset;
		
		offset = floor(sqrt(30.25 - x * x));
		
		for (float j = -ceil(offset); j <= ceil(offset); j++) {
			float y = abs(j) > offset ? offset * sign(j) : j;
			vec2 xy = uv + texture_pixel_size * vec2(x, y);
			
			if (xy == clamp(xy, vec2(0.0), vec2(1.0)) && texture(texture, xy).a > 0.0) {
				return true;
			}
		}
	}
	
	return false;
}

void fragment() {
	vec2 uv = UV;
	
	COLOR = texture(TEXTURE, uv);
	
	if (COLOR.a <= 0.0 && hasContraryNeighbour(uv, TEXTURE_PIXEL_SIZE, TEXTURE)) {
		COLOR = vec4(1.0);
	}
}