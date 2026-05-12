shader_type canvas_item;

instance uniform vec4 color : source_color;
instance uniform float progress : hint_range(0.0, 1.0, 0.001);
instance uniform int type = 0;
uniform sampler2D noise;

const mat2 tear_matrix = mat2(vec2(1.0, 0.4), vec2(1.2, 1.0));
const mat2 burn_matrix = mat2(vec2(0.1, 0.0), vec2(0.0, 1.0));
const vec2 res = vec2(16.0, 9.0);

void fragment() {
	COLOR = color;
	if(type == 7) { // tear
		COLOR.a = clamp(texture(noise, 0.3 * tear_matrix * (UV + vec2(1, -1) * 0.1 * progress - vec2(0.5)) + vec2(0.5)).r - 1.0 + 2.0 * progress, 0.0, 1.0);
	} else if(type == 8) { // burn
		vec2 scaled_uv = (UV - vec2(0.5)) * res / res.x;
		float radius = length(scaled_uv);
		float angle = atan(scaled_uv.y, scaled_uv.x) / PI * 0.5 + 0.5;
		vec2 polar_uv = vec2(radius, angle);
		float fake_angle = texture(noise, vec2(angle, progress * 0.03) * 1.0).r;
		polar_uv = vec2(radius, fake_angle * 0.1);
		
		float t = progress;
		float mask = smoothstep(0.0, -0.03, radius + mix(texture(noise, burn_matrix * polar_uv * 0.2).r, texture(noise, UV * 0.6).r, mix(0.2, 0.2, t)) * mix(0.9, 0.4, t * t) * t - t * 0.8);
		COLOR.a = mask;

	} else {
		COLOR.a = progress;
	}
}

  