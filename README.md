# Bilingue-Interprete

Este proyecto consiste en un **intérprete completo** para un lenguaje de programación de dominio específico (DSL) diseñado para el procesamiento aritmético y cálculo matricial avanzado. El sistema integra el **análisis léxico**, el **análisis sintáctico** y la ejecución de instrucciones dentro de un motor de **evaluación**.


## 🚀 Características del Lenguaje

* **Análisis Léxico con Autómatas Finitos (AF):** Reconocimiento preciso de identificadores, constantes reales, cadenas y símbolos especiales mediante lógica de estados.
* **Análisis Sintáctico DPNR:** Implementación de un Analizador Sintáctico Descendente Predictivo No Recursivo basado en una Tabla de Análisis Sintáctico (TAS) y una pila de símbolos gramaticales.
* **Motor de Cálculo Matricial Nativo:**
    * Operaciones de suma, resta y multiplicación de matrices.
    * Transposición de matrices mediante el operador `@`.
    * Acceso indexado a celdas mediante la sintaxis `M[fila; columna]`.
    * Funciones de dimensión como `sizeCol` y `sizeFila`.
* **Estructuras de Control y Lógica:** Soporte para bucles `while`, condicionales `if-then-else` y operadores lógicos (`and`, `or`, `not`).
* **Operaciones Aritméticas:** Incluye soporte para potencias (`**`) y radicación (`rqz`).
* **Visualización del Árbol de Derivación:** Generación automática de un archivo `Arbol.TXT` que contiene la estructura jerárquica del programa analizado.

## 📂 Directorios Adicionales del Repositorio

Además del código fuente principal, el proyecto incluye recursos complementarios organizados en las siguientes carpetas:

* **`\Automatas`**: Contiene los diagramas de los Autómatas Finitos (AF) utilizados para el diseño del analizador léxico. **Nota:** Estos archivos deben abrirse utilizando el software **JFLAP**.
* **`\Ayuda para usar el lenguaje`**: Incluye guías y listas de sintaxis detalladas para aprender a estructurar programas dentro de este DSL.
* **`\Documentacion`**: Archivos de lectura que proporcionan un contexto general sobre la arquitectura y funcionamiento del intérprete.
* **`\Programas`**: Una colección de scripts escritos en *BiliLanguage* listos para ser ejecutados, ideales para probar y demostrar las capacidades del sistema.

## 🛠️ Estructura del Código Fuente

El código en Pascal está modularizado para separar claramente las fases del intérprete:

| Archivo | Función |
| :--- | :--- |
| `analizador_lexico.pas` | Tokenización del flujo de caracteres y gestión de la Tabla de Símbolos. |
| `analizador_sintactico.pas` | Validación de gramática mediante TAS y construcción del árbol de derivación. |
| `evaluador.pas` | Motor de ejecución que recorre el árbol y gestiona el estado de las variables. |
| `tipos.pas` | Definiciones globales de símbolos gramaticales y estructuras de datos de la TAS. |
| `unidad_arbol.pas` | Lógica de creación, gestión y persistencia del árbol sintáctico. |
| `archivo.pas` | Gestión de entrada y salida para el archivo fuente `Lenguaje.txt`. |
| `project1.pas` | Programa principal que coordina el flujo entre el analizador y el evaluador. |

## 📋 Ejemplo de Código (`Lenguaje.txt`)

El intérprete procesa archivos con una sintaxis estructurada similar a Pascal pero optimizada para matrices:

```pascal
biliprograma MiCalculo;
dec
    A : matrix [2; 2];
    x : real;
decend;

    A := { {1, 2} {3, 4} };
    x := A[1; 2] ** 2;
    escribir("Resultado: ", x, " Transpuesta: ", matrix(@(A)));

biliend;
```
## ⚠️ Consideraciones y Advertencias
Preste atencion que en el ejemplo anterior: **_x_** es un **_real_** y **_A_** es un dato de tipo **_matrix_**.

* A la hora de declarar una variable de tipo **_real_** el nombre de la variable debe poseer como minimo una letra minuscula.
* A la hora de declarar una variable de tipo **_matrix_** el nombre de la variable debe poseer **TODAS** las letras en **mayusculas**.


## ⚙️ Instalación y Ejecución

### 1. Requisitos Previos
Necesitarás tener instalado el compilador **Free Pascal (FPC)**. 
* **Linux:** `sudo pacman -S fpc` o `sudo apt install fpc`
* **Windows:** Descarga el instalador desde [freepascal.org](https://www.freepascal.org/download.html).

### 2. Compilación
Clona el repositorio y compila el programa principal desde la terminal:
```bash
fpc project1.pas
```
y luego ejecutar el archivo:
```
project1.exe
```

## Este proyecto fue subido a este repositorio una vez finalizado el mismo.
