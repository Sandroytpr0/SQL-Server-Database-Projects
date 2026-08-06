
CREATE DATABASE Callanaupa_Portal_Sandro_4681_PA4;
GO

USE Callanaupa_Portal_Sandro_4681_PA4;
GO


CREATE TABLE cliente_Callanaupa_Portal_Sandro_4681_PA4 (
    idCliente INT IDENTITY(1,1) PRIMARY KEY,
    nomCliente VARCHAR(50),
    apeCliente VARCHAR(50)
);
GO


CREATE TABLE empleado_Callanaupa_Portal_Sandro_4681_PA4 (
    idEmpleado INT IDENTITY(1,1) PRIMARY KEY,
    nomEmpleado VARCHAR(50),
    apeEmpleado VARCHAR(50)
);
GO


CREATE TABLE producto_Callanaupa_Portal_Sandro_4681_PA4 (
    idProducto INT IDENTITY(1,1) PRIMARY KEY,
    nomProducto VARCHAR(50),
    descProducto VARCHAR(200)
);
GO

CREATE TABLE pedido_Callanaupa_Portal_Sandro_4681_PA4 (
    idPedido INT IDENTITY(1,1) PRIMARY KEY,
    fechaPedido DATETIME DEFAULT GETDATE(),
    idCliente INT,
    idEmpleado INT,
    FOREIGN KEY (idCliente) REFERENCES cliente_Callanaupa_Portal_Sandro_4681_PA4(idCliente),
    FOREIGN KEY (idEmpleado) REFERENCES empleado_Callanaupa_Portal_Sandro_4681_PA4(idEmpleado)
);
GO


CREATE TABLE detallePedido_Callanaupa_Portal_Sandro_4681_PA4 (
    idPedido INT,
    idProducto INT,
    precioUnitario MONEY,
    cantidad INT,
    descuento FLOAT,
    PRIMARY KEY (idPedido, idProducto),
    FOREIGN KEY (idPedido) REFERENCES pedido_Callanaupa_Portal_Sandro_4681_PA4(idPedido),
    FOREIGN KEY (idProducto) REFERENCES producto_Callanaupa_Portal_Sandro_4681_PA4(idProducto)
);
GO

CREATE TABLE pedido_Audit_Callanaupa_Portal_Sandro_4681_PA4 (
    OrderID INT,
    Action VARCHAR(100),
    idCliente INT,
    idEmpleado INT,
    AuditDate DATETIME,
    total MONEY
);
GO


CREATE TRIGGER trg_PedidoInsert_Callanaupa_Portal_Sandro_4681_PA4
ON pedido_Callanaupa_Portal_Sandro_4681_PA4
AFTER INSERT
AS
BEGIN
    INSERT INTO pedido_Audit_Callanaupa_Portal_Sandro_4681_PA4 (
        OrderID, Action, idCliente, idEmpleado, AuditDate, total
    )
    SELECT 
        i.idPedido,
        'INSERT realizado en tabla pedido',
        i.idCliente,
        i.idEmpleado,
        GETDATE(),
        NULL
    FROM inserted i;
END;
GO

INSERT INTO cliente_Callanaupa_Portal_Sandro_4681_PA4 (nomCliente, apeCliente)
VALUES ('Luis', 'Ramos');

INSERT INTO empleado_Callanaupa_Portal_Sandro_4681_PA4 (nomEmpleado, apeEmpleado)
VALUES ('Ana', 'Vargas');

INSERT INTO pedido_Callanaupa_Portal_Sandro_4681_PA4 (idCliente, idEmpleado)
VALUES (1, 1);

SELECT * FROM pedido_Audit_Callanaupa_Portal_Sandro_4681_PA4;

USE Callanaupa_Portal_Sandro_4681_PA4;
GO


IF OBJECT_ID('sp_ins_pedidodetalle_Callanaupa_Portal_Sandro_4681_PA4', 'P') IS NOT NULL
    DROP PROCEDURE sp_ins_pedidodetalle_Callanaupa_Portal_Sandro_4681_PA4;
