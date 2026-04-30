shader_type canvas_item;

const int MAX_RECTS = 21 * 21;

uniform vec4 rects[MAX_RECTS]; // xy = center_uv, zw = size_uv
uniform int rect_count = 0;

float rect_distance(vec2 p, vec2 c, vec2 half_size) {
	vec2 d = abs(p - c) - half_size;
	return length(max(d, vec2(0.0)));
}

void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	float min_dist = 1e20;
	int closest = -1;

	for (int i = 0; i < MAX_RECTS; i++) {
		if (i >= rect_count) break;

		vec2 center = rects[i].xy;
		vec2 half_size = rects[i].zw * 0.5;

		float d = rect_distance(UV, center, half_size);

		if (d < min_dist) {
			min_dist = d;
			closest = i;
		}
	}

	// EPSILON per sicurezza
	float eps = 0.01;

	if (closest != -1 && min_dist <= eps) {
		discard;
	}

	COLOR = tex;
}

