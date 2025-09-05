DECLARE @d1 date = '2024-08-01', @d2 date = '2026-09-01';

SELECT TOP (10)
  d.ProductoID,
  SUM(d.Cantidad)   AS Unidades,
  SUM(d.Cantidad*d.PrecioUnitario) AS Importe
FROM dbo.Ventas v
JOIN dbo.Detalle_Venta d ON d.VentaID = v.VentaID
WHERE v.FechaVenta >= @d1 AND v.FechaVenta < @d2
GROUP BY d.ProductoID
ORDER BY Importe DESC
OPTION (RECOMPILE);