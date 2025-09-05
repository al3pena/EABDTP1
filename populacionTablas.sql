USE [dbVentas];
GO;


INSERT INTO dbo.Clientes (Nombre, Email, Direccion, Contacto, SaldoCtaCte, CreditoMaximo)
VALUES
  ('Acme S.A.',           'contacto+acme@demo.com',     'Av. Siempre Viva 123',   'María Pérez',     0.00,   100000.00),
  ('Beta SRL',            'contacto+beta@demo.com',     'Calle 9 de Julio 456',   'Juan Gómez',      0.00,   250000.00),
  ('Gamma Tech',          'contacto+gamma@demo.com',    'Av. Belgrano 1500',      'Sofía Ruiz',      0.00,   500000.00),
  ('Delta Soft',          'contacto+delta@demo.com',    'Córdoba 2330',           'Pablo López',     0.00,   300000.00),
  ('Epsilon Labs',        'contacto+epsilon@demo.com',  'San Martín 800',         'Lucía Torres',    0.00,   150000.00),
  ('Fénix Digital',       'contacto+fenix@demo.com',    'Av. Rivadavia 12000',    'Diego Romero',    0.00,   900000.00),
  ('Helios Systems',      'contacto+helios@demo.com',   'Av. de Mayo 350',        'Carla Díaz',      0.00,   200000.00),
  ('Ícaro Networks',      'contacto+icaro@demo.com',    'Paraguay 2100',          'Nicolás Herrera', 0.00,   750000.00),
  ('Juno Data',           'contacto+juno@demo.com',     'Uruguay 320',            'Valentina Paz',   0.00,   400000.00),
  ('Kronos Analytics',    'contacto+kronos@demo.com',   'Alsina 980',             'Martín Castro',   0.00,  1200000.00);
GO

-- PRODUCTOS (5 filas)
INSERT INTO dbo.Productos (Nombre, PrecioLista, CantidadStock, FechaUltActual)
VALUES
  ('Mouse óptico',        3500.00,    80, SYSDATETIME()),
  ('Teclado mecánico',   22000.00,    40, SYSDATETIME()),
  ('Monitor 24"',       150000.00,    25, SYSDATETIME()),
  ('Notebook 14"',      850000.00,    10, SYSDATETIME()),
  ('Parlante Bluetooth', 45000.00,    60, SYSDATETIME());
GO