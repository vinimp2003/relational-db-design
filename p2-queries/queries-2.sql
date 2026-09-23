ALTER TABLE usuario RENAME TO miusuario;

-- 1.4 filtro y ordeno
SELECT usuario_id, nombre, f_registro
FROM usuario
WHERE cuota BETWEEN 50 AND 100
AND f_registro > TO_DATE('20/05/2020','dd/mm/yyyy')
ORDER BY f_registro DESC;

-- 1.10

SELECT usuario usuario_id, serie serie_id, temporada, 
capitulo, minuto, ROUND(SYSDATE - f_ultimo_acceso,0) AS dias
FROM estoy_viendo
WHERE usuario IN ('U222','U777') AND minuto > 20 
ORDER BY usuario, serie;


--1.13

SELECT DISTINCT I.nombre, I.a_nacimiento, R.rol
FROM interprete I
JOIN reparto R ON R.interprete = I.interprete_id
WHERE I.nacionalidad = 'Reino Unido' 
AND R.rol IN ('Protagonista', 'Secundario')
ORDER BY I.nombre;

--1.16

SELECT S.titulo titulo_serie, T.temporada, T.a_estreno, C.capitulo, C.titulo titulo_capitulo
FROM serie S
JOIN temporada T ON T.serie = S.serie_id
JOIN capitulo C ON C.temporada = T.temporada 
AND C.serie = T.serie
WHERE S.genero = 'Ciencia Ficcion' 
AND C.duracion BETWEEN 50 AND 53
ORDER BY s.titulo, T.temporada;


--1.24

SELECT DISTINCT S.titulo titulo_serie, COALESCE(U.nombre, '*NADIE*') nombre_usuario
FROM estoy_viendo E
RIGHT JOIN serie S ON S.serie_id = E.serie
LEFT JOIN usuario U ON U.usuario_id = E.usuario
ORDER BY titulo_serie, nombre_usuario;

-- 1.35 en este usamos teoria de conjuntos

SELECT interprete
FROM reparto
WHERE rol = 'Reparto'
INTERSECT
SELECT interprete_id
FROM interprete
WHERE a_nacimiento BETWEEN 1980 AND 1989
MINUS
SELECT R.interprete
FROM reparto r
JOIN serie S ON S.serie_id = R.serie
WHERE S.nacionalidad = 'Estados Unidos';

-- 1.1 

SELECT *
FROM SERIE
WHERE edad_minima < 18 and not nacionalidad = 'Espana';



-- S1.2
-- Identificadores de las series y temporadas que los usuarios están viendo. Sin duplicados. Ordenado por serie y temporada.
SELECT DISTINCT E.serie, E.temporada
FROM ESTOY_VIENDO E
ORDER BY E.serie, E.temporada;


-- S1.3
-- Capítulos de la temporada 3 o posterior de alguna serie, cuya duración sea inferior a 45 minutos, ordenado por serie y temporada.
SELECT C.serie, C.temporada, C.capitulo, C.titulo, C.duracion
FROM CAPITULO C
WHERE C.temporada >= 3
  AND C.duracion < 45
ORDER BY C.serie, C.temporada;


-- S1.5
-- Identificador de los usuarios que desde antes del 05/02/2025 tienen pendiente de terminar algún capítulo del que visualizaron al menos 15 minutos.
-- Sin duplicados y ordenado por usuario.
SELECT DISTINCT E.usuario
FROM ESTOY_VIENDO E
WHERE E.f_ultimo_acceso < TO_DATE('05/02/2025', 'dd/mm/yyyy')
  AND E.minuto >= 15
ORDER BY E.usuario;


-- S1.6
-- Intérpretes nacidos en la década de los 70 (siglo XX) de nacionalidad británica ('Reino Unido'),
-- ordenados por año de nacimiento y por nombre.
SELECT I.interprete_id, I.nombre, I.a_nacimiento
FROM INTERPRETE I
WHERE I.nacionalidad = 'Reino Unido'
  AND I.a_nacimiento BETWEEN 1970 AND 1979
ORDER BY I.a_nacimiento, I.nombre;


-- S1.7
-- Para cada usuario cuyo nombre incluye el texto ‘ia’, mostrar el nombre, email y el mes (en letras)
-- en que se registró en la plataforma.
SELECT U.nombre, U.email, TO_CHAR(U.f_registro, 'Month') AS mes_registro
FROM USUARIO U
WHERE U.nombre LIKE '%ia%';


-- S1.8
-- Para cada usuario registrado antes del 01/01/2021 y que paga una cuota inferior a 80€,
-- mostrar cómo quedaría su cuota si aumentara un 5% redondeada a dos decimales.
SELECT U.usuario_id,
       U.nombre,
       ROUND(U.cuota * 1.05, 2) AS nueva_cuota
FROM USUARIO U
WHERE U.f_registro < TO_DATE('01/01/2021', 'dd/mm/yyyy')
  AND U.cuota < 80
ORDER BY U.usuario_id;


-- S1.9
-- Nombres de los usuarios registrados hace más de 5 años, incluyendo el nº de años que hace que se registraron,
-- redondeado a 1 decimal. Ordenado por nombre.
SELECT U.nombre,
       ROUND((SYSDATE - U.f_registro) / 365, 1) AS tiempo_registro
