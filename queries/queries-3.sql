/*
Asignatura: Bases de Datos
Curso: 2024/25 
Convocatoria: junio

Practica: P2.S3
---------------------------
Cuenta Oracle: bd3403
Estudiante(s):  Vinicius Paredes Cabral
*/


-- Q4

SELECT DISTINCT S.serie_id, S.titulo, S.genero
FROM interes N
JOIN usuario U ON N.usuario = U.usuario_id
JOIN serie S ON N.serie = S.serie_id
WHERE EXTRACT(YEAR FROM U.f_registro) = 2022
UNION
SELECT DISTINCT S.serie_id, S.titulo, S.genero
FROM estoy_viendo E
JOIN usuario U ON E.usuario = U.usuario_id
JOIN serie S ON E.serie = S.serie_id
WHERE U.cuota > 70
ORDER BY serie_id;



--Q5
SELECT DISTINCT S.serie_id, S.titulo, S.edad_minima
FROM serie S
JOIN interes N ON S.serie_id = N.serie
WHERE S.genero = 'Drama'
  AND NOT EXISTS (
        SELECT 1
        FROM estoy_viendo E
        WHERE E.usuario = N.usuario
          AND E.serie = N.serie)   
ORDER BY S.serie_id;


--Q6

SELECT R.serie,
COUNT(DISTINCT T.temporada) AS n_temporadas
FROM reparto R
JOIN interprete I ON R.interprete = I.interprete_id
JOIN temporada T ON R.serie = T.serie
WHERE I.nacionalidad = 'Reino Unido'
GROUP BY R.serie
HAVING COUNT(DISTINCT R.interprete) > 5
ORDER BY R.serie;