GO


CREATE PROCEDURE sp_ins_pedidodetalle_Callanaupa_Portal_Sandro_4681_PA4
    @idCliente INT,
    @idEmpleado INT,
    @idProducto INT,
    @precioUnitario MONEY,
    @cantidad INT,
    @descuento FLOAT,
    @nuevoIdPedido INT OUTPUT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

       
        INSERT INTO pedido_Callanaupa_Portal_Sandro_4681_PA4 (idCliente, idEmpleado)
        VALUES (@idCliente, @idEmpleado);

  
        SET @nuevoIdPedido = SCOPE_IDENTITY();

     
        INSERT INTO detallePedido_Callanaupa_Portal_Sandro_4681_PA4 (
            idPedido, idProducto, precioUnitario, cantidad, descuento
        )
        VALUES (
            @nuevoIdPedido, @idProducto, @precioUnitario, @cantidad, @descuento
        );

        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;

        DECLARE @ErrorMessage NVARCHAR(4000);
        SET @ErrorMessage = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO

INSERT INTO cliente_Callanaupa_Portal_Sandro_4681_PA4 (nomCliente, apeCliente)
VALUES ('Carlos', 'Mendoza');


INSERT INTO empleado_Callanaupa_Portal_Sandro_4681_PA4 (nomEmpleado, apeEmpleado)
VALUES ('Maria', 'Gonzales');


INSERT INTO producto_Callanaupa_Portal_Sandro_4681_PA4 (nomProducto, descProducto)
VALUES ('Laptop Lenovo', 'Laptop de oficina 14 pulgadas');

DECLARE @nuevoID INT;

EXEC sp_ins_pedidodetalle_Callanaupa_Portal_Sandro_4681_PA4
    @idCliente = 2,
    @idEmpleado = 2,
    @idProducto = 1,
    @precioUnitario = 2500.00,
    @cantidad = 1,
    @descuento = 0.05,
    @nuevoIdPedido = @nuevoID OUTPUT;

SELECT 'Nuevo ID Pedido' AS Resultado, @nuevoID AS ID;

SELECT * FROM pedido_Callanaupa_Portal_Sandro_4681_PA4;
SELECT * FROM detallePedido_Callanaupa_Portal_Sandro_4681_PA4;

USE Callanaupa_Portal_Sandro_4681_PA4;
GO


IF OBJECT_ID('OrderCursor_Callanaupa_Portal_Sandro_4681_PA4', 'P') IS NOT NULL
    DROP PROCEDURE OrderCursor_Callanaupa_Portal_Sandro_4681_PA4;
GO


CREATE PROCEDURE OrderCursor_Callanaupa_Portal_Sandro_4681_PA4
    @idProducto INT
AS
BEGIN
    DECLARE 
        @idPedido INT,
        @precioUnitario MONEY,
        @cantidad INT,
        @descuento FLOAT,
        @total MONEY;

    DECLARE order_cursor CURSOR FOR
    SELECT idPedido, precioUnitario, cantidad, descuento
    FROM detallePedido_Callanaupa_Portal_Sandro_4681_PA4
    WHERE idProducto = @idProducto;

    OPEN order_cursor;

    FETCH NEXT FROM order_cursor INTO @idPedido, @precioUnitario, @cantidad, @descuento;

    WHILE @@FETCH_STATUS = 0
    BEGIN

        SET @total = @precioUnitario * @cantidad * (1 - @descuento);

        
        UPDATE pedido_Audit_Callanaupa_Portal_Sandro_4681_PA4
        SET total = @total
        WHERE OrderID = @idPedido;

        FETCH NEXT FROM order_cursor INTO @idPedido, @precioUnitario, @cantidad, @descuento;
    END

    CLOSE order_cursor;
    DEALLOCATE order_cursor;
END;
GO

EXEC OrderCursor_Callanaupa_Portal_Sandro_4681_PA4 @idProducto = 1;
SELECT * FROM pedido_Audit_Callanaupa_Portal_Sandro_4681_PA4;
