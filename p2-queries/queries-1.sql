--************************************************
--CONSULTAS 1
--************************************************

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






--1.6
SELECT interprete_id, nombre, a_nacimiento
FROM interprete
WHERE a_nacimiento between 1970 AND 1979
AND nacionalidad = 'Reino Unido'
ORDER BY a_nacimiento, nombre;

--1.7 CUIDADO
SELECT nombre, email, TO_CHAR(f_registro, 'Month') AS mes_registro
FROM usuario
WHERE nombre LIKE '%ia%';

--1.8
SELECT usuario_id, cuota, nombre, ROUND(cuota*1.05, 2)  AS nueva_cuota
FROM usuario
WHERE f_registro < TO_DATE('01/01/2021','dd/mm/yyyy')
AND cuota < 80
ORDER BY usuario_id;

--1.9 CUIDADO
SELECT nombre, ROUND((SYSDATE - f_registro)/365,1) AS tiempo_registro
FROM usuario
WHERE ROUND((SYSDATE - f_registro)/365,1) > 5
ORDER BY nombre;

--1.10
SELECT usuario, serie, temporada, capitulo, minuto, ROUND((SYSDATE - f_ultimo_acceso),0) AS dias
FROM estoy_viendo 
WHERE usuario IN ('U222','U777')
AND minuto > 20
ORDER BY usuario, serie;

--1.11
SELECT I.nombre, I.nacionalidad, R.rol
FROM interprete I
JOIN reparto R ON R.interprete = I.interprete_id
WHERE R.serie = 'S001'
ORDER BY R.rol;

--1.12
Select E.serie, S.titulo, E.etiqueta
FROM serie S
JOIN etiquetado E ON E.serie = S.serie_id
WHERE S.nacionalidad = 'Estados Unidos'
AND S.genero = 'Drama'
ORDER BY S.serie_id;

--1.13
SELECT DISTINCT I.nombre, I.a_nacimiento, R.rol
FROM interprete I
JOIN reparto R ON R.interprete = I.interprete_id
WHERE I.nacionalidad = 'Reino Unido' 
AND R.rol IN ('Protagonista', 'Secundario')
ORDER BY I.nombre;


--1.14
SELECT S.titulo, I.f_interes
FROM serie S
JOIN interes I ON I.serie = S.serie_id
JOIN usuario U ON U.usuario_id = I.usuario
WHERE U.nombre = 'Turiano'
ORDER BY S.titulo DESC;

--1.15
SELECT R.interprete, I.nombre, S.serie_id, S.titulo
FROM interprete I
JOIN reparto R ON R.interprete = I.interprete_id
JOIN serie S ON S.serie_id = R.serie
WHERE R.rol = 'Figuracion';


--1.16
SELECT S.titulo AS titulo_serie, C.temporada, T.a_estreno, C.capitulo, C.titulo AS titulo_capitulo
FROM temporada T
JOIN capitulo C ON C.serie = T.serie
AND C.temporada = T.temporada
JOIN serie S ON S.serie_id = T.serie
WHERE S.genero = 'Ciencia Ficcion'
AND C.duracion BETWEEN 50 AND 53
ORDER BY S.titulo, C.temporada;

--1.17
SELECT U.nombre, U.email, S.titulo, E.temporada, E.capitulo
FROM estoy_viendo E
JOIN usuario U ON U.usuario_id = E.usuario
JOIN serie S ON S.serie_id = E.serie
WHERE S.genero = 'Policiaca'
ORDER BY U.nombre DESC;

--1.18
SELECT S.titulo, U.nombre nombre_usuario
FROM interes I 
JOIN usuario U ON U.usuario_id = I.usuario
JOIN serie S ON S.serie_id = I.serie
WHERE U.f_registro < TO_DATE('01/01/2019','dd/mm/yyyy')
ORDER BY S.titulo;


--1.19
SELECT U.nombre nombre_usuario, S.titulo titulo_serie, C.titulo titulo_capitulo, E.minuto
FROM estoy_viendo E
JOIN usuario U ON U.usuario_id = E.usuario
JOIN serie S on S.serie_id = E.serie
JOIN capitulo C ON C.serie = E.serie
AND C.temporada = E.temporada
AND C.capitulo = E.capitulo
WHERE E.f_ultimo_acceso < TO_DATE('01/02/2025','dd/mm/yyyy')
ORDER BY U.nombre;

--1.20 CUIDADO
SELECT DISTINCT I.nombre, (EXTRACT(YEAR FROM SYSDATE) - I.a_nacimiento) AS edad
FROM interprete I
JOIN reparto R ON R.interprete = I.interprete_id
JOIN estoy_viendo E ON E.serie = R.serie
WHERE I.nacionalidad = 'Espana' 
AND I.a_nacimiento > 1985;

--1.21
SELECT DISTINCT S.titulo, S.genero, T.a_estreno
FROM interes I
JOIN serie S ON S.serie_id = I.serie
JOIN temporada T ON T.serie = S.serie_id
WHERE I.vista = 'SI'
AND T.temporada = 1
ORDER BY S.titulo;


