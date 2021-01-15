shader_type spatial;
render_mode unshaded;

uniform sampler2D gradient: hint_albedo;
uniform float fog_intensity:  hint_range(0.0, 1.0);
uniform float fog_amount: hint_range(0.0, 1.0);

void vertex() {
	POSITION = vec4(VERTEX,	1.0);
}

void fragment() {
	vec4 original = texture(SCREEN_TEXTURE, SCREEN_UV);
	
	float depth = texture(DEPTH_TEXTURE, SCREEN_UV).x;
	vec3 ndc= vec3(SCREEN_UV, depth) * 2.0 - 1.0;
	vec4 view = INV_PROJECTION_MATRIX* vec4(ndc, 1.0);
	view.xyz /= view.w;
	depth = -view.z;
	
	float fog = depth * fog_amount;
	
	vec4 fog_color = texture(gradient, vec2(fog, 0.0));
	if (depth > 1.0)
		ALBEDO =  mix(original.rgb, fog_color.rgb, fog_color.a * fog_intensity);
	else
		ALBEDO = fog_color.rgb;
}