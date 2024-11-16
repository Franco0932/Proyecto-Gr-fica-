#version 330 core
layout (location = 0) in vec3 aPos;
layout (location = 1) in vec3 aNormal;
layout (location = 2) in vec2 aTexCoords;

out vec2 TexCoords;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;
uniform float time;

// Parámetros para el movimiento
const float levitationAmplitude = 1.0;
const float levitationSpeed = 0.5;
const float tiltAngle = radians(30.0);  // Ángulo de inclinación en radianes
const float tiltDuration = 0.7;  // Duración de cada inclinación

// Función para crear una matriz de rotación en el eje Z
mat4 rotateZ(float angle) {
    float cosA = cos(angle);
    float sinA = sin(angle);
    return mat4(
        cosA, -sinA, 0.0, 0.0,
        sinA,  cosA, 0.0, 0.0,
        0.0,   0.0,  1.0, 0.0,
        0.0,   0.0,  0.0, 1.0
    );
}

void main()
{
    // Movimiento oscilante en el eje Y
    float moveOffset = levitationAmplitude * sin(time * levitationSpeed);

    // Calculamos la inclinación basándonos en el tiempo
    mat4 tilt = mat4(1.0);
    float cycleTime = mod(time, 4.0 * tiltDuration);

    if (cycleTime < tiltDuration) {
        // Primera inclinación hacia la izquierda
        tilt = rotateZ(tiltAngle * (cycleTime / tiltDuration));
    }
    else if (cycleTime < 2.0 * tiltDuration) {
        // Segunda inclinación hacia la derecha
        tilt = rotateZ(-tiltAngle * ((cycleTime - tiltDuration) / tiltDuration));
    }
    else if (cycleTime < 3.0 * tiltDuration) {
        // Regreso a la posición normal desde la inclinación derecha
        tilt = rotateZ(tiltAngle * ((cycleTime - 2.0 * tiltDuration) / tiltDuration));
    }

    // Aplicamos traslación en Y y la inclinación calculada
    vec3 newPos = vec3(aPos.x, aPos.y + moveOffset, aPos.z);
    vec4 finalPos = tilt * vec4(newPos, 1.0);

    // Transformamos la posición final con las matrices de modelado, vista y proyección
    gl_Position = projection * view * model * finalPos;

    // Pasamos las coordenadas de textura
    TexCoords = aTexCoords;
}