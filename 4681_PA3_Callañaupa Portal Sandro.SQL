CREATE DATABASE Callanaupa_Portal_Sandro_4681 

CREATE TABLE cliente_Callanaupa_Portal_Sandro_4681
(
 idCliente INT IDENTITY(1,1) PRIMARY KEY,
 nomCliente VARCHAR (50),
 apeCliente VARCHAR (50) 
);
CREATE TABLE empleado_Callanaupa_Portal_Sandro_4681 (
    idEmpleado INT IDENTITY(1,1) PRIMARY KEY,
    nomEmpleado VARCHAR(50),
    apeEmpleado VARCHAR(50)
);
CREATE TABLE producto_Callanaupa_Portal_Sandro_4681 
(
idProducto INT IDENTITY(1,1) PRIMARY KEY, 
nomProducto VARCHAR (50),
descProducto VARCHAR(200)
); 

CREATE TABLE pedido_Callanaupa_Portal_Sandro_4681 (
    idPedido INT IDENTITY(1,1) PRIMARY KEY,
    fechaPedido DATETIME DEFAULT GETDATE(),
    idCliente INT,
    idEmpleado INT,
    FOREIGN KEY (idCliente) REFERENCES cliente_Callanaupa_Portal_Sandro_4681(idCliente),
    FOREIGN KEY (idEmpleado) REFERENCES empleado_Callanaupa_Portal_Sandro_4681(idEmpleado)
);

 
CREATE TABLE detallePedido_Callanaupa_Portal_Sandro_4681 (
    idPedido INT,
    idProducto INT,
    precioUnitario MONEY,
    cantidad INT,
    descuento FLOAT,
    PRIMARY KEY (idPedido, idProducto),
    FOREIGN KEY (idPedido) REFERENCES pedido_Callanaupa_Portal_Sandro_4681(idPedido),
    FOREIGN KEY (idProducto) REFERENCES producto_Callanaupa_Portal_Sandro_4681(idProducto)
);
CREATE PROCEDURE sp_ins_cliente_Callanaupa_Portal_Sandro_4681
@nomCliente VARCHAR(50),
@apeCliente VARCHAR(50),
@idCliente INT OUTPUT
AS
BEGIN

    INSERT INTO cliente_Callanaupa_Portal_Sandro_4681 (nomCliente, apeCliente)
	VALUES (@nomCliente, @apeCliente);

	SET @idCliente = SCOPE_IDENTITY();
	END;


	DECLARE @nuevoIdCliente INT;

EXEC sp_ins_cliente_Callanaupa_Portal_Sandro_4681
    @nomCliente = 'Luis',
    @apeCliente = 'Gomez',
    @idCliente = @nuevoIdCliente OUTPUT;

SELECT 'ID Cliente Insertado' AS Resultado, @nuevoIdCliente AS ID;

SELECT * FROM cliente_Callanaupa_Portal_Sandro_4681;

CREATE PROCEDURE sp_ins_empleado_Callanaupa_Portal_Sandro_4681
    @nomEmpleado VARCHAR(50),
    @apeEmpleado VARCHAR(50),
    @idEmpleado INT OUTPUT
AS
BEGIN
    INSERT INTO empleado_Callanaupa_Portal_Sandro_4681 (nomEmpleado, apeEmpleado)
    VALUES (@nomEmpleado, @apeEmpleado);

    SET @idEmpleado = SCOPE_IDENTITY();
END;

DECLARE @nuevoIdEmpleado INT;

EXEC sp_ins_empleado_Callanaupa_Portal_Sandro_4681
    @nomEmpleado = 'Ana',
    @apeEmpleado = 'Rojas',
    @idEmpleado = @nuevoIdEmpleado OUTPUT;

SELECT 'ID Empleado Insertado' AS Resultado, @nuevoIdEmpleado AS ID;


SELECT * FROM empleado_Callanaupa_Portal_Sandro_4681;

CREATE PROCEDURE sp_ins_producto_Callanaupa_Portal_Sandro_4681
    @nomProducto VARCHAR(50),
    @descProducto VARCHAR(200),
    @idProducto INT OUTPUT
AS
BEGIN
    INSERT INTO producto_Callanaupa_Portal_Sandro_4681 (nomProducto, descProducto)
    VALUES (@nomProducto, @descProducto);

    SET @idProducto = SCOPE_IDENTITY();
END;

