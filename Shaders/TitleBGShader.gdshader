shader_type canvas_item;
render_mode blend_disabled;

uniform sampler2D tex : filter_nearest, repeat_enable;

uniform float scroll_speed = 0.5;
uniform float uv_rotation = -45.;
varying vec2 final_uv;

vec2 rotateUV(vec2 uv, float rotation)
{
    float mid = 0.5;
    return vec2(
        cos(rotation) * (uv.x - mid) + sin(rotation) * (uv.y - mid) + mid,
        cos(rotation) * (uv.y - mid) - sin(rotation) * (uv.x - mid) + mid
    );
}

void vertex() {
	UV *= 0.5;
	UV += TIME * scroll_speed;
	final_uv = rotateUV(UV, radians(uv_rotation));
}

void fragment() {
	COLOR = texture(tex, final_uv);
}
