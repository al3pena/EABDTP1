USE [dbVentas];
GO

-- Parámetros mínimos, simulamos una venta del client Acme, y utilizamos el email
-- En un sistema, este select de alguna manera se encontraría implícito dado que el usuario buscaría por mail o nombre del producto.
-- Para la pesimista, cambiamos el cliente, producto y monto.

DECLARE @ClienteID  BIGINT = (SELECT ClienteID  FROM dbo.Clientes  WHERE Email='contacto+delta@demo.com');
DECLARE @ProductoID BIGINT = (SELECT ProductoID FROM dbo.Productos WHERE Nombre='Parlante Bluetooth');
DECLARE @Cantidad   DECIMAL(18,2) = 8.00;

--Hace que cualquier error antes del BEGIN TRAN cause automáticamente ROLLBACK
SET XACT_ABORT ON;

--Comeinza la tx
BEGIN TRAN;

-- ===== Concurrencia pesimista (FOR UPDATE) =====
-- Bloquea la fila del cliente para la posterior actualización del saldo
-- Usamos UPDLOCK para bloquear la fila, y HOLD para mantenerlo hasta que commitee la TX
SELECT 1
FROM dbo.Clientes WITH (UPDLOCK, HOLDLOCK)
WHERE ClienteID = @ClienteID;

-- Tomamos el precio y bloquea la fila del producto para el posterior descuento de stock
DECLARE @Precio DECIMAL(14,2);
SELECT @Precio = PrecioLista
FROM dbo.Productos WITH (UPDLOCK, HOLDLOCK)
WHERE ProductoID = @ProductoID;
-- =============================================================


-- Cabecera
INSERT INTO dbo.Ventas (FechaVenta, ClienteID)
VALUES (SYSDATETIME(), @ClienteID);

--Me traigo el ID de venta, NUNCA utilizar @@Identity!
DECLARE @VentaID BIGINT = CAST(SCOPE_IDENTITY() AS BIGINT);

-- Precio snapshot y detalle
--DECLARE @Precio DECIMAL(14,2) = (SELECT PrecioLista FROM dbo.Productos WHERE ProductoID=@ProductoID);

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