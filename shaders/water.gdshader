shader_type canvas_item;

uniform sampler2D displacement_map;
uniform float amplitude = 0.003;
uniform float speed = 6.0;
uniform vec2 scaling = vec2(1, 1);

void fragment() {
	vec2 uv = UV * scaling;
	vec2 displacement = texture(displacement_map, uv / 6.0).xy;
	float t = uv.y + displacement.y * 0.1 - 0.15 + (sin (uv.x * 60.0 + TIME * speed) * amplitude);
	COLOR = texture(TEXTURE, vec2(uv.x, t)).rgba;
}

