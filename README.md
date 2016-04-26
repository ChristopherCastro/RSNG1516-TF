# Trabajo final de RSNG

El objetivo del trabajo será el análisis de prestaciones mediante simulación de un
servicio en la nube

## Escenario

Tenemos un servicio de envío de vídeos. Los videos son servidos por máquinas en las
que corre un servidor web configurado con varios (N) hilos. Mientras un hilo está
sirviendo un video no puede hacer nada más durante el tiempo de envío del vídeo. En
la red cada flujo TCP enviado por un hilo esta limitado a una velocidad C, por lo
que en total un servidor de N hilos enviara C*N Mbps si tiene todos los hilos
ocupados enviando. El servidor sólo puede mantener un pequeño número q de peticiones
esperando si tiene todos los hilos ocupados. De hecho esto se puede configurar a q=0
y que no deje esperar a ninguno, Por tanto el sistema de una máquina servidora es un
`G/G/N/N+q` Las llegadas no sabemos como van a ser aunque supondremos que de
Poisson y tendremos un `M/G/N/N+q` La máquina básica del servidor es una máquina
virtual que se puede instanciar más de una vez. Cada maquina puede acceder al SAN
donde se guardan los videos a gran velocidad por lo que el cuello de botella es la
velocidad a la que se envían los videos hacia el cliente. Las peticiones del usuario
llegan a un sistema de balanceo que reparte las peticiones aleatoriamente entre las
M instancias de servidores. Consideramos dos tipos de videos a servir en ambos casos
con duración media de T=1minuto. Es decir suponemos que el video está codificado
para una velocidad de datos C y que dura un minuto de visualización y tambien por
tanto un minuto en ser enviado a velocidad C.

- **Caso 1**: La duración de los videos **es una exponencial con tiempo medio T**
  (Sistema M/M/N/N+q)
- **Caso 2**: La duración de todos los videos es **T** (Sistema M/D/N/N+q)

Consideramos que la probabilidad de no servir una petición no puede llegar a más del
5% y mejor si es menor que el 1%. Y tampoco podemos hacer a los usuarios esperar más
de 10-20 segundos para ver un video de 1minuto.

## Objetivo

Queremos saber cuales serán los limites del sistema. Cuantas peticiones por segundo
seremos capaces de atender, según los recursos que dediquemos para servirlos (N y
M). Para ello se programaran simuladores que nos permitan obtener resultados
simulando llegadas a sistemas con diferentes parámetros N, M y q.

## Simulador

Para analizar el sistema deberá implementar un simulador. Para simplificar y
verificar resultados parciales se pide una estructura de bloques común. Cada bloque
será un programa que lea datos en lineas de texto de la entrada y escriba datos en
lineas de texto a la salida. De este modo los resultados se podrán analizar con
herramientas UNIX estandar y se podrán proporcionar entradas comunes a los
simuladores de los diferentes grupos

## Entrada

La entrada al simulador serán lineas de texto que describan las llegadas con varios
campos numéricos separados por espacios. El formato será:

```
tllegada idllegada tservicio
```

- **tllegada**: es el tiempo absoluto de la llegada
- **idllegada**: un identificador numerico de la llegada para numerarlas y poder
  buscarlas después
- **tservicio**: es el tiempo que tardará en enviarse ese video cuando le toque

Las llegadas van apareciendo en el orden de llegada, es decir tllegada siempre es
creciente. Se pueden escribir generadores que proporcionen llegadas de los dos tipos
de videos:

```
generador_1 <lambda> <tmedio> <nmax>
```

Genera **nmax** llegadas con tiempos entre llegadas exponenciales y una tasa de
**lambda** llegadas por segundo y tiempos de servicio exponenciales con media
**tmedio**.

**Ejemplo:**

```bash
$ generador_1 2.0 3.0 1000

2.3 1 6.3
3.2 2 3.2
4.6 3 1.5
7.3 4 4.3
9.1 5 2.2
...
```

```
generador_2 <lambda> <t> <nmax>
```

Genera **nmax** llegadas con tiempos entre llegadas exponenciales y una tasa de
**lambda** llegadas por segundo y tiempos de servicio constantes **t**

**Ejemplo:**

```bash
$ generador_2 2.0 3.0 1000
0.3 1 3.0
1.2 2 3.0
4.5 3 3.0
4.6 4 3.0
5.3 5 3.0
...
```

## Simulador

El simulador del servidor web leerá una entrada como la anterior y proporcionara la
salida indicando en cada linea el resultado de una petición con el siguiente formato:

`tllegada idllegada tservicio servida tservidor tfin`

- **tllegada, idllegada y tservicio**, son los mismos que tenía esa llegada en el
  anterior
- **servida**, indica 1 si el video paso a un hilo de servidor para ser servido y 0 si
  fue rechazada porque al llegar no habia sitio en el sistema
- **tservidor**, indica en que tiempo absoluto la petición fue asignada a un hilo para
  ser servida
- **tfin**, indica en que tiempo absoluto la petición terminó de ser enviada y dejo
  libre el hilo del servidor


En el caso de que el video sea rechazado los parametros tservidor y tfin no tienen
sentido y no aparecerán.

El simulador debe ser capaz de funcionar indefinidamente mientras siga leyendo
entradas por la entrada estandar y debe ir sacando las salidas en cuanto conozca los
datos completos de cada petición.

El programa simulador aceptará como parámetros, el número de hilos y el número de
peticiones que puede mantener esperando sin tener hilo asignado.

```
simulador <nhilos> <q>
```

**Ejemplo:**

```bash
$ generador_1 10.0 3 | simulador 4 0
1.22 5 2.3 0
1.51 6 6.0 0
0.20 1 2.4 1 0.2 2.6
0.51 3 2.1 1 0.51 2.61
0.40 2 4.2 1 0.4 4.6
0.80 4 5.6 1 0.8 6.4
3.21 7 2.1 0
...
```

Nótese que las salidas en general no irán ordenadas por el tiempo de llegada

## Análisis

Los resultados de lanzar el simulador con diferentes parámetros se analizarán para
obtener probabilidades de rechazo de peticiones y distribuciones de tiempos. Se
pueden escribir más programas si es necesario. Cada grupo debe hacer las
simulaciones y el análisis que crea necesario para responder a las preguntas
planteadas en el escenario.

## Preguntas

### Basicas

¿Cual es el máximo número de peticiones por segundo que soportaremos con un único
servidor con N hilos?

Esto dependerá de N y q

¿Como será el tiempo de espera de las peticiones? Suponiendo que una vez que empiece
a enviarse el video practicamente se empieza a reproducir. ¿Como de probable es que
se quede parado esperando?

### Avanzadas

¿Como influye el que los videos sean de tamaño constante en lugar de exponenciales?

¿Como cambia esto si tenemos M maquinas virtuales? ¿Es mejor aumentar el número de
máquinas o aumentar los hilos de cada máquina? Si el número de hilos tiene un límite
por ejemplo 10 o 100, ¿Es mejor agotarlo antes de crear más máquinas?

Si tenemos M máquinas virtuales, ¿Como influye que el reparto round-robin en lugar
de aleatorio?

## Entrega

Cada grupo entregará una memoria breve con sus resultados y analisis, incluyendo
graficas, contestando a las preguntas que haya abordado. Y realizará una
presentacion el ultimo dia de clase.

La memoria y presentación deben centrarse en los resultados y no en como se ha
implementado el simulador.

Las preguntas se proporcionan como ejemplo de lo que podría ser interesante. No se
espera que se de respuesta a todas. También cada grupo puede analizar otras
preguntas que considere interesantes.