DECLARE @nuevoIdProducto INT;

EXEC sp_ins_producto_Callanaupa_Portal_Sandro_4681
    @nomProducto = 'Mouse',
    @descProducto = 'Mouse inalámbrico',
    @idProducto = @nuevoIdProducto OUTPUT;

SELECT 'ID Producto Insertado' AS Resultado, @nuevoIdProducto AS ID;

SELECT * FROM producto_Callanaupa_Portal_Sandro_4681;

CREATE OR ALTER PROCEDURE sp_ins_pedidodetalle_Callanaupa_Portal_Sandro_4681
    @idCliente INT,
    @idEmpleado INT,
    @idProducto INT,
    @precioUnitario MONEY,
    @cantidad INT,
    @descuento FLOAT,
    @idPedido INT OUTPUT
AS
BEGIN
    INSERT INTO pedido_Callanaupa_Portal_Sandro_4681 (idCliente, idEmpleado)
    VALUES (@idCliente, @idEmpleado);

    SET @idPedido = SCOPE_IDENTITY();

    INSERT INTO detallePedido_Callanaupa_Portal_Sandro_4681 (
        idPedido, idProducto, precioUnitario, cantidad, descuento)
    VALUES (
        @idPedido, @idProducto, @precioUnitario, @cantidad, @descuento);
END;

DECLARE @idCliente INT;
EXEC sp_ins_cliente_Callanaupa_Portal_Sandro_4681 'Carlos', 'Ruiz', @idCliente OUTPUT;


DECLARE @idEmpleado INT;
EXEC sp_ins_empleado_Callanaupa_Portal_Sandro_4681 'Ana', 'Rojas', @idEmpleado OUTPUT;


DECLARE @idProducto1 INT, @idProducto2 INT;
EXEC sp_ins_producto_Callanaupa_Portal_Sandro_4681 'Mouse', 'Mouse óptico', @idProducto1 OUTPUT;
EXEC sp_ins_producto_Callanaupa_Portal_Sandro_4681 'Teclado', 'Teclado mecánico', @idProducto2 OUTPUT;


DECLARE @idPedido1 INT, @idPedido2 INT;
EXEC sp_ins_pedidodetalle_Callanaupa_Portal_Sandro_4681 @idCliente, @idEmpleado, @idProducto1, 45.50, 2, 0.0, @idPedido1 OUTPUT;
EXEC sp_ins_pedidodetalle_Callanaupa_Portal_Sandro_4681 @idCliente, @idEmpleado, @idProducto2, 30.00, 1, 0.1, @idPedido2 OUTPUT;

SELECT 
    e.idEmpleado,
    e.nomEmpleado,
    e.apeEmpleado,
    pr.idProducto,
    pr.nomProducto,
    SUM(dp.cantidad) AS CantidadTotal
FROM pedido_Callanaupa_Portal_Sandro_4681 AS p
INNER JOIN empleado_Callanaupa_Portal_Sandro_4681 AS e
    ON p.idEmpleado = e.idEmpleado
INNER JOIN detallePedido_Callanaupa_Portal_Sandro_4681 AS dp
    ON p.idPedido = dp.idPedido
INNER JOIN producto_Callanaupa_Portal_Sandro_4681 AS pr
    ON dp.idProducto = pr.idProducto
GROUP BY 
    e.idEmpleado, e.nomEmpleado, e.apeEmpleado,
    pr.idProducto, pr.nomProducto
ORDER BY 
    e.idEmpleado, pr.idProducto;

	SELECT 
    e.idEmpleado,
    e.nomEmpleado,
    e.apeEmpleado,
    pr.idProducto,
    pr.nomProducto,
    SUM(dp.cantidad) AS CantidadTotal
FROM pedido_Callanaupa_Portal_Sandro_4681 AS p
INNER JOIN empleado_Callanaupa_Portal_Sandro_4681 AS e
    ON p.idEmpleado = e.idEmpleado
INNER JOIN detallePedido_Callanaupa_Portal_Sandro_4681 AS dp
    ON p.idPedido = dp.idPedido
INNER JOIN producto_Callanaupa_Portal_Sandro_4681 AS pr
    ON dp.idProducto = pr.idProducto
GROUP BY 
    e.idEmpleado, e.nomEmpleado, e.apeEmpleado,
    pr.idProducto, pr.nomProducto
ORDER BY 
    e.idEmpleado, pr.idProducto;

