USE master 
GO 



CREATE TABLE CLIENTE (
  id_cliente VARCHAR(20) PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL
);


CREATE TABLE EMPLEADO (
  id_empleado VARCHAR(20) PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL
);


CREATE TABLE PRODUCTO (
  id_producto VARCHAR(20) PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  precio DECIMAL(10,2) NOT NULL CHECK (precio >= 0)
);


CREATE TABLE INGREDIENTE (
  id_ingrediente VARCHAR(20) PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL
);


CREATE TABLE PRODUCTO_INGREDIENTE (
  id_producto VARCHAR(20),
  id_ingrediente VARCHAR(20),
  cantidad VARCHAR(50) NOT NULL,
  PRIMARY KEY (id_producto, id_ingrediente),
  FOREIGN KEY (id_producto) REFERENCES PRODUCTO(id_producto),
  FOREIGN KEY (id_ingrediente) REFERENCES INGREDIENTE(id_ingrediente)
);

CREATE TABLE PEDIDO (
  id_pedido VARCHAR(20) PRIMARY KEY,
  fecha_pedido DATETIME NOT NULL,
  estado VARCHAR(50) NOT NULL,
  id_cliente VARCHAR(20),
  id_empleado VARCHAR(20),
  FOREIGN KEY (id_cliente) REFERENCES CLIENTE(id_cliente),
  FOREIGN KEY (id_empleado) REFERENCES EMPLEADO(id_empleado)
);


CREATE TABLE DETALLE_PEDIDO (
  id_detalle VARCHAR(20) PRIMARY KEY,
  id_pedido VARCHAR(20),
  id_producto VARCHAR(20),
  cantidad INT NOT NULL CHECK (cantidad > 0),
  precio_unitario DECIMAL(10,2) NOT NULL CHECK (precio_unitario >= 0),
  subtotal DECIMAL(10,2) NOT NULL CHECK (subtotal >= 0),
  FOREIGN KEY (id_pedido) REFERENCES PEDIDO(id_pedido),
  FOREIGN KEY (id_producto) REFERENCES PRODUCTO(id_producto)
);
