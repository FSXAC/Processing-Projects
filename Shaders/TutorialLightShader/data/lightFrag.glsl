#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;

varying vec4 vertColor;
varying vec3 ecNormal;
varying vec3 lightDir;
varying vec4 vertTexCoord;

void main() {
    vec3 direction = normalize(lightDir);
    vec3 normal = normalize(ecNormal);
    float intensity = max(0.0, dot(direction, normal));
    gl_FragColor = texture2D(texture, vertTexCoord.st) * vertColor * vec4(vec3(intensity), 1);
    // gl_FragColor = vertColor;
};