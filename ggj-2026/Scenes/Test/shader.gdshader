shader_type canvas_item;

uniform bool hide = false;        // se true → trasparente
uniform vec2 mask_center_uv = vec2(0.5);
uniform float radius = 0.25;
uniform float softness = 0.05;

void fragment() {
    vec4 tex = texture(TEXTURE, UV);

    if (hide) {
        float d = distance(UV, mask_center_uv);
        float mask = smoothstep(radius, radius - softness, d);
        tex.a *= (1.0 - mask);
    }

    COLOR = tex;
}
