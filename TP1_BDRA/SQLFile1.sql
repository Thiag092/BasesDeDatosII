create database TP1;

use TP1;

-- Punto 1

create table Empleados(
	DNI int primary key check(DNI between 0 and 99999999),
	legajo nvarchar(6) unique,
	apellido nvarchar(50),
	nombres nvarchar(100),
	cargo int check(cargo between 50 and 120),
	sueldo money check(sueldo <= 450000)
);

insert into Empleados(DNI, legajo, apellido, nombres, cargo, sueldo)
values (44000000, '600nnn', 'goméz', 'rodrigo', 50, 1000.00);

update Empleados
set sueldo = 1300.00
where DNI = 44000000;
-- Actualiza más del 20% sin problema

create trigger Control_sueldo
on Empleados
instead of update
as
begin
	set nocount on; 
	if update (sueldo)
	begin
		if exists(
			select 1
			from inserted i
			join deleted d on i.DNI = d.DNI
			where i.sueldo > d.sueldo *1.2
		)
		begin
			raiserror('Error: No se puede incrementar el sueldo en más de un 20%', 1, 6, 1);
			return;
		end
		update e
		set 
			e.sueldo = i.sueldo,
			e.DNI = i.DNI,
			e.legajo = i.legajo,
			e.apellido = i.apellido,
			e.nombres = i.nombres,
			e.cargo = e.cargo
		from Empleados e
		inner join inserted i on e.DNI = i.DNI;
	end
	else
	begin
		update e
		set
			e.DNI = i.DNI,
			e.legajo = i.legajo,
			e.apellido = i.apellido,
			e.nombres = i.nombres,
			e.cargo = e.cargo
		from Empleados e
		inner join inserted i on e.DNI = i.DNI;
	end
end;

update Empleados
set sueldo = 2000
where DNI = 44000000
select * from Empleados
-- Ya no permite actualizar más del 20%


create table Importes_basicos(
	id int primary key check(id between 50 and 120),
	monto money
);

insert into Importes_basicos(id, monto)
values (90, 1500);
insert into Empleados(DNI, legajo, apellido, nombres, cargo, sueldo)
values (43000000, '500nnn', 'zomég', 'rogrido', 90, 1000.00);
select * from Empleados;
-- No actualiza el sueldo

create trigger Adicional_cargo
on Empleados
after insert, update
as
begin
	set nocount on;
	if update(cargo)
	begin 
		update e
		set e.sueldo = ib.monto * 1.15
		from Empleados e
		inner join inserted i on e.DNI = i.DNI
		inner join Importes_basicos ib on i.cargo = ib.id
		where i.cargo = 90
	end
end;

insert into Empleados(DNI, legajo, apellido, nombres, cargo, sueldo)
values (42000000, '550nnn', 'zémog', 'dogriro', 90, 1000.00);
select * from Empleados;
-- Sí actualiza el sueldo: 1500 -> 1725

-- Punto 2

create table Clientes(
	DNI int primary key,
	nombre nvarchar(50)
);

create table Vehiculos(
	marca nvarchar(8) check(marca in('Ford','Renault','Fiat', 'Peugeot', 'VW', 'Toyota', 'Nissan')),
	anio_modelo int,
	primary key (marca, anio_modelo)
);

create table Seguros_autos(
	nro_poliza int primary key,
	DNI int foreign key	references Clientes(DNI),
	anio_modelo int default 2022,
	marca nvarchar(8) not null check(marca in ('Ford','Renault','Fiat', 'Peugeot', 'VW', 'Toyota', 'Nissan')),
	patente nvarchar(10) not null,
	nro_motor int not null,
	periodo_pago nvarchar(6),
	importe_pagar money not null,
	foreign key (marca, anio_modelo) references Vehiculos(marca, anio_modelo)
);

create table Cuotas_seguros(
	id nvarchar(12) primary key,
	nro_poliza int,
	monto money,
	fecha_pago date,
	foreign key (nro_poliza) references Seguros_autos(nro_poliza)
);

create trigger Facturas_mensuales
on Seguros_autos
after insert
as
begin
	set nocount on;
	insert into Cuotas_seguros (id, nro_poliza, monto, fecha_pago)
	select
		concat(i.nro_poliza, i.periodo_pago,'0', cuota.nro_cuota),
		i.nro_poliza,
		i.importe_pagar/3,
		case cuota.nro_cuota
			when 1 then '2024-01-15'
            when 2 then '2024-02-15'
            when 3 then '2024-03-15'
		end
	from inserted i
	cross join (values (1), (2), (3)) as cuota(nro_cuota);
end;

-- Insertar clientes
insert into Clientes (DNI, nombre) VALUES 
(12345678, 'Juan Pérez'),
(23456789, 'María González'),
(34567890, 'Carlos López');

-- Insertar vehículos (marca y año modelo)
insert into Vehiculos (marca, anio_modelo) VALUES 
('Ford', 2020),
('Ford', 2022);

select count(*) from Cuotas_seguros -- igual a 0

insert into Seguros_autos (nro_poliza, DNI, marca, anio_modelo, patente, nro_motor, periodo_pago, importe_pagar) VALUES 
(1001, 12345678, 'Ford', 2022, 'ABC123', 123456, '202401', 3000.00);

select * from Cuotas_seguros; -- tres registros