-- PUNTO 7

-- Modificacion del trigger Baja_usuario
DROP TRIGGER Baja_usuario;
GO

CREATE TRIGGER Baja_usuario
ON Empleados
AFTER DELETE
AS
BEGIN
    DELETE u
    FROM Usuarios u
    INNER JOIN deleted d ON u.legajo = d.legajo;
END;
GO

-- Desactivar trigger Calcular_importe_factura
DISABLE TRIGGER Calcular_importe_factura ON Facturas;

-- Desactivar todos los triggers de la tabla Consumos
DISABLE TRIGGER ALL ON Consumos;


-- PUNTO 8

-- Columnas nuevas a Facturas
ALTER TABLE Facturas
ADD fecha_vto DATE,
    fecha_pago DATE,
    intereses INT;

-- Trigger para asignar recargo si paga después del vencimiento
CREATE TRIGGER Recargo_factura
ON Facturas
AFTER UPDATE
AS
BEGIN
    IF UPDATE(fecha_pago)
    BEGIN
        UPDATE f
        SET f.intereses = 5
        FROM Facturas f
        INNER JOIN inserted i ON f.nro_factura = i.nro_factura
        WHERE i.fecha_pago > i.fecha_vto;
    END
END;
GO