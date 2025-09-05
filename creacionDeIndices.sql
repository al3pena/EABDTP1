-- Creamos un índice NONCLUSTERED UX para búsqueda de clientes por mail.
CREATE UNIQUE NONCLUSTERED INDEX UX_Clientes_Email ON dbo.Clientes (Email);

-- Índice para búsquedas por prefijo "LIKE y % --> 'Ale%' "
CREATE NONCLUSTERED INDEX IX_Clientes_Nombre ON dbo.Clientes (Nombre);

--Autocompletar por nombre, devolviendo precio y stock
CREATE NONCLUSTERED INDEX IX_Productos_Nombre_Cover ON dbo.Productos (Nombre)  INCLUDE (PrecioLista, CantidadStock);

--Listar ventas de un cliente dado un rango de fechas
CREATE NONCLUSTERED INDEX IX_Ventas_Cliente_Fecha on dbo.Ventas INCLUDE (VentaID);

--Consultas centradas en el producto con un join con Ventas.
CREATE NONCLUSTERED INDEX IX_Detalle_Productos_Cover ON dbo.Detalle_Venta (ProductoID) INCLUDE (VentaID, Cantidad, PrecioUnitario);