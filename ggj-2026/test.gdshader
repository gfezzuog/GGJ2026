shader_type canvas_item;

uniform vec2 rect_center = vec2(0.5, 0.5);
uniform vec2 rect_half_size = vec2(0.4, 0.4);
uniform float corner_radius = 0.1;
uniform vec2 edge_softness = vec2(0.01, 0.01);
uniform vec4 modulate_color : source_color = vec4(1.0);
uniform vec4 border_color : source_color = vec4(0.0);
uniform float border_size = 0.1;
uniform float border_padding = 0.1;

uniform float direction = 1.0;
uniform float frequency = 1.0;
uniform float speed = 1.0;

vec2 create_rounded_border(vec2 sample_pos)
{
	vec2 fill_half_size = rect_half_size - vec2(border_padding) - vec2(border_size);
	vec2 d2 = abs(rect_center - sample_pos) - fill_half_size + vec2(corner_radius);
	float dist = length(max(d2, vec2(0.0))) - corner_radius;
	
	float inner_border_mask = smoothstep(-edge_softness.x, 0.0, dist);
	float fill_mask = 1.0 - inner_border_mask;
	float border_dist = dist - border_size + border_padding;
	float outer_fill_mask = 1.0 - smoothstep(0.0, edge_softness.x, border_dist);
	
	float border_mask = inner_border_mask * outer_fill_mask;
	
	return vec2(fill_mask, border_mask);
}

void fragment()
{
	
	vec2 masks = create_rounded_border(UV);
	
	float fill_mask = masks[0];
	float border_mask = masks[1];
	
	vec2 pos = UV - rect_center;  // o (0.5,0.5) se sprite full rect
	float angle = atan(pos.y, pos.x);
	float wave = 0.5 * sin(direction * frequency * angle + TIME * speed) + 0.5;

	// pattern ondulato (cerchio “dotted”)
	float circle_pattern = step(0.5, wave);

	// applico il pattern solo dove c’è il bordo statico
	float final_border = border_mask * circle_pattern;

	// RGB
	vec4 circle_outline = vec4(border_color.rgb, final_border * border_color.a);
	
	vec4 tex = texture(TEXTURE, UV);
	
	vec4 fillColor = tex * modulate_color;
	fillColor.a *= fill_mask;

	vec4 borderColor = border_color;
	borderColor.a *= final_border;

	vec4 fill_pre_multiplied = vec4(fillColor.rgb * (fillColor.a * fill_mask), fillColor.a * fill_mask);
	vec4 border_pre_multiplied = vec4(borderColor.rgb * (borderColor.a * final_border), borderColor.a * final_border);

	vec4 outColor;
	outColor.rgb = border_pre_multiplied.rgb + fill_pre_multiplied.rgb * (1.0 - border_pre_multiplied.a);

	outColor.a = border_pre_multiplied.a + fill_pre_multiplied.a * (1.0 - border_pre_multiplied.a);

	COLOR = outColor;
}