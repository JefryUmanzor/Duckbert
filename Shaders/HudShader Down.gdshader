shader_type canvas_item;
uniform float base_alpha = 0.5;
uniform vec3 albedo : source_color = vec3(1.);
varying float uv_percent;

void fragment() {
	uv_percent = UV.y * UV.y;
	uv_percent = (uv_percent * -1.) + 1.;
	
	float cur_alpha = COLOR.a;
	float new_alpha = cur_alpha * base_alpha * uv_percent;
	
	COLOR = vec4(albedo.r, albedo.g, albedo.b, new_alpha);
}