--1.22
--COALESCE toma el primer valor no nulo: si I.serie es NULL
--(usuario sin intereses) devuelve 'SIN INTERESES'
SELECT U.nombre, COALESCE(I.serie, 'SIN INTERESES') AS serie_id   -- I.serie
FROM usuario U   
--Con un LEFT JOIN, pones la tabla “principal” a la izquierda (USUARIO)
--y dices “quiero todos sus registros, independientemente de si tienen 
--o no coincidencia en la tabla derecha (INTERES)
LEFT JOIN interes I ON I.usuario = U.usuario_id
ORDER BY U.NOMBRE desc;


--1.23
SELECT S.titulo titulo_serie, COALESCE(E.etiqueta, '*SIN ETIQUETAS*') AS etiqueta
FROM serie S
LEFT JOIN etiquetado E ON E.serie = S.serie_id
WHERE S.genero = 'Policiaca'
ORDER BY S.titulo, etiqueta;

--1.24
SELECT DISTINCT S.titulo titulo_serie, COALESCE( U.nombre, '*NADIE*') AS nombre_usuario
FROM serie S
LEFT JOIN estoy_viendo E ON E.serie = S.serie_id
LEFT JOIN usuario U ON U.usuario_id = E.usuario
ORDER BY S.titulo, nombre_usuario;

--1.25
SELECT DISTINCT U.nombre nombre_usuario, COALESCE(S.titulo, '*NADA*') AS titulo_serie
FROM usuario U --ponemos usuario en from porque es la tabla principal
LEFT JOIN estoy_viendo E ON E.usuario = U.usuario_id
LEFT JOIN serie S ON S.serie_id = E.serie
ORDER BY nombre_usuario, titulo_serie;

--1.26
SELECT serie_id serie
FROM serie
MINUS
SELECT serie
FROM etiquetado;

--1.27
SELECT serie_id serie
FROM serie
WHERE genero <> 'Policiaca'
MINUS
SELECT serie
FROM estoy_viendo;

--1.28
SELECT serie
FROM interes
INTERSECT
SELECT serie
FROM etiquetado
WHERE etiqueta = 'Thriller'
MINUS
SELECT serie
FROM estoy_viendo;

--1.29
SELECT interprete
FROM reparto
WHERE rol = 'Protagonista'
INTERSECT 
SELECT interprete
FROM reparto
WHERE rol = 'Reparto';

--1.30
SELECT usuario
FROM interes
MINUS
SELECT usuario
FROM estoy_viendo;

--1.31
SELECT serie, usuario
FROM interes
WHERE f_interes > TO_DATE('15/01/2023','dd/mm/yyyy')
MINUS
SELECT serie,usuario
FROM estoy_viendo
ORDER BY serie, usuario;

--1.32 CUIDADO
SELECT usuario
FROM estoy_viendo
WHERE (SYSDATE - f_ultimo_acceso)/30 > 6
UNION 
SELECT usuario_id
FROM usuario
WHERE cuota < 70 
AND
EXTRACT(YEAR FROM f_registro) >= 2022
ORDER BY usuario;

--1.33
SELECT serie_id
FROM serie
WHERE genero = 'Drama'
AND edad_minima = 18
INTERSECT
SELECT serie
FROM capitulo
WHERE temporada = 2
AND duracion BETWEEN 60 AND 100;


--1.34 CUIDADO
SELECT N.serie
FROM interes N
JOIN usuario U ON U.usuario_id = N.usuario
WHERE U.cuota BETWEEN 30 AND 45
UNION
SELECT serie_id AS serie
FROM serie
WHERE edad_minima < 16
UNION
SELECT serie
FROM capitulo
WHERE titulo LIKE '%4%';


--1.35 CUIDADO
SELECT interprete
FROM reparto
WHERE rol = 'Reparto'

INTERSECT

SELECT I.interprete_id interprete
FROM interprete I
WHERE I.a_nacimiento BETWEEN 1980 and 1989

MINUS

SELECT R.interprete
FROM reparto R
JOIN serie S ON S.serie_id = R.serie
WHERE S.nacionalidad = 'Estados Unidos';


--************************************************
--CONSULTAS 2
--************************************************


--agregados: Regla:
--Todas las columnas en el SELECT que no sean parte de una 
--función de agregado deben aparecer en el GROUP BY



--2.1
--Título y género de las series que nadie está viendo. (titulo, genero)
SELECT titulo, genero
FROM serie
WHERE serie_id NOT IN (
        SELECT DISTINCT serie
        FROM estoy_viendo
    );

--2.2
--Usuarios tales que la última vez que vieron alguna serie fue hace más de cuatro años.
--(nombre, f_registro, cuota)

SELECT U.nombre, U.f_registro, U.cuota
FROM usuario U
WHERE U.usuario_id IN (
    SELECT E.usuario
    FROM estoy_viendo E
    WHERE E.f_ultimo_acceso < SYSDATE - (365*4));

