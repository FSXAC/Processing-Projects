#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D smoke;

varying vec4 vertColor;
varying vec2 texCoord;

void main() {
    gl_FragColor = texture2D(smoke, texCoord) * vertColor;
}