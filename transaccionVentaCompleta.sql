-- Parámetros mínimos, simulamos una venta del client Acme, y utilizamos el email
-- En un sistema, este select de alguna manera se encontraría implícito dado que el usuario buscaría por mail o nombre del producto.
DECLARE @ClienteID  BIGINT = (SELECT ClienteID  FROM dbo.Clientes  WHERE Email='contacto+acme@demo.com');
DECLARE @ProductoID BIGINT = (SELECT ProductoID FROM dbo.Productos WHERE Nombre='Mouse óptico');

-- La cantidad de productos a comprar
DECLARE @Cantidad   DECIMAL(18,2) = 1.00;

--Hace que cualquier error antes del BEGIN TRAN cause automáticamente ROLLBACK
SET XACT_ABORT ON;

--Comeinza la tx
BEGIN TRAN;

-- Cabecera
INSERT INTO dbo.Ventas (FechaVenta, ClienteID)
VALUES (SYSDATETIME(), @ClienteID);

--Me traigo el ID de venta, NUNCA utilizar @@Identity!
DECLARE @VentaID BIGINT = CAST(SCOPE_IDENTITY() AS BIGINT);

-- Precio snapshot y detalle
DECLARE @Precio DECIMAL(14,2) = (SELECT PrecioLista FROM dbo.Productos WHERE ProductoID=@ProductoID);

INSERT INTO dbo.Detalle_Venta (VentaID, ProductoID, Cantidad, PrecioUnitario)
VALUES (@VentaID, @ProductoID, @Cantidad, @Precio);

-- Descuento de stock
UPDATE dbo.Productos
SET CantidadStock = CantidadStock - @Cantidad,
    FechaUltActual = SYSDATETIME()
WHERE ProductoID = @ProductoID;

-- Total y actualización del saldo del cliente con p*q
DECLARE @Total DECIMAL(18,2) = @Cantidad * @Precio;

--Actualizamos el saldo en Cta Cte.
UPDATE dbo.Clientes
SET SaldoCtaCte = SaldoCtaCte + @Total
WHERE ClienteID = @ClienteID;

COMMIT;

-- Resultado
SELECT @VentaID AS VentaID, @Total AS Total;