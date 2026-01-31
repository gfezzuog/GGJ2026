shader_type canvas_item;

const int MAX_RECTS = 8;

uniform vec4 rects[MAX_RECTS]; // xy=center_uv, zw=size_uv
uniform int rect_count = 0;

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    float alpha_mask = 0.0;

    for (int i = 0; i < MAX_RECTS; i++) {
        if (i >= rect_count) {
            break;
        }

        vec2 center = rects[i].xy;
        vec2 size = rects[i].zw * 0.5;
        vec2 delta = UV - center;

        float inside =
            step(-size.x, delta.x) * step(delta.x, size.x) *
            step(-size.y, delta.y) * step(delta.y, size.y);

        alpha_mask = max(alpha_mask, inside);
    }

    tex.a *= (1.0 - alpha_mask);
    COLOR = tex;
}
