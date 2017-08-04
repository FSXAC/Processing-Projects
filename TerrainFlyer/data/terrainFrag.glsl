#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform float speed;

varying vec4 v_vertColor;
varying vec3 v_vertNormal;

float map(float x, float in_min, float in_max, float out_min, float out_max) {
	return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}

void main() {
	// gl_FragColor = v_vertColor;
	// gl_FragColor = vec4(0.0, 0.5, 0.2, 1.0);
	float r = abs(dot(v_vertNormal, vec3(1.0, 0.0, 0.0)));
	float g = abs(dot(v_vertNormal, vec3(0.0, 1.0, 0.0)));
	float b = abs(dot(v_vertNormal, vec3(0.0, 0.0, 1.0)));
	vec4 normalColor = vec4(r, g, b, 1.0);

	float k = clamp(map(speed, 50.0, 100.0, 0.0, 1.0), 0.0, 1.0);

	gl_FragColor =  k * normalColor + (1.0 - k) * v_vertColor;
}