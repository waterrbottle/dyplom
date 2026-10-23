shader_type canvas_item;


uniform float linewidth = 0.05; 
uniform vec4 linecolor : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 linecolor2 : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float speed: hint_range(0.0, 1.0, 0.01) = 0.1;
uniform float freq: hint_range(0.0, 100.0, 0.1) = 10.0;
uniform float height: hint_range(0.0, 5.0, 0.005) = 0.1;
uniform float lineDensity: hint_range(0.0, 30.0, 0.005) = 20.0;
uniform sampler2D mask : source_color, filter_linear;
void fragment() {
	vec4 tex_color = texture(mask, UV);
	for (int i = 0; i < 100; i++) {
	float modifier = 1.0;
	if(tex_color.r > 0.5){modifier=-1.0;}
	float dist = abs(UV.y - float(i)/lineDensity + sin(UV.x*freq)*height*modifier + 1.0 + fract(TIME * modifier * speed));
    float linemask = 1.0 - smoothstep(linewidth, linewidth + 0.001, dist);

	if(tex_color.r < 0.5){COLOR = mix(COLOR, linecolor , linemask);}
	if(tex_color.r > 0.5){COLOR = mix(COLOR, linecolor2 , linemask);}}
    
}