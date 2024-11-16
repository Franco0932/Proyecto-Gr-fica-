#version 330 core
layout (location = 0) in vec3 aPos;
layout (location = 1) in vec3 aNormal;
layout (location = 2) in vec2 aTexCoords;

out vec2 TexCoords;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;
uniform float time;

// Parámetros de animación
const float liftHeight = 10.0;           // Altura máxima de elevación
const float circleRadius = 2.0;         // Radio del círculo para la trayectoria
const float rotationSpeed = radians(360.0); // Velocidad de rotación para completar una vuelta
const float cycleDuration = 7.0;        // Duración de todo el ciclo (en segundos)

// Función para calcular la rotación en el eje Y del objeto
mat4 rotateY(float angle) {
    float cosA = cos(angle);
    float sinA = sin(angle);
    return mat4(
        cosA, 0.0, sinA, 0.0,
        0.0,  1.0, 0.0, 0.0,
       -sinA, 0.0, cosA, 0.0,
        0.0,  0.0, 0.0, 1.0
    );
}

void main()
{
    // Tiempo modulado para hacer que la animación se repita
    float cycleTime = mod(time, cycleDuration);

    // Calcular la elevación en Y usando una función seno para subir y bajar suavemente
    float liftOffset = liftHeight * abs(sin(cycleTime * (3.14159 / cycleDuration)));

    // Calcular el ángulo de rotación para la trayectoria circular y la orientación del batarang
    float angle = rotationSpeed * (cycleTime / cycleDuration); // Ángulo para la trayectoria en círculo

    // Posición circular en el plano XY
    float circleX = circleRadius * cos(angle);
    float circleZ = circleRadius * sin(angle);

    // Combinamos la posición inicial, la trayectoria circular y el desplazamiento en Y
    vec3 newPos = aPos + vec3(circleX, liftOffset, circleZ);

    // Aplicamos la rotación del batarang sobre su propio eje Y mientras da la vuelta
    vec4 finalPos = rotateY(angle) * vec4(newPos, 1.0);

    // Transformación final
    gl_Position = projection * view * model * finalPos;

    // Pasamos las coordenadas de textura
    TexCoords = aTexCoords;
}