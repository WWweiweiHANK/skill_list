shader_type canvas_item;


uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform vec2 resolution = vec2(640.0, 360.0);
uniform float warp_amount : hint_range(0.0, 1.0) = 0.05;
uniform float scan_line_amount : hint_range(0.0, 1.0) = 0.3;


void fragment() {
	vec2 uv = SCREEN_UV;
	vec2 delta = uv - 0.5;
	float warp_factor = dot(delta, delta) * warp_amount;
	uv += delta * warp_factor;

	float scanline_mask = step(0.5, sin(SCREEN_UV.y * resolution.y * PI) * 0.5 + 0.5);
	float scanline = mix(1.0, scanline_mask, scan_line_amount * 0.5);
	vec3 color = texture(screen_texture, uv).rgb * scanline;

	if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
		color = vec3(0.0);
	}

	COLOR.rgb = color;
	COLOR.a = 1.0;
}
