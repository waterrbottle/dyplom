shader_type canvas_item;

// This allows us to access the pixels behind the object
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform float colors : hint_range(1.0, 16.0) = 8.0;
uniform float dither : hint_range(0.0, 0.5) = 0.1;

void fragment()
{
	// Sample from the screen instead of TEXTURE
	vec4 color = texture(screen_texture, SCREEN_UV);
	
	// We use SCREEN_PIXEL_SIZE for the coordinate math
	float a = floor(mod(FRAGCOORD.x, 2.0));
	float b = floor(mod(FRAGCOORD.y, 2.0));	
	float c = mod(a + b, 2.0);
	
	// Apply the dithering/quantization logic to the screen color
	vec3 out_color;
	
	out_color.r = (round(color.r * colors + dither) / colors) * c;
	out_color.g = (round(color.g * colors + dither) / colors) * c;
	out_color.b = (round(color.b * colors + dither) / colors) * c;
	
	float inv_c = 1.0 - c;
	
	out_color.r += (round(color.r * colors - dither) / colors) * inv_c;
	out_color.g += (round(color.g * colors - dither) / colors) * inv_c;
	out_color.b += (round(color.b * colors - dither) / colors) * inv_c;
	
	COLOR = vec4(out_color, color.a);
}