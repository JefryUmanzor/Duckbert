shader_type canvas_item;
uniform sampler2D noise_tex;
uniform vec2 noise_scroll = vec2(0.0, 1.0);
varying float particle_time;

global uniform sampler2D base_palette;
uniform sampler2D current_palette;
uniform bool use_palette = false;

float fwrap(float x, float minimum, float maximum) {
	float val = minimum;
	if (x < 0.){
		val = maximum;
	}
    return val + mod(x, maximum - minimum);
}

void vertex(){
	particle_time = INSTANCE_CUSTOM.y;
}

void fragment() {
	if (use_palette){
		vec3 value = texture(TEXTURE, UV).rgb;
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
			
			COLOR = texture(current_palette, palette_uv);
		}
		else{
			discard;
		}
	}
	
	if (particle_time > 0. && COLOR.a > 0.5){
		vec2 noise_uv = UV + noise_scroll * particle_time;
		noise_uv.y = fwrap(noise_uv.y, 0.0,1.0);
		float noise_read = texture(noise_tex, noise_uv).r;
		noise_read = float(noise_read <= 1. - particle_time);
		
		COLOR.a = noise_read;
	}
}
