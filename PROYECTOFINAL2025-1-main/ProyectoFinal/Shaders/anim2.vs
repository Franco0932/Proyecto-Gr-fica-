#version 330 core
layout (location = 0) in vec3 aPos;
layout (location = 1) in vec3 aNormal;
layout (location = 2) in vec2 aTexCoords;

out vec2 TexCoords;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;
uniform float time;

// Par�metros para el movimiento de levitaci�n
const float levitationAmplitude = 2.5;  // Ajusta este valor para controlar la altura de levitaci�n
const float speed = 1.0;  // Velocidad del movimiento

void main()
{
    // Movimiento oscilante en el eje Y para simular levitaci�n
    float moveOffset = levitationAmplitude * sin(time * speed);  // Controla el movimiento suave en el eje Y
    
    // Aplicamos la traslaci�n a la posici�n del objeto
    vec3 newPos = aPos + vec3(0.0, moveOffset, 0.0);  // Solo movemos en el eje Y
    
    // Calculamos la posici�n final del v�rtice con las matrices
    gl_Position = projection * view * model * vec4(newPos, 1.0);
    
    // Pasamos las coordenadas de textura
    TexCoords = aTexCoords;
}