FROM USUARIO U
WHERE (SYSDATE - U.f_registro) / 365 > 5
ORDER BY U.nombre;


-- S1.11
-- Nombre y nacionalidad de los intérpretes que participan en la serie con código 'S001',
-- incluyendo el rol con el que han participado. Ordenado por rol.
SELECT I.nombre,
       I.nacionalidad,
       R.rol
FROM INTERPRETE I
JOIN REPARTO R ON I.interprete_id = R.interprete
WHERE R.serie = 'S001'
ORDER BY R.rol;


-- S1.12
-- Etiquetas asociadas a las series estadounidenses ('Estados Unidos') de género ‘Drama’,
-- ordenado por identificador de serie.
SELECT S.serie_id AS serie, S.titulo, Q.etiqueta
FROM SERIE S
JOIN ETIQUETADO Q ON Q.serie = S.serie_id
WHERE S.nacionalidad = 'Estados Unidos'
  AND S.genero = 'Drama'
ORDER BY S.serie_id;


-- S1.14
-- Series de interés para el usuario llamado ‘Turiano’, ordenadas alfabéticamente por título en orden descendente.
SELECT S.titulo, N.f_interes
FROM INTERES N
JOIN USUARIO U ON N.usuario = U.usuario_id
JOIN SERIE S ON N.serie = S.serie_id
WHERE U.nombre = 'Turiano'
ORDER BY S.titulo DESC;


-- S1.15
-- Identificador y nombre de los intérpretes que participan como figurantes ('Figuracion') en el reparto de alguna serie,
-- indicando el identificador y título de la serie.
SELECT I.interprete_id AS interprete, I.nombre, R.serie, S.titulo
FROM REPARTO R
JOIN INTERPRETE I ON R.interprete = I.interprete_id
JOIN SERIE S ON R.serie = S.serie_id
WHERE R.rol = 'Figuracion';


-- S1.17
-- Nombre y email de los usuarios que están viendo alguna serie de género ‘Policiaca’,
-- incluyendo el título de la serie y el capítulo que tienen a medio, en orden descendente por nombre.
SELECT U.nombre, U.email, S.titulo, E.temporada, E.capitulo
FROM ESTOY_VIENDO E
JOIN USUARIO U ON E.usuario = U.usuario_id
JOIN SERIE S ON E.serie = S.serie_id
JOIN CAPITULO C ON E.serie = C.serie AND E.temporada = C.temporada AND E.capitulo = C.capitulo
WHERE S.genero = 'Policiaca'
ORDER BY U.nombre DESC;


-- S1.18
-- Títulos de las series de interés para usuarios registrados antes del 2019.
SELECT S.titulo,
       U.nombre AS nombre_usuario
FROM INTERES N
JOIN USUARIO U ON N.usuario = U.usuario_id
JOIN SERIE S ON N.serie = S.serie_id
WHERE U.f_registro < TO_DATE('01/01/2019', 'dd/mm/yyyy')
ORDER BY S.titulo;


-- S1.19
-- Capítulo que están viendo los usuarios cuya fecha de último acceso es anterior al 01/02/2025,
-- indicando el título de la serie, el título del capítulo y el minuto en el que se quedaron.
SELECT U.nombre AS nombre_usuario,
       S.titulo AS titulo_serie,
       C.titulo AS titulo_capitulo,
       E.minuto
FROM ESTOY_VIENDO E
JOIN USUARIO U ON E.usuario = U.usuario_id
JOIN SERIE S ON E.serie = S.serie_id
JOIN CAPITULO C ON E.serie = C.serie AND E.temporada = C.temporada AND E.capitulo = C.capitulo
WHERE E.f_ultimo_acceso < TO_DATE('01/02/2025', 'dd/mm/yyyy')
ORDER BY U.nombre;


-- S1.20
-- Nombres y edad de los intérpretes de nacionalidad española, nacidos después de 1985 y que participan en series que algún usuario está viendo.
SELECT DISTINCT I.nombre,
       (TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) - I.a_nacimiento) AS edad
FROM INTERPRETE I
JOIN REPARTO R ON I.interprete_id = R.interprete
JOIN ESTOY_VIENDO E ON R.serie = E.serie
WHERE I.nacionalidad = 'Espana'
  AND I.a_nacimiento > 1985;


-- S1.21
-- Para cada serie de interés para algún usuario marcada como vista por tal usuario, mostrar su título, género y el año de estreno de su temporada 1.
SELECT S.titulo, S.genero, T.a_estreno
FROM INTERES N
JOIN SERIE S ON N.serie = S.serie_id
JOIN TEMPORADA T ON S.serie_id = T.serie
WHERE N.vista = 'SI'
  AND T.temporada = 1
ORDER BY S.titulo;


-- S1.22
-- Listado de usuarios y las series de su interés. Deben aparecer también los usuarios que no tengan lista de intereses,
-- para los cuales se debe mostrar el texto 'SIN INTERESES' en la columna 'serie_id'.
SELECT U.nombre,
       COALESCE(N.serie, 'SIN INTERESES') AS serie_id
