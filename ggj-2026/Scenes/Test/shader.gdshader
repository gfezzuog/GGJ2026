shader_type canvas_item;

uniform vec2 mask_center_uv = vec2(0.5);
uniform vec2 mask_size_uv = vec2(0.2, 0.2); // sostituisce il cerchio, ora rettangolo
uniform bool hide = false;

void fragment() {
    vec4 tex = texture(TEXTURE, UV);

    if (hide) {
        // Calcolo rettangolo: UV compreso tra min e max
        vec2 delta = UV - mask_center_uv;
        vec2 half_size = mask_size_uv * 0.5;

        // mask = 1 dentro il rettangolo, 0 fuori
        float mask_x = step(-half_size.x, delta.x) * step(delta.x, half_size.x);
        float mask_y = step(-half_size.y, delta.y) * step(delta.y, half_size.y);
        float mask = mask_x * mask_y;

        tex.a *= (1.0 - mask);
    }

    COLOR = tex;
}
