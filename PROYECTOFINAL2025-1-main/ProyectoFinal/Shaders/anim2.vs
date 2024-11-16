#version 330 core
layout (location = 0) in vec3 aPos;
layout (location = 1) in vec3 aNormal;
layout (location = 2) in vec2 aTexCoords;

out vec2 TexCoords;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;
uniform float time;

// Parámetros para el movimiento de levitación
const float levitationAmplitude = 2.5;  // Ajusta este valor para controlar la altura de levitación
const float speed = 1.0;  // Velocidad del movimiento

void main()
{
    // Movimiento oscilante en el eje Y para simular levitación
    float moveOffset = levitationAmplitude * sin(time * speed);  // Controla el movimiento suave en el eje Y
    
    // Aplicamos la traslación a la posición del objeto
    vec3 newPos = aPos + vec3(0.0, moveOffset, 0.0);  // Solo movemos en el eje Y
    
    // Calculamos la posición final del vértice con las matrices
    gl_Position = projection * view * model * vec4(newPos, 1.0);
    
    // Pasamos las coordenadas de textura
    TexCoords = aTexCoords;
}