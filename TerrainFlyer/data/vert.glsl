uniform mat4 transform;
uniform mat3 normalMatrix;
uniform vec3 lightNormal;
uniform mat4 texMatrix;

attribute vec4 position;
attribute vec4 color;
attribute vec3 normal;
attribute vec2 texCoord;

varying vec4 vertColor;
varying vec4 vertPosition;
varying vec3 vertNormal;
varying vec3 vertLightDir;
varying vec4 vertTexCoord;

void main() {
  gl_Position = transform * position;
  vertPosition = position;
  vertColor = color;
  vertNormal = normalize(normalMatrix * normal);
  // vertLightDir = -lightNormal;
  vertLightDir = vec3(-1, -1, 1);

  vertTexCoord = texMatrix * vec4(texCoord, 1.0, 1.0); 
}       