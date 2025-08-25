--
-- Base de datos: `sistema_ventas_tgs`
--
CREATE DATABASE IF NOT EXISTS `sistema_ventas_tgs` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `sistema_ventas_tgs`;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--
CREATE TABLE `usuarios` (
  `id_usuario` INT(11) NOT NULL AUTO_INCREMENT,
  `dni` VARCHAR(8) NOT NULL UNIQUE,
  `nombre` VARCHAR(100) NOT NULL,
  `usuario` VARCHAR(50) NOT NULL UNIQUE,
  `contrasena` VARCHAR(255) NOT NULL,
  `id_rol` INT(11) NOT NULL,
  `estado` TINYINT(1) DEFAULT 1, -- 1 activo, 0 inactivo
  `fecha_creacion` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_usuario`),
  KEY `id_rol` (`id_rol`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Estructura de tabla para la tabla `roles`
--
CREATE TABLE `roles` (
  `id_rol` INT(11) NOT NULL AUTO_INCREMENT,
  `nombre_rol` VARCHAR(50) NOT NULL UNIQUE,
  `descripcion` TEXT,
  PRIMARY KEY (`id_rol`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Estructura de tabla para la tabla `permisos`
--
CREATE TABLE `permisos` (
  `id_permiso` INT(11) NOT NULL AUTO_INCREMENT,
  `nombre_permiso` VARCHAR(100) NOT NULL UNIQUE,
  `descripcion` TEXT,
  PRIMARY KEY (`id_permiso`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Estructura de tabla para la tabla `rol_permiso`
--
CREATE TABLE `rol_permiso` (
  `id_rol_permiso` INT(11) NOT NULL AUTO_INCREMENT,
  `id_rol` INT(11) NOT NULL,
  `id_permiso` INT(11) NOT NULL,
  `puede_ver` TINYINT(1) DEFAULT 0,
  `puede_crear` TINYINT(1) DEFAULT 0,
  `puede_editar` TINYINT(1) DEFAULT 0,
  `puede_eliminar` TINYINT(1) DEFAULT 0,
  PRIMARY KEY (`id_rol_permiso`),
  UNIQUE KEY `idx_rol_permiso_unique` (`id_rol`, `id_permiso`),
  KEY `id_permiso` (`id_permiso`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categorias`
--
CREATE TABLE `categorias` (
  `id_categoria` INT(11) NOT NULL AUTO_INCREMENT,
  `nombre_categoria` VARCHAR(100) NOT NULL UNIQUE,
  `descripcion` TEXT,
  `fecha_creacion` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_categoria`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Estructura de tabla para la tabla `marcas`
--
CREATE TABLE `marcas` (
  `id_marca` INT(11) NOT NULL AUTO_INCREMENT,
  `nombre_marca` VARCHAR(100) NOT NULL UNIQUE,
  `descripcion` TEXT,
  `fecha_creacion` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_marca`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Estructura de tabla para la tabla `productos`
--
CREATE TABLE `productos` (
  `id_producto` INT(11) NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(255) NOT NULL,
  `descripcion` TEXT,
  `id_categoria` INT(11) NOT NULL,
  `id_marca` INT(11) DEFAULT NULL,
  `precio_costo` DECIMAL(10,2) NOT NULL,
  `precio_venta` DECIMAL(10,2) NOT NULL,
  `precio_mayorista` DECIMAL(10,2) DEFAULT NULL,
  `codigo_barras` VARCHAR(50) UNIQUE,
  `estado` TINYINT(1) DEFAULT 1, -- 1 activo, 0 inactivo
  `usuario_creacion` INT(11) DEFAULT NULL,
  `usuario_actualizacion` INT(11) DEFAULT NULL,
  `fecha_creacion` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_producto`),
  UNIQUE KEY `nombre_producto_unique` (`nombre`),
  KEY `id_categoria` (`id_categoria`),
  KEY `id_marca` (`id_marca`),
  KEY `usuario_creacion` (`usuario_creacion`),
  KEY `usuario_actualizacion` (`usuario_actualizacion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `almacenes`
--
CREATE TABLE `almacenes` (
  `id_almacen` INT(11) NOT NULL AUTO_INCREMENT,
  `nombre_almacen` VARCHAR(100) NOT NULL UNIQUE,
  `direccion` VARCHAR(255),
  `fecha_creacion` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_almacen`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Estructura de tabla para la tabla `stock`
--
CREATE TABLE `stock` (
  `id_stock` INT(11) NOT NULL AUTO_INCREMENT,
  `id_producto` INT(11) NOT NULL,
  `id_almacen` INT(11) NOT NULL,
  `cantidad` INT(11) NOT NULL DEFAULT 0,
  `fecha_actualizacion` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_stock`),
  UNIQUE KEY `idx_producto_almacen_unique` (`id_producto`, `id_almacen`),
  KEY `id_almacen` (`id_almacen`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Estructura de tabla para la tabla `movimientos_inventario`
--
CREATE TABLE `movimientos_inventario` (
  `id_movimiento` INT(11) NOT NULL AUTO_INCREMENT,
  `id_producto` INT(11) NOT NULL,
  `id_almacen` INT(11) NOT NULL,
  `tipo_movimiento` ENUM('entrada', 'salida', 'transferencia') NOT NULL,
  `cantidad` INT(11) NOT NULL,
  `stock_resultante` INT(11) NOT NULL,
  `referencia_documento` VARCHAR(100) DEFAULT NULL, -- Ej: Compra #123, Devolución #456
  `usuario_responsable` INT(11) NOT NULL,
  `fecha_movimiento` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `observaciones` TEXT,
  PRIMARY KEY (`id_movimiento`),
  KEY `id_producto` (`id_producto`),
  KEY `id_almacen` (`id_almacen`),
  KEY `usuario_responsable` (`usuario_responsable`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes`
--
CREATE TABLE `clientes` (
  `id_cliente` INT(11) NOT NULL AUTO_INCREMENT,
  `dni` VARCHAR(8) NOT NULL UNIQUE,
  `nombre` VARCHAR(100) NOT NULL,
  `telefono` VARCHAR(20) DEFAULT NULL,
  `correo` VARCHAR(100) UNIQUE,
  `direccion` VARCHAR(255) DEFAULT NULL,
  `fecha_creacion` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_cliente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Estructura de tabla para la tabla `ventas`
--
CREATE TABLE `ventas` (
  `id_venta` INT(11) NOT NULL AUTO_INCREMENT,
  `id_cliente` INT(11) DEFAULT NULL,
  `id_usuario` INT(11) NOT NULL, -- Cajero que realizó la venta
  `tipo_comprobante` ENUM('boleta', 'factura', 'ticket') NOT NULL,
  `serie_comprobante` VARCHAR(10) DEFAULT NULL,
  `numero_comprobante` VARCHAR(20) DEFAULT NULL,
  `total_bruto` DECIMAL(10,2) NOT NULL,
  `descuento_total` DECIMAL(10,2) DEFAULT 0.00,
  `impuesto_total` DECIMAL(10,2) DEFAULT 0.00,
  `total_neto` DECIMAL(10,2) NOT NULL,
  `metodo_pago` VARCHAR(100) NOT NULL, -- Ej: Efectivo, Tarjeta, Yape, Plin, Mixto
  `monto_efectivo` DECIMAL(10,2) DEFAULT 0.00,
  `cambio` DECIMAL(10,2) DEFAULT 0.00,
  `fecha_venta` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `estado` ENUM('completada', 'anulada') DEFAULT 'completada',
  PRIMARY KEY (`id_venta`),
  KEY `id_cliente` (`id_cliente`),
  KEY `id_usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Estructura de tabla para la tabla `detalle_venta`
--
CREATE TABLE `detalle_venta` (
  `id_detalle_venta` INT(11) NOT NULL AUTO_INCREMENT,
  `id_venta` INT(11) NOT NULL,
  `id_producto` INT(11) NOT NULL,
  `cantidad` INT(11) NOT NULL,
  `precio_unitario` DECIMAL(10,2) NOT NULL,
  `descuento_item` DECIMAL(10,2) DEFAULT 0.00,
  `subtotal` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`id_detalle_venta`),
  UNIQUE KEY `idx_venta_producto_unique` (`id_venta`, `id_producto`),
  KEY `id_producto` (`id_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedores`
--
CREATE TABLE `proveedores` (
  `id_proveedor` INT(11) NOT NULL AUTO_INCREMENT,
  `ruc_dni` VARCHAR(11) NOT NULL UNIQUE,
  `razon_social` VARCHAR(255) NOT NULL,
  `contacto` VARCHAR(100) DEFAULT NULL,
  `telefono` VARCHAR(20) DEFAULT NULL,
  `correo` VARCHAR(100) UNIQUE,
  `direccion` VARCHAR(255) DEFAULT NULL,
  `fecha_creacion` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_proveedor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Estructura de tabla para la tabla `ordenes_compra`
--
CREATE TABLE `ordenes_compra` (
  `id_orden_compra` INT(11) NOT NULL AUTO_INCREMENT,
  `id_proveedor` INT(11) NOT NULL,
  `id_usuario` INT(11) NOT NULL, -- Usuario que crea la OC
  `fecha_orden` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `fecha_esperada_recepcion` DATE,
  `estado` ENUM('pendiente', 'recibida_parcial', 'recibida_total', 'cancelada') DEFAULT 'pendiente',
  `total_orden` DECIMAL(10,2) NOT NULL,
  `observaciones` TEXT,
  PRIMARY KEY (`id_orden_compra`),
  KEY `id_proveedor` (`id_proveedor`),
  KEY `id_usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Estructura de tabla para la tabla `detalle_orden_compra`
--
CREATE TABLE `detalle_orden_compra` (
  `id_detalle_oc` INT(11) NOT NULL AUTO_INCREMENT,
  `id_orden_compra` INT(11) NOT NULL,
  `id_producto` INT(11) NOT NULL,
  `cantidad_pedida` INT(11) NOT NULL,
  `cantidad_recibida` INT(11) DEFAULT 0,
  `costo_unitario` DECIMAL(10,2) NOT NULL,
  `subtotal` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`id_detalle_oc`),
  UNIQUE KEY `idx_orden_producto_unique` (`id_orden_compra`, `id_producto`),
  KEY `id_producto` (`id_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Estructura de tabla para la tabla `comprobantes_compra`
--
CREATE TABLE `comprobantes_compra` (
  `id_comprobante_compra` INT(11) NOT NULL AUTO_INCREMENT,
  `id_proveedor` INT(11) NOT NULL,
  `id_orden_compra` INT(11) DEFAULT NULL,
  `tipo_comprobante` ENUM('factura', 'boleta', 'ticket') NOT NULL,
  `serie_comprobante` VARCHAR(10) DEFAULT NULL,
  `numero_comprobante` VARCHAR(20) NOT NULL UNIQUE,
  `fecha_emision` DATE NOT NULL,
  `fecha_recepcion` DATE DEFAULT CURRENT_TIMESTAMP,
  `total_compra` DECIMAL(10,2) NOT NULL,
  `igv` DECIMAL(10,2) DEFAULT 0.00,
  `monto_pagado` DECIMAL(10,2) DEFAULT 0.00,
  `saldo_pendiente` DECIMAL(10,2) DEFAULT 0.00,
  `estado_pago` ENUM('pagado', 'parcial', 'pendiente') DEFAULT 'pendiente',
  `fecha_vencimiento` DATE,
  `usuario_registro` INT(11) NOT NULL,
  `fecha_registro` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_comprobante_compra`),
  KEY `id_proveedor` (`id_proveedor`),
  KEY `id_orden_compra` (`id_orden_compra`),
  KEY `usuario_registro` (`usuario_registro`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `gastos`
--
CREATE TABLE `gastos` (
  `id_gasto` INT(11) NOT NULL AUTO_INCREMENT,
  `categoria_gasto` ENUM('fijo', 'operativo', 'otro') NOT NULL,
  `descripcion` VARCHAR(255) NOT NULL,
  `monto` DECIMAL(10,2) NOT NULL,
  `fecha_gasto` DATE NOT NULL,
  `forma_pago` VARCHAR(50) DEFAULT NULL,
  `id_proveedor` INT(11) DEFAULT NULL,
  `comprobante_adjunto` VARCHAR(255) DEFAULT NULL, -- Ruta o nombre del archivo
  `usuario_registro` INT(11) NOT NULL,
  `fecha_registro` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `estado` ENUM('registrado', 'anulado') DEFAULT 'registrado',
  `motivo_anulacion` TEXT,
  PRIMARY KEY (`id_gasto`),
  KEY `id_proveedor` (`id_proveedor`),
  KEY `usuario_registro` (`usuario_registro`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `fk_usuario_rol` FOREIGN KEY (`id_rol`) REFERENCES `roles` (`id_rol`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Filtros para la tabla `rol_permiso`
--
ALTER TABLE `rol_permiso`
  ADD CONSTRAINT `fk_rp_permiso` FOREIGN KEY (`id_permiso`) REFERENCES `permisos` (`id_permiso`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_rp_rol` FOREIGN KEY (`id_rol`) REFERENCES `roles` (`id_rol`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `productos`
--
ALTER TABLE `productos`
  ADD CONSTRAINT `fk_producto_categoria` FOREIGN KEY (`id_categoria`) REFERENCES `categorias` (`id_categoria`) ON DELETE RESTRICT ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_producto_marca` FOREIGN KEY (`id_marca`) REFERENCES `marcas` (`id_marca`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_producto_usuario_actualizacion` FOREIGN KEY (`usuario_actualizacion`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_producto_usuario_creacion` FOREIGN KEY (`usuario_creacion`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `stock`
--
ALTER TABLE `stock`
  ADD CONSTRAINT `fk_stock_almacen` FOREIGN KEY (`id_almacen`) REFERENCES `almacenes` (`id_almacen`) ON DELETE RESTRICT ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_stock_producto` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `movimientos_inventario`
--
ALTER TABLE `movimientos_inventario`
  ADD CONSTRAINT `fk_mov_almacen` FOREIGN KEY (`id_almacen`) REFERENCES `almacenes` (`id_almacen`) ON DELETE RESTRICT ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_mov_producto` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`) ON DELETE RESTRICT ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_mov_usuario` FOREIGN KEY (`usuario_responsable`) REFERENCES `usuarios` (`id_usuario`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Filtros para la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD CONSTRAINT `fk_venta_cliente` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_venta_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Filtros para la tabla `detalle_venta`
--
ALTER TABLE `detalle_venta`
  ADD CONSTRAINT `fk_detalle_producto` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`) ON DELETE RESTRICT ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detalle_venta` FOREIGN KEY (`id_venta`) REFERENCES `ventas` (`id_venta`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `ordenes_compra`
--
ALTER TABLE `ordenes_compra`
  ADD CONSTRAINT `fk_oc_proveedor` FOREIGN KEY (`id_proveedor`) REFERENCES `proveedores` (`id_proveedor`) ON DELETE RESTRICT ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_oc_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Filtros para la tabla `detalle_orden_compra`
--
ALTER TABLE `detalle_orden_compra`
  ADD CONSTRAINT `fk_doc_orden` FOREIGN KEY (`id_orden_compra`) REFERENCES `ordenes_compra` (`id_orden_compra`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_doc_producto` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Filtros para la tabla `comprobantes_compra`
--
ALTER TABLE `comprobantes_compra`
  ADD CONSTRAINT `fk_cc_orden_compra` FOREIGN KEY (`id_orden_compra`) REFERENCES `ordenes_compra` (`id_orden_compra`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_cc_proveedor` FOREIGN KEY (`id_proveedor`) REFERENCES `proveedores` (`id_proveedor`) ON DELETE RESTRICT ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_cc_usuario_registro` FOREIGN KEY (`usuario_registro`) REFERENCES `usuarios` (`id_usuario`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Filtros para la tabla `gastos`
--
ALTER TABLE `gastos`
  ADD CONSTRAINT `fk_gasto_proveedor` FOREIGN KEY (`id_proveedor`) REFERENCES `proveedores` (`id_proveedor`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_gasto_usuario` FOREIGN KEY (`usuario_registro`) REFERENCES `usuarios` (`id_usuario`) ON DELETE RESTRICT ON UPDATE CASCADE;
