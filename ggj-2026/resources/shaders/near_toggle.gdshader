shader_type canvas_item;

uniform sampler2D voronoi_id_texture;
uniform int active_mask[22 * 22]; // 1 = attivo, 0 = spento

void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	int id = int(texture(voronoi_id_texture, UV).r + 0.5);

	if (active_mask[id] == 1) {
		discard;
	}

	COLOR = tex;
}
