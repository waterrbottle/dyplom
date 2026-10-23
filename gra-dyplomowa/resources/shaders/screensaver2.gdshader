shader_type canvas_item;

uniform sampler2D animationtexture : source_color, filter_nearest;
uniform sampler2D stamptexture : source_color, filter_nearest;
uniform vec2 grid_size = vec2(100.0, 100.0); 
uniform float speed = 5.0;
uniform float range = 0.2;
void fragment() {
    vec2 cell = floor(UV * grid_size); // UV pojedynczego cella w teksturze
    vec2 cell_uv = fract(UV * grid_size); // UV wenetrxne jakby w cellach od 0 do 1
    vec2 anim_uv = cell / grid_size; // to jest uv gridow, gdyby nie on anim uv ne snapowaly sie do gridow
    vec4 anim = texture(animationtexture, anim_uv); // tekstura animacj z uv ze snapowaniem do grida
	
	float timer = fract(TIME / speed) * (1.0+range); // timer ktory co SPEED idzie od 0 do 1 * 1.2 zeby do konca sie ladnie loopowalo
    if (anim.r > timer - range) {
		if (anim.r < timer) {

        	vec4 flower = texture(stamptexture, cell_uv);
			COLOR = flower;}
    } else {
        COLOR = COLOR;
    }
}