
/*
Asignatura: Bases de Datos
Curso: 2024/25 
Convocatoria: junio

Practica: P2.S4
---------------------------
Cuenta Oracle: bd3403
Estudiante(s):  Vinicius Paredes Cabral
*/



-- Q7

SELECT S.titulo,
       S.nacionalidad
FROM SERIE S
WHERE
    -- menos 4 etiquetas
    (SELECT COUNT(*) 
     FROM ETIQUETADO E
     WHERE E.serie = S.serie_id) < 4

    -- de interes para al menos un usuario con cuota < 50
    AND EXISTS (
        SELECT 1
        FROM INTERES N
        JOIN USUARIO U ON N.usuario = U.usuario_id
        WHERE N.serie = S.serie_id
          AND U.cuota < 50
    )

    -- al menos 3 interpretes USA
    AND (SELECT COUNT(*)
         FROM REPARTO R
         JOIN INTERPRETE I ON R.interprete = I.interprete_id
         WHERE R.serie = S.serie_id
           AND I.nacionalidad = 'Estados Unidos'
        ) >= 3

ORDER BY S.titulo;


-- Q9

SELECT DISTINCT E.usuario,
       E.serie,
       T1.ultima_temp AS ultima_temporada
FROM (
    SELECT T.serie, MAX(T.temporada) AS ultima_temp
    FROM TEMPORADA T
    JOIN ETIQUETADO Q ON T.serie = Q.serie
    WHERE Q.etiqueta = 'Accion'
    GROUP BY T.serie
) T1
JOIN ESTOY_VIENDO E ON T1.serie = E.serie AND T1.ultima_temp = E.temporada
ORDER BY E.usuario;




