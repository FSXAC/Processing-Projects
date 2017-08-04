uniform mat4 transform;

attribute vec4 position;
attribute vec4 color;
attribute vec3 normal;

varying vec4 v_vertColor;
varying vec3 v_vertNormal;

void main() {
	gl_Position = transform * position;

	v_vertColor = color;
	v_vertNormal = normal;
}