shader_type canvas_item;
uniform float colorreduceR = 2.0f;
uniform float colorreduceG = 2.0f;
uniform float colorreduceB = 2.0f;
uniform float colorStrength = 1.0f;
void vertex() {

	// VERTEX.x += (1.0 - UV.y) * abs(sin(TIME)) * 1000.0;
	// Called for every vertex the material is visible on.
}

void fragment() {
	//COLOR /= 1.0;
	COLOR.r = floor(COLOR.r * colorreduceR)/colorreduceR;
	COLOR.g = floor(COLOR.g * colorreduceG)/colorreduceG;
	COLOR.b = floor(COLOR.b * colorreduceB)/colorreduceB;
	COLOR *= colorStrength;
	COLOR.a = 1.0;
	//COLOR *= 1.0;
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
