shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform vec2 offsetStrength = vec2(0.0, 0.0);
uniform sampler2D noiseTexture;
uniform float strength = 5.0;
void fragment() {

    vec2 dynamicOffset =offsetStrength;
	vec2 modifier = UV;
	if (modifier.x>0.5)
		{modifier.x = 1.0 - UV.x;}
	if (modifier.y>0.5)
		{modifier.y = 1.0 - UV.y;}
	float noise_val = (texture(noiseTexture, UV).r * strength) * modifier.y * modifier.x * 1.9;
    
    // 2. Sample the screen, adding the localized offset
    vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV + dynamicOffset + noise_val);
    
    COLOR = color;
}