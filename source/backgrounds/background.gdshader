shader_type canvas_item;

uniform vec2 direction;
uniform float speed;
varying vec4 modulate;

void vertex() {
	modulate = COLOR;
}

void fragment() {
	vec2 move = direction * TIME * speed;
	COLOR = texture(TEXTURE, UV+move) * modulate;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
