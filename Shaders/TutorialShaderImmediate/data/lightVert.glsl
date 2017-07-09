uniform mat4 modelview;
uniform mat4 transform;
uniform mat4 texMatrix;
uniform mat3 normalMatrix;

uniform vec4 lightPosition;

attribute vec4 position;
attribute vec4 color;
attribute vec3 normal;
attribute vec2 texCoord; // UV

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main() {
    gl_Position = transform * position;
    vec3 ecPosition = vec3(modelview * position);
    vec3 ecNormal = normalize(normalMatrix * normal);

    vec3 direction = normalize(lightPosition.xyz - ecPosition);
    float intensity = max(0.0, dot(direction, ecNormal));
    
    vertColor = vec4(vec3(intensity), 1) * color;
    vertTexCoord = texMatrix * vec4(texCoord, 1.0, 1.0);
}