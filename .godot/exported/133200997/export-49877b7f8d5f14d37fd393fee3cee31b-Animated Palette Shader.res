RSRC                    Shader            ��������                                                  resource_local_to_scene    resource_name    code    script           local://Shader_lq1x3 �          Shader          �  shader_type canvas_item;
global uniform sampler2D base_palette : filter_nearest;
uniform sampler2D current_palette : filter_nearest;
uniform sampler2D blend_palette : filter_nearest;
uniform float alpha_threshold = 0.5;

uniform float blend_amount : hint_range(0.0, 1.0, 0.5) = 0.0;

void fragment() {
	vec3 value = texture(TEXTURE, UV).rgb;
	float alpha = float(texture(TEXTURE, UV).a > alpha_threshold);
	vec2 palette_uv = vec2(0.0, 0.0);
	
	if (texture(TEXTURE, UV).a >= 0.5){
		for(int i = 1; i < 6; i++)
		{
			float sample_x = (float(i) / 6.) + (0.5 / 6.);
			vec2 sample_uv = vec2(sample_x, 0.);
			vec3 sample_value = texture(base_palette, sample_uv).rgb;
			
			if(distance(sample_value, value) <= 0.25)
			{
				palette_uv = sample_uv;
				break;
			}
		}
		
		vec4 final_color = mix(texture(current_palette, palette_uv), texture(blend_palette, palette_uv), blend_amount);
		COLOR = final_color;
		COLOR.a = alpha;
	}
	else{
		discard;
	}
}
       RSRC