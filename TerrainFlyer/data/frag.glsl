#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform float fraction;

uniform sampler2D texture;

varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 vertLightDir;
varying vec4 vertTexCoord;


void main() {  
  float intensity;
  vec4 color;
  intensity = max(0.0, dot(vertLightDir, vertNormal));

  // if (intensity > pow(0.95, fraction)) {
  //   color = vec4(vec3(1.0), 1.0);
  // } else if (intensity > pow(0.5, fraction)) {
  //   color = vec4(vec3(0.6), 1.0);
  // } else if (intensity > pow(0.25, fraction)) {
  //   color = vec4(vec3(0.4), 1.0);
  // } else {
  //   color = vec4(vec3(0.2), 1.0);
  // }

  gl_FragColor = texture2D(texture, vertTexCoord.st) * vec4(intensity, intensity, intensity, 1) * vertColor;  
}