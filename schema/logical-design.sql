/*
Asignatura: Bases de Datos
Curso: 2024/25 
Convocatoria: junio

Practica: P1. Diseño Lógico
---------------------------
Cuenta Oracle: bd3403
Estudiante(s):  Vinicius Paredes Cabral
*/

------------------------------------------------------------
-- Sentencias DROP (en orden inverso) para re-ejecución del script
------------------------------------------------------------
DROP TABLE EMAIL_CONTACTO CASCADE CONSTRAINTS;
DROP TABLE CHAT_GRUPO CASCADE CONSTRAINTS;
DROP TABLE MENSAJE CASCADE CONSTRAINTS;
DROP TABLE CONTACTO CASCADE CONSTRAINTS;
DROP TABLE USUARIO CASCADE CONSTRAINTS;

------------------------------------------------------------
-- 1. Crear USUARIO
------------------------------------------------------------
CREATE TABLE USUARIO (
    telefono       NUMBER(9)       NOT NULL,
    nombre         VARCHAR2(30)    NOT NULL,
    fecha_registro DATE            NOT NULL,
    idioma         VARCHAR2(30)    NOT NULL,
    descripcion    VARCHAR2(30)    NULL,
    CONSTRAINT PK_USUARIO PRIMARY KEY (telefono)
);

------------------------------------------------------------
-- 2. Crear CONTACTO
-- Clave primaria compuesta: (telefono, telefono_usuario)
-- Se referencia USUARIO mediante telefono_usuario.
------------------------------------------------------------
CREATE TABLE CONTACTO (
    telefono         NUMBER(9)       NOT NULL,  
    nombre           VARCHAR2(30)    NOT NULL,
    apellidos        VARCHAR2(30)    NULL,
    dia              NUMBER(2)       NULL,
    mes              NUMBER(2)       NULL,
    telefono_usuario NUMBER(9)       NOT NULL,
    CONSTRAINT PK_CONTACTO PRIMARY KEY (telefono, telefono_usuario),
    CONSTRAINT FK_CONTACTO_USUARIO FOREIGN KEY (telefono_usuario)
       REFERENCES USUARIO(telefono)
       -- ON DELETE NO ACTION, ON UPDATE NO ACTION
    ,
    CONSTRAINT CHK_CONTACTO_FECHA CHECK (
         ((dia IS NOT NULL) OR (mes IS NOT NULL)) OR ((dia IS NULL) AND (mes IS NULL))
         AND (dia < 32 OR dia IS NULL)
         AND (mes < 13 OR mes IS NULL)
    )
);

------------------------------------------------------------
-- 3. Crear MENSAJE
-- Se incluye FK a USUARIO y FK self-referencial (original).
-- La FK hacia CHAT_GRUPO se agregará mediante ALTER TABLE.
------------------------------------------------------------
CREATE TABLE MENSAJE (
    mensaje_id CHAR(10)      NOT NULL,
    reenviado  CHAR(2)       NOT NULL,
    diahora    DATE          NOT NULL,
    chat_grupo CHAR(4)       NULL,
    usuario    NUMBER(9)     NOT NULL,
    original   CHAR(10)      NULL,
    CONSTRAINT PK_MENSAJE PRIMARY KEY (mensaje_id),
    CONSTRAINT FK_MENSAJE_USUARIO FOREIGN KEY (usuario)
       REFERENCES USUARIO(telefono)
       -- ON DELETE NO ACTION, ON UPDATE NO ACTION
    ,
    CONSTRAINT FK_MENSAJE_ORIGINAL FOREIGN KEY (original)
       REFERENCES MENSAJE(mensaje_id)
       -- ON DELETE NO ACTION, ON UPDATE NO ACTION
    ,
    CONSTRAINT CHK_MENSAJE_REENVIADO CHECK (reenviado IN ('SI','NO')),
    CONSTRAINT CHK_MENSAJE_NO_SELF CHECK (original IS NULL OR mensaje_id <> original)
);

------------------------------------------------------------
-- 4. Crear CHAT_GRUPO
-- Clave primaria es el código (CHAR(4)).
-- Se incluyen FK a MENSAJE y a USUARIO.
------------------------------------------------------------
CREATE TABLE CHAT_GRUPO (
    nombre          VARCHAR2(30)    NOT NULL,
    codigo          CHAR(4)         NOT NULL,
    fecha_creacion  DATE            NOT NULL,
    miembros        NUMBER          NULL,
    mensaje         CHAR(10)        NOT NULL,
    telefono_usuario NUMBER(9)       NOT NULL,
    CONSTRAINT PK_CHAT_GRUPO PRIMARY KEY (codigo),
    CONSTRAINT FK_CHAT_GRUPO_MENSAJE FOREIGN KEY (mensaje)
       REFERENCES MENSAJE(mensaje_id)
       -- ON DELETE NO ACTION, ON UPDATE NO ACTION
    ,
    CONSTRAINT FK_CHAT_GRUPO_USUARIO FOREIGN KEY (telefono_usuario)
       REFERENCES USUARIO(telefono)
       -- ON DELETE NO ACTION, ON UPDATE NO ACTION
);

------------------------------------------------------------
-- 5. Agregar la FK a CHAT_GRUPO en MENSAJE
-- Se hace mediante ALTER TABLE, ya que CHAT_GRUPO ya existe.
------------------------------------------------------------
ALTER TABLE MENSAJE
ADD CONSTRAINT FK_MENSAJE_CHAT_GRUPO
  FOREIGN KEY (chat_grupo)
  REFERENCES CHAT_GRUPO(codigo)
  -- ON DELETE NO ACTION
  /* Oracle no soporta ON UPDATE, por lo que se omite */
;

------------------------------------------------------------
-- 6. Crear EMAIL_CONTACTO
-- Se corrige la FK para referenciar correctamente a CONTACTO (PK compuesta: telefono y telefono_usuario)
------------------------------------------------------------
CREATE TABLE EMAIL_CONTACTO (
    telefono         NUMBER(9)       NOT NULL,
    telefono_usuario NUMBER(9)       NOT NULL,
    email            VARCHAR2(50)    NOT NULL,
    CONSTRAINT PK_EMAIL_CONTACTO PRIMARY KEY (telefono, telefono_usuario, email),
    CONSTRAINT FK_EMAIL_CONTACTO_CONTACTO FOREIGN KEY (telefono, telefono_usuario)
       REFERENCES CONTACTO(telefono, telefono_usuario)
       -- ON DELETE NO ACTION, ON UPDATE NO ACTION
);
