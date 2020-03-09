# Planetary System Navigator 🚀🪐

Random planetary system visualizer that you can navigate with a starship. Created using [Processing](https://processing.org).
> **Adrián Lorenzo Melián** - *Creando Interfaces de Usuario*, [**ULPGC**](https://www.ulpgc.es).
> adrian.lorenzo101@alu.ulpgc.es

<div align="center">
 <img src=images/demo.gif alt="Creator demo"></img>
 <p>Figura 1 - Demostración de la ejecución de la aplicación</p>
</div>

***

## Índice
* [Introducción](#introduction)
* [Instrucciones de uso](#instructions) 
* [Implementación](#implementation)
    * [Camara](#camera)
      * [Traslación](#translation)
      * [Rotación](#rotation)
* [Herramientas y recursos utilizados](#tools-and-resources)
* [Referencias](#references)

## Introducción <a id="introduction"></a>
El objetivo de esta práctica es **la creación de un prototipo que muestre un sistema planetario [1] y permita navegar al usuario con una nave a través del mismo sistema** que se encuentre en movimiento y posea al menos cinco planetas y alguna luna usando alguna imagen.

Esto es una ampliación del anterior proyecto que implementa una [aplicación para visualizar sistemas planetarios pseudoaleatorios](https://github.com/AdrianLorenzoDev/planetarySystem). En este README se hará referencia a aquellas mejoras realizadas para la incorporación de la cámara. Para más información sobre la generación de planetas aleatorios y su disposición, consulta el otro proyecto.

## Instrucciones de uso<a id="instructions"></a>
Para navegar por el sistema planetario se dispone de distintos controles. Con las teclas `W`, `A`, `S` y `D` puedes **mover la nave hacia adelante, hacia atrás y hacia los lados**. Con las `Arrow keys` **puedes rotar la nave en el eje X y el eje Y.**

Si no deseas navegar en el sistema planetario y deseas observar el sistema desde una vista general, puedes hacerlo pulsando la tecla `ENTER`, que te **permite alternar entre las diferentes vistas (general o nave).**

## Implementación <a id="implementation"></a>

### Cámara <a id="camera"></a>

El sistema de cámara está basado en principios básicos de álgebra lineal. Una cámara está caracterizada por:

* Un **vector que determina su posición** en el espacio tridimensional.
* Un **vector que determina la dirección a la que está observando** la cámara.
* Un **vector que determina donde se encuentra la parte superior de la cámara**, y con la que se construye a partir de la función `camera()` el producto vectorial de la posición de la cámara y la dirección a la que mira.

A partir de estos vectores, se puede construir el sistema de movimiento de la cámara. Este se divide en dos: traslación y rotación.

#### Traslación <a id="translation"></a>

En la aplicación, podemos trasladarnos hacia adelante, hacia atrás y en las direcciones perpediculares al vector director de la cámara y al vector *up*. Para ello simplemente será necesario sumar a la posición la dirección a la que se quiere mover escalada a un factor de velocidad.

```java
  // Move forward
  if (isWPressed) {
    eyePosition.add(PVector.mult(eyeDirection, eyeTranslationDelta));
  }
     
  // Move backward
  if (isSPressed) {
    eyePosition.sub(PVector.mult(eyeDirection, eyeTranslationDelta));
  }

  // Move left
  if (isAPressed) {
    PVector crossProduct = new PVector();

    // Perpendicular direction to eye direction and up vector
    PVector.cross(eyeDirection, eyeUp, crossProduct);
    crossProduct.normalize();
    
    eyePosition.sub(PVector.mult(crossProduct, eyeTranslationDelta));
  }

  // Move right  
  if (isDPressed) {
    PVector crossProduct = new PVector();

    // Perpendicular direction to eye direction and up vector
    PVector.cross(eyeDirection, eyeUp, crossProduct);
    crossProduct.normalize();

    eyePosition.add(PVector.mult(crossProduct, eyeTranslationDelta));
  }
```

#### Rotación <a id="rotation"></a>

Para la rotación, la implementación está basada en los principios de los **ángulos de navegación**, los cuáles son un subtipo de **ángulos de Euler** [2]. En nuestro caso, nuestro objetivo es que se pueda rotar en el eje X (guiñada) y en el eje Y(pitch) la nave. 

<div align="center">
 <a href="https://en.wikipedia.org/wiki/Euler_angles#/media/File:Eulerangles.svg">
  <img src=images/eulerangles.png width=200 alt="Euler angles"></img>
 </a>
 <p>Figura 2 - Ángulos de Euler <a><a href="https://en.wikipedia.org/wiki/Euler_angles#/media/File:Eulerangles.svg">[Fuente]</a></p>
</div>

Para realizar este proceso, se calcula la rotación producida por cada uno de estos ángulos en el vector director de la curva. Al estar usando teclas, cada pulsación se corresponde con una diferencia de rotación hacia el sentido al que se quiere girar.

```java
// Rotate up
if (isUpPressed) {
  pitch -= eyeRotationDelta;
  pitch = pitch % 360;
}

// Rotate down
if (isDownPressed) {
  pitch += eyeRotationDelta;
  pitch = pitch % 360;
}

// Rotate left
if (isLeftPressed) {
  yaw -= eyeRotationDelta;
  yaw = yaw % 360;
}

// Rotate right
if (isRightPressed) {
  yaw += eyeRotationDelta;
  yaw = yaw % 360;
}

// New direction
PVector direction = new PVector(
  cos(radians(yaw)) * cos(radians(pitch)),
  sin(radians(pitch)),
  sin(radians(yaw)) * cos(radians(pitch))
);

direction.normalize();
eyeDirection = direction;
```

## Herramientas y recursos utilizados <a id="tools-and-resources"></a>

- [*Starship McStarshipFace*. Jason Neufeld](https://poly.google.com/view/eMrqcfO5i9p) - Modelo de nave espacial construido en Google Blocks bajo licencia Creative Commons BY.
- [Giphy](https://giphy.com) - Herramienta usada para la creación de gifs a partir de los frames de la aplicación.
- [Material Design Color Tool](https://material.io/resources/color/) - Herramienta usada para obtener la paleta de color usada para los cuerpos celestes (planetas, satélites y estrellas).
- [Solar System Scope Textures](https://www.solarsystemscope.com/textures/) - Recurso de texturas del espacio desde la que se obtuvo la imagen del espacio usada para el fondo.

## Referencias <a id="references"></a>
- [1] [Sistema planetario](https://es.wikipedia.org/wiki/Sistema_planetario)
- [3] [Ángulos de navegación](https://en.wikipedia.org/wiki/Euler_angles)
- [3] [Ángulos de Euler](https://en.wikipedia.org/wiki/Euler_angles)



