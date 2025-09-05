USE [dbVentas];
GO

-- Parámetros mínimos, simulamos una venta del client Acme, y utilizamos el email
-- En un sistema, este select de alguna manera se encontraría implícito dado que el usuario buscaría por mail o nombre del producto.
-- Para la pesimista, cambiamos el cliente, producto y monto.

DECLARE @ClienteID  BIGINT = (SELECT ClienteID  FROM dbo.Clientes  WHERE Email='contacto+delta@demo.com');
DECLARE @ProductoID BIGINT = (SELECT ProductoID FROM dbo.Productos WHERE Nombre='Parlante Bluetooth');
DECLARE @Cantidad   DECIMAL(18,2) = 8.00;

--Ahora necesitamos los tokens de version
DECLARE @CliVersion VARBINARY(8);
DECLARE @Precio DECIMAL(14,2);
DECLARE @ProdVer VARBINARY(8);

--Hace que cualquier error antes del BEGIN TRAN cause automáticamente ROLLBACK
SET XACT_ABORT ON;

--Comeinza la tx
BEGIN TRAN;

--################################################################################################
-- Leemos el RowVer sin bloquear, como una lectura más.
SELECT @CliVersion = RowVer FROM dbo.Clientes WHERE ClienteID = @ClienteID;

SELECT @Precio = PrecioLista, @ProdVer = RowVer FROM dbo.Productos WHERE ProductoID = @ProductoID 
--################################################################################################

-- Cabecera
INSERT INTO dbo.Ventas (FechaVenta, ClienteID)
VALUES (SYSDATETIME(), @ClienteID);

--Me traigo el ID de venta, NUNCA utilizar @@Identity!
DECLARE @VentaID BIGINT = CAST(SCOPE_IDENTITY() AS BIGINT);

-- Precio snapshot y detalle
--DECLARE @Precio DECIMAL(14,2) = (SELECT PrecioLista FROM dbo.Productos WHERE ProductoID=@ProductoID);

INSERT INTO dbo.Detalle_Venta (VentaID, ProductoID, Cantidad, PrecioUnitario)
VALUES (@VentaID, @ProductoID, @Cantidad, @Precio);

-- Descuento de stock, pero agrego el AND para ver si la versión coincide.
UPDATE dbo.Productos
SET CantidadStock = CantidadStock - @Cantidad,
    FechaUltActual = SYSDATETIME()
WHERE ProductoID = @ProductoID AND RowVer = @ProdVer

IF @@ROWCOUNT <> 1
BEGIN
    ROLLBACK;
    THROW 99001, 'RowVer cambió Producto!!!!', 1;
END

-- Total y actualización del saldo del cliente con p*q
DECLARE @Total DECIMAL(18,2) = @Cantidad * @Precio;

--Actualizamos el saldo en Cta Cte.
UPDATE dbo.Clientes
SET SaldoCtaCte = SaldoCtaCte + @Total
WHERE ClienteID = @ClienteID AND RowVer = @CliVersion;

IF @@ROWCOUNT <> 1
BEGIN
    ROLLBACK;
    THROW 99002, 'RowVer cambió!! Cliente!!', 1;
END

COMMIT;

-- Resultado
SELECT @VentaID AS VentaID, @Total AS Total;