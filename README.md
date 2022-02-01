# MoviesAppiOS
Read more: [Importing items from network to a CoreData store]()
Developer: Osvaldo Cespedes

Prueba Técnica
1. Crear una cuenta gratuita sobre el servicio https://www.themoviedb.org/
a. Se necesita generar un token de autenticación para poder consumir los servicios
API REST
i. https://www.themoviedb.org/documentation/api
2. Revisar la documentación
a. Se necesitan consumir 6 servicios con las siguientes características:
i. Películas
1. Favorite
2. Recommendations
3. Rated ii. Tv Show
1. Favorite
2. Recommendations 3. Rated
3. Se deberán generar 6 listas horizontales (3 para películas y 3 para programas de televisión), con un estilo tipo netflix.
4. Al seleccionar un elemento de la lista horizontal, se podrá ver el detalle de la película o show de televisión.
5. La aplicación deberá detectar si el dispositivo cuenta con internet o no.
a. En caso de que no cuente con internet, se deberán presentar las listas offline
i. Solo en caso de que previamente se consulten las listas desde la API
REST y se almacene en persistencia en el dispositivo.
ii. En caso de que no se cuente con listas almacenadas en persistencia, se deberá presentar un mensaje indicando que no se pueden ver las listas
por el momento.
6. Toda la información se deberá guardar cifrada.
7. Al consumir las librerías sobre el proyecto principal, se podrá optar porl as siguientes tecnologías de distribución:
a. iOS:
i. Cocoa pods
ii. Swift Package Manager.
b. Android:
i. Google ii. Maven
8. Se deberá usar para el consumo de servicios
a. iOS – URLSession
i. No será valido consumir los servicios por Alamo u otro proveedor de terceros.
 3
b. Android - Retrofit
9. Sobre el proyecto principal, solo será válido el consumo información, para realizar
cálculos, consumos de servicios, persistencia, cifrado/decifrado, formatos, etc se
deberán realizar sobre las librerías.
10. Los proyectos deberán presentar pruebas unitarias
a. Solo en caso de poder implementarse las pruebas.
b. Se deberá abarcar el mayor porcentaje de cobertura sobre código en las pruebas.
11. Al finalizar el desarrollo del proyecto, se deberán publicar los repositorios
a. Públicos
b. Rama Main/Master
c. README con una descripción breve de la arquitectura usada y el consumo de
sus funcionalidades
La evaluación tiene una duración máxima de 3 días (72 horas máximo)
