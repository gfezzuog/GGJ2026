shader_type canvas_item;

uniform sampler2D mask_texture;

uniform vec4 highlight_color : source_color = vec4(1.0, 1.0, 0.0, 1.0);
uniform float highlight_strength : hint_range(0.0, 2.0) = 1.0;

uniform float highlight_enabled : hint_range(0.0, 1.0) = 0.0;
uniform float pulse_speed : hint_range(0.0, 10.0) = 3.0;
uniform float dark_threshold : hint_range(0.0, 1.0) = 0.5;

void fragment() {
    vec4 color = texture(TEXTURE, UV);
    float mask = texture(mask_texture, SCREEN_UV).r;

    if (mask < 0.3) {
        discard;
    }

    float luminance = dot(color.rgb, vec3(0.299, 0.587, 0.114));
    float dark_factor = step(luminance, dark_threshold);

    // effetto pulse
    float pulse = 0.6 + 0.4*(sin(TIME * pulse_speed) + 1.0) * 0.5;

    // attivazione
    float effect_strength = highlight_enabled * pulse * highlight_strength * dark_factor;

    vec3 result = color.rgb + highlight_color.rgb * effect_strength;

    COLOR = vec4(result, color.a);
}