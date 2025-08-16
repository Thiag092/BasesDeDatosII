--PostgreSQL 17 con NEON

--Punto 2

CREATE TYPE Persona AS (
  DNI INTEGER,
  apellido VARCHAR(50),
  nombres VARCHAR(100),
  direccion VARCHAR(200),
  ciudad VARCHAR(50),
  fecha_nac DATE
);

CREATE TYPE Empresa AS (
    Empleado Persona,
    mail VARCHAR(100),
    codigo_postal VARCHAR(10),
    sitio_web VARCHAR(250)
);

CREATE TYPE Jefe AS (
    Director Persona,
    mail VARCHAR(100),
    area VARCHAR(50),
    sueldo NUMERIC(10, 2),
    antiguedad INTEGER
);

CREATE table Empleados of Empresa;

-- otra forma
CREATE table Empleados2 (
  id INTEGER GENERATED ALWAYS as IDENTITY primary key,
  empleado Empresa
)

INSERT INTO Empleados (empleado, mail, codigo_postal, sitio_web)
VALUES (
  ROW(12345678, 'Pérez', 'Juan', 'Calle Falsa 123', 'Resistencia', DATE '1990-05-12')::Persona,
  'juan.perez@example.com',
  '1000',
  'www.ejemplo.com'
);

INSERT INTO Empleados2 (empleado)
VALUES (
  ROW(
    ROW(87654321, 'Gómez', 'María Laura', 'Av. Siempreviva 742', 'Collientes', DATE '1985-11-23')::Persona,
    'maria.gomez@example.com',
    '5000',
    'www.otroeje.com'
  )::Empresa
);

select * from Empleados;
select * from Empleados2;

-- Punto 7

CREATE TYPE Direccion_postal AS (
    calle VARCHAR(50),
    numero INTEGER,
    provincia VARCHAR(50),
    codigo_postal VARCHAR(10)
);

CREATE table Personas (
    DNI INTEGER PRIMARY KEY,
    nombre VARCHAR(50),
    apellidos VARCHAR(50),
    fecha_nacimiento DATE,
    telefonos TEXT[],
    direccion Direccion_postal
);