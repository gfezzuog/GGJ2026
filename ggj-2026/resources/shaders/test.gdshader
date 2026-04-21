shader_type canvas_item;

uniform sampler2D mask;
uniform vec2 texture_size;
uniform float thickness = 1.0;
uniform vec4 output_color: source_color;

void fragment() {
    vec2 pixel = 1.0 / texture_size;

    float center = texture(mask, UV).r;

    float right  = texture(mask, UV + vec2(pixel.x * thickness, 0.0)).r;
    float left   = texture(mask, UV - vec2(pixel.x * thickness, 0.0)).r;
    float up     = texture(mask, UV + vec2(0.0, pixel.y * thickness)).r;
    float down   = texture(mask, UV - vec2(0.0, pixel.y * thickness)).r;

    float edge = abs(center - right) +
                 abs(center - left) +
                 abs(center - up) +
                 abs(center - down);

    edge = clamp(edge, 0.0, 1.0);

    COLOR = vec4(output_color.rgb, edge);
}