SELECT U.nombre, U.f_registro, U.cuota
FROM usuario U
JOIN estoy_viendo E ON E.usuario = U.usuario_id
WHERE E.f_ultimo_acceso < SYSDATE-1460;


--2.3
--Etiquetas empleadas en las series que son de interés para los 
--usuarios que no están viendo ninguna serie

SELECT DISTINCT T.etiqueta
FROM etiquetado T
WHERE T.serie IN (
    SELECT I.serie
    FROM interes I
    WHERE I.usuario NOT IN (
        SELECT E.usuario
        FROM estoy_viendo E));


--2.4
--Usuarios que no tienen interés en ninguna serie española, 
--ordenado por nombre. (nombre,f_registro, email)

SELECT U.nombre, U.f_registro, U.email
FROM usuario U
WHERE U.usuario_id NOT IN (
    SELECT I.usuario
    FROM interes I
    WHERE I.serie IN (
        SELECT S.serie_id
        FROM serie S
        WHERE S.nacionalidad = 'Espana'))
ORDER BY U.nombre;

--2.5
--Intérpretes que participan como protagonistas en alguna
--serie 'Policiaca', ordenado por nombre.(nombre, nacionalidad, a_nacimiento)

SELECT I.nombre, I.nacionalidad, I.a_nacimiento
FROM interprete I
WHERE I.interprete_id IN(
    SELECT R.interprete
    FROM reparto R
    WHERE R.rol = 'Protagonista'
    AND R.serie IN (
            SELECT S.serie_id
            FROM serie S
            WHERE S.genero = 'Policiaca'))
ORDER BY I.nombre;


--2.6
--Nombres y nacionalidades de los intérpretes no españoles, 
--que han participado en series de nacionalidad española. 
--Ordenado por nombre de intérprete. (nombre, nacionalidad)

SELECT I.nombre, I.nacionalidad
FROM interprete I
WHERE nacionalidad <> 'Espana'
AND I.interprete_id IN (
    SELECT R.interprete
    FROM reparto R
    WHERE R.serie IN (
        SELECT S.serie_id
        FROM serie S
        WHERE S.nacionalidad = 'Espana'))
ORDER BY I.nombre;

--2.7
--usuarios que actualmente están viendo alguna serie en cuyo 
--reparto hay un intérprete nacido entre 1990 y 2000. (usuario_id, nombre, email)
SELECT U.usuario_id, U.nombre, U.email
FROM usuario U
WHERE U.usuario_id IN (
    SELECT E.usuario
    FROM estoy_viendo E
    JOIN serie S ON S.serie_id = E.serie
    WHERE S.serie_id IN (
        SELECT R.serie
        FROM reparto R
        WHERE R.interprete IN (
            SELECT I.interprete_id
            FROM interprete I
            WHERE a_nacimiento BETWEEN 1990 AND 2000))) ;


SELECT DISTINCT U.usuario_id, U.nombre, U.email
FROM usuario U
JOIN estoy_viendo E ON E.usuario = U.usuario_id
JOIN reparto R ON R.serie = E.serie
JOIN interprete I ON I.interprete_id = R.interprete
WHERE I.a_nacimiento BETWEEN 1990 AND 2000;

--2.8
--usuarios que se han dejado a medio ver el primer capítulo de la 
--primera temporada de alguna serie que sólo tiene una temporada. 
--Se asume que si un usuario ha visto un capítulo completo, 
--éste desaparece de su lista “Estoy viendo”. No se debe utilizar 
--agrupamiento ni funciones de agregados. (usuario_id, nombre, cuota)


SELECT U.usuario_id, U.nombre, U.cuota
FROM usuario U
WHERE U.usuario_id IN (
    SELECT E.usuario
    FROM estoy_viendo E
    WHERE E.capitulo = 1
    AND E.temporada = 1
    AND E.serie NOT IN (
        SELECT T.serie
        FROM temporada T
        WHERE T.temporada <> 1
        ));
    
--2.10
--usuarios que pagan una cuota inferior a 65 euros y anotaron que 
--alguna serie era de su interés después del 1 de enero de 2024,
--o bien que se registraron en 2022 y no están viendo ninguna serie.
--Ordenado por identificador de usuario. (usuario_id, nombre, f_registro)



SELECT U.usuario_id, U.nombre, U.f_registro
FROM usuario U
WHERE U.cuota < 65 
AND U.usuario_id IN (
    SELECT I.usuario
    FROM interes I
    WHERE (I.f_interes > TO_DATE('01/01/2024','dd/mm/yyyy')))
    OR (EXTRACT(YEAR FROM(U.f_registro))= 2022 
        AND U.usuario_id NOT IN (
            SELECT E.usuario
            FROM estoy_viendo E))
ORDER BY U.usuario_id;


--el resto son iguales

--empezamos con COUNT
--2.14 
--Para cada etiqueta, mostrar en cuántas series aparece. Ordenado por número de series.
(etiqueta, n_series)