FROM USUARIO U
LEFT JOIN INTERES N ON U.usuario_id = N.usuario
ORDER BY U.nombre DESC;


-- S1.23
-- Listado de series de género ‘Policiaca’ y sus etiquetas. Deben aparecer también las series que no tienen etiquetas,
-- mostrando '*SIN ETIQUETAS*' en la columna 'etiqueta'.
SELECT S.titulo AS titulo_serie,
       COALESCE(Q.etiqueta, '*SIN ETIQUETAS*') AS etiqueta
FROM SERIE S
LEFT JOIN ETIQUETADO Q ON S.serie_id = Q.serie
WHERE S.genero = 'Policiaca'
ORDER BY S.titulo, Q.etiqueta;


-- S1.25
-- Listado de usuarios y series que están viendo. Deben aparecer también los usuarios que no están viendo ninguna serie,
-- mostrando '*NADA*' en la columna 'titulo_serie'.
SELECT U.nombre AS nombre_usuario,
       COALESCE(S.titulo, '*NADA*') AS titulo_serie
FROM USUARIO U
LEFT JOIN ESTOY_VIENDO E ON U.usuario_id = E.usuario
LEFT JOIN SERIE S ON E.serie = S.serie_id
ORDER BY U.nombre, S.titulo;


-- S1.26
-- Identificadores de las series que no tienen ninguna etiqueta. (Usando operadores de conjuntos)
SELECT serie_id AS serie
FROM SERIE
MINUS
SELECT serie
FROM ETIQUETADO;


-- S1.27
-- Identificadores de las series cuyo género no sea 'Policiaca', tales que ningún usuario la está viendo.
SELECT serie_id AS serie
FROM SERIE
WHERE genero <> 'Policiaca'
MINUS
SELECT serie
FROM ESTOY_VIENDO;


-- S1.28
-- Identificadores de las series que son de interés para algún usuario y que tengan la etiqueta 'Thriller'
-- pero que no están siendo vistas por ningún usuario. (Usando sólo operadores de conjuntos)
(SELECT serie FROM INTERES)
INTERSECT
(SELECT serie FROM ETIQUETADO WHERE etiqueta = 'Thriller')
MINUS
(SELECT serie FROM ESTOY_VIENDO);


-- S1.29
-- Identificadores de los intérpretes que participan en el reparto de alguna serie como protagonistas
-- y en alguna otra serie como actores/actrices de reparto. (Usando operadores de conjuntos)
(SELECT interprete FROM REPARTO WHERE rol = 'Protagonista')
INTERSECT
(SELECT interprete FROM REPARTO WHERE rol = 'Reparto');


-- S1.30
-- Usuarios que tienen lista de intereses pero no están viendo nada. (Usando operadores de conjuntos)
SELECT usuario
FROM INTERES
MINUS
SELECT usuario
FROM ESTOY_VIENDO;


-- S1.31
-- Series de interés para algún usuario, cuya fecha de registro de dicho interés es posterior al 15/01/2023,
-- y que ese mismo usuario no la está viendo. Ordenado por los identificadores de serie y usuario.
SELECT serie, usuario
FROM INTERES
WHERE f_interes > TO_DATE('15/01/2023', 'dd/mm/yyyy')
MINUS
SELECT serie, usuario
FROM ESTOY_VIENDO;


-- S1.32
-- Identificadores de los usuarios que tienen a medio ver alguna serie a la que no acceden desde hace más de 6 meses,
-- o que pagan una cuota inferior a 70 euros y se registraron en 2022 o después. (Usando operadores de conjuntos)
(SELECT DISTINCT usuario
 FROM ESTOY_VIENDO
 WHERE f_ultimo_acceso < ADD_MONTHS(SYSDATE, -6))
UNION
(SELECT usuario_id AS usuario
 FROM USUARIO
 WHERE cuota < 70
   AND f_registro >= TO_DATE('01/01/2022', 'dd/mm/yyyy'));


-- S1.33
-- Series de género 'Drama' cuya edad mínima es 18, y con algún capítulo de su segunda temporada
-- cuya duración está entre 60 y 100 minutos. (Usando operadores de conjuntos)
(SELECT serie_id AS serie
 FROM SERIE
 WHERE genero = 'Drama'
   AND edad_minima = 18)
INTERSECT
(SELECT serie
 FROM CAPITULO
 WHERE temporada = 2
   AND duracion BETWEEN 60 AND 100);


-- S1.34
-- Series de interés para los usuarios cuya cuota está entre 30 y 45 euros,
-- o bien que tengan una edad mínima inferior a 16, o que tengan algún capítulo en cuyo título aparezca el número 4.
-- (Usando operadores de conjuntos)
(SELECT N.serie
 FROM INTERES N
 JOIN USUARIO U ON N.usuario = U.usuario_id
 WHERE U.cuota BETWEEN 30 AND 45)
UNION
(SELECT serie_id AS serie
 FROM SERIE
 WHERE edad_minima < 16)
UNION
(SELECT serie
 FROM CAPITULO
 WHERE titulo LIKE '%4%');


