#version 330 core
layout (location = 0) in vec3 aPos;
layout (location = 1) in vec3 aNormal;
layout (location = 2) in vec2 aTexCoords;

out vec2 TexCoords;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;
uniform float time;

// Par�metros para el movimiento
const float levitationAmplitude = 1.0;
const float levitationSpeed = 0.5;
const float tiltAngle = radians(30.0);  // �ngulo de inclinaci�n en radianes
const float tiltDuration = 0.7;  // Duraci�n de cada inclinaci�n

// Funci�n para crear una matriz de rotaci�n en el eje Z
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

    // Calculamos la inclinaci�n bas�ndonos en el tiempo
    mat4 tilt = mat4(1.0);
    float cycleTime = mod(time, 4.0 * tiltDuration);

    if (cycleTime < tiltDuration) {
        // Primera inclinaci�n hacia la izquierda
        tilt = rotateZ(tiltAngle * (cycleTime / tiltDuration));
    }
    else if (cycleTime < 2.0 * tiltDuration) {
        // Segunda inclinaci�n hacia la derecha
        tilt = rotateZ(-tiltAngle * ((cycleTime - tiltDuration) / tiltDuration));
    }
    else if (cycleTime < 3.0 * tiltDuration) {
        // Regreso a la posici�n normal desde la inclinaci�n derecha
        tilt = rotateZ(tiltAngle * ((cycleTime - 2.0 * tiltDuration) / tiltDuration));
    }

    // Aplicamos traslaci�n en Y y la inclinaci�n calculada
    vec3 newPos = vec3(aPos.x, aPos.y + moveOffset, aPos.z);
    vec4 finalPos = tilt * vec4(newPos, 1.0);

    // Transformamos la posici�n final con las matrices de modelado, vista y proyecci�n
    gl_Position = projection * view * model * finalPos;

    // Pasamos las coordenadas de textura
    TexCoords = aTexCoords;
}