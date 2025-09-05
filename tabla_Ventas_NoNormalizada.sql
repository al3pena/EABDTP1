CREATE TABLE [dbo].[Ventas_NoNormalizada](
	[VENTA_ID] [int] NOT NULL,
	[FECHA_VENTA] [nchar](10) NULL,
	[CLIENTE_ID] [nchar](10) NULL,
	[NOMBRE_CLIENTE] [nchar](10) NULL,
	[TELEFONO_CLIENTE] [nchar](10) NULL,
	[MAIL_CLIENTE] [nchar](10) NULL,
	[PRODUCTOS] [text] NULL,
	[SUBTOTAL] [nchar](10) NULL,
	[IVA_21] [nchar](10) NULL,
	[IVA_105] [nchar](10) NULL,
	[OTROS_IMP] [nchar](10) NULL,
	[TOTAL] [nchar](10) NULL,
	[VENDEDOR_ID] [nchar](10) NULL,
	[NOMBRE_VENDEDOR] [nchar](10) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO