shader_type canvas_item;

uniform vec4 tint_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec2 center = vec2(0.5);
uniform float radius : hint_range(0.0, 1.0, 0.01) = 1.0;
uniform float threshold_multiplier : hint_range(0.0, 2.0, 0.01) = 1.25;


vec2 aspect_ratio(vec2 pixel_size) {
	return pixel_size.x > pixel_size.y ? vec2(pixel_size.y / pixel_size.x, 1.0) : vec2(1.0, pixel_size.x / pixel_size.y);
}


float circle_sdf(vec2 position, vec2 circle_center, vec2 pixel_size) {
	vec2 ratio = aspect_ratio(pixel_size);
	return length((position - circle_center) * 2.0 * ratio);
}


void fragment() {
	float mask = circle_sdf(UV, center, SCREEN_PIXEL_SIZE);
	mask = step(radius * threshold_multiplier, mask);
	COLOR.rgb = tint_color.rgb;
	COLOR.a = mask;
}
