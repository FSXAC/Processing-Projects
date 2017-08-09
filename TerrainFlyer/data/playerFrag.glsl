#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

// uniform float fraction;

uniform sampler2D texture;

varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 vertLightDir;
varying vec4 vertTexCoord;

const vec3 diffuseColor = vec3(0.5);
const vec3 specColor = vec3(1.0);

void main() {  
    // Simple light shader
    // float intensity;
    // vec4 color;
    // intensity = max(0.0, dot(vertLightDir, vertNormal));
    vec3 normal = normalize(vertNormal);
    vec3 lightDir = normalize(vertLightDir);

    float lambertian = max(dot(lightDir, normal), 0.0);
    float specular = 0.0;

    if (lambertian > 0.0) {
        vec3 reflectDir = reflect(-lightDir, normal);
        vec3 viewDir = normalize(vec3(0.0, 0.2, 1.0));

        float specAngle = max(dot(reflectDir, viewDir), 0.0);
        specular = pow(specAngle, 4.0);
    }

    // vec4 fragColor = vec4(lambertian * diffuseColor + specular * specColor, 1.0);
    vec4 fragColor = vec4(vec3(dot(vertNormal, vec3(0.0, 1.0, 0.0))), 1.0);

    gl_FragColor = texture2D(texture, vertTexCoord.st);
    // gl_FragColor = texture2D(texture, vertTexCoord.st) * fragColor * vertColor;  
}