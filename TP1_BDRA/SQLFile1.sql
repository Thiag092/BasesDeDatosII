create database TP1;

go

use TP1;

go

create table Empleados(
	DNI int primary key check(DNI between 0 and 99999999),
	legajo nvarchar(6) unique,
	apellido nvarchar(50),
	nombres nvarchar(100),
	cargo int check(cargo between 50 and 120),
	sueldo money check(sueldo <= 450000)
);


- Crear un trigger de nombre Control_sueldo, que impida que se incremente el sueldo 
en más de un 20%, cada vez que se modifique dicho atributo. El evento que dispara 
el trigger es UPDATE (sueldo), y su tiempo de acción es BEFORE.  - Crear un trigger de nombre Adicional_cargo, para el caso en que el atributo cargo 
tome el valor 90, entonces deberá de incrementarse el atributo sueldo de la tabla 
Empleados en un 15% respecto del importe básico para ese cargo, este último 
(importe básico) se halla almacenado en la tabla Importes_basicos, cuya clave 
primaria es el atributo cargo. El evento que dispara el trigger es INSERT/UPDATE del 
atributo cargo, y su tiempo de acción es AFTER , de la tabla Empleados.  