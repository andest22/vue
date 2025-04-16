-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 16-04-2025 a las 22:56:39
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `crud-php-app`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_role_module` (IN `idRole` INT)   BEGIN
SELECT ROL.role_name AS `role_fk`,MD.module_name AS `role_module`,MD.module_icon,MD.module_description, MD.module_route FROM role_module AS RM 
INNER JOIN role AS ROL ON RM.role_fk=ROL.role_id
INNER JOIN module AS MD ON RM.module_fk=MD.module_id
WHERE ROL.role_id=idRole;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_user_all` ()   BEGIN
SELECT `user_email`, `user_id`,`full_name`,`user_password`, UST.userStatus_name AS `userStatus_fk`, ROL.role_name AS `role_fk` FROM `user` AS US  
INNER JOIN role AS ROL ON US.role_fk=ROL.role_id
INNER JOIN userstatus AS UST  ON US.userStatus_fk=UST.userStatus_id
WHERE US.userStatus_fk=1
;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_user_all_paginated` (IN `offset` INT, IN `limit_rows` INT)   BEGIN
    SET @query = CONCAT('SELECT * FROM user LIMIT ', offset, ', ', limit_rows);
    PREPARE stmt FROM @query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_user_count` ()   BEGIN
    SELECT COUNT(*) AS total_users 
    FROM user;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_user_create` (IN `p_user_email` VARCHAR(100), IN `p_user_password` VARCHAR(255), IN `p_full_name` VARCHAR(100), IN `p_userStatus_fk` VARCHAR(20), IN `p_role_fk` INT)   BEGIN
-- Si no se pasa el estado, se asigna el valor predeterminado 'activo'
    IF p_userStatus_fk IS NULL THEN
        SET p_userStatus_fk = 1;
    END IF;
    -- Si no se pasa el rol, se asigna el valor predeterminado 1
    IF p_role_fk IS NULL THEN
        SET p_role_fk = 3;
    END IF;

    -- Inserta el nuevo usuario con los valores proporcionados o los predeterminados
    INSERT INTO user (
         user_email, user_password, full_name, userStatus_fk, role_fk 
    ) 
    VALUES (
        
        p_user_email, 
        p_user_password, 
        p_full_name, 
        p_userStatus_fk,    -- Estado (si es NULL, se asigna 'activo')
        p_role_fk  -- Rol (si es NULL, se asigna 1)
        
    );
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_user_search` (IN `dataSearch` VARCHAR(60))   BEGIN
SELECT `user_id`,`user_email`,`user_password`, UST.userStatus_name AS `userStatus_fk`, ROL.role_name AS `role_fk` FROM `user` AS US  
INNER JOIN role AS ROL ON US.role_fk=ROL.role_id
INNER JOIN userstatus AS UST  ON US.userStatus_fk=UST.userStatus_id 
WHERE ROL.role_name=dataSearch OR UST.userStatus_name=dataSearch OR US.user_email=dataSearch;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `category_product`
--

CREATE TABLE `category_product` (
  `id_category` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `category_product`
--

INSERT INTO `category_product` (`id_category`, `name`) VALUES
(1, 'Cortes de Cabello'),
(2, 'Afeitado'),
(3, 'Tintes y Coloración'),
(4, 'Tratamientos Capilares'),
(5, 'Productos de Estilo');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `category_services`
--

CREATE TABLE `category_services` (
  `id_category_services` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `category_services`
--

INSERT INTO `category_services` (`id_category_services`, `name`) VALUES
(1, 'Cortes'),
(2, 'Barba'),
(3, 'Cejas'),
(4, 'Tintes'),
(5, 'Combos');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `document_type`
--

CREATE TABLE `document_type` (
  `id_doctypes` int(11) NOT NULL,
  `doctype_name` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `document_type`
--

INSERT INTO `document_type` (`id_doctypes`, `doctype_name`) VALUES
(1, 'Cedula de ciudadania'),
(2, 'Tarjeta de identidad'),
(3, 'Cedula de extranjeria');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `facture`
--

CREATE TABLE `facture` (
  `id_facture` int(11) NOT NULL,
  `date` date NOT NULL,
  `total_value` float NOT NULL,
  `user_fk` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `facture`
--

INSERT INTO `facture` (`id_facture`, `date`, `total_value`, `user_fk`) VALUES
(1, '2024-12-03', 150.75, 1),
(2, '2024-12-03', 180.75, 1),
(3, '2024-12-03', 160.75, 1),
(4, '2024-12-04', 250, 1),
(5, '2024-12-04', 350, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `module`
--

CREATE TABLE `module` (
  `module_id` int(11) NOT NULL,
  `module_name` varchar(20) NOT NULL,
  `module_route` varchar(20) NOT NULL,
  `module_icon` varchar(40) NOT NULL,
  `module_description` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `module`
--

INSERT INTO `module` (`module_id`, `module_name`, `module_route`, `module_icon`, `module_description`) VALUES
(1, 'Home', 'home/home', '<i class=\"bi bi-house-fill\"></i>', 'This is module home'),
(2, 'User', 'user/index', '<i class=\"bi bi-person-badge-fill\"></i>', 'This is module user'),
(3, 'Servicio', 'services/index', '<i class=\"bi bi-clipboard-check\"></i>', 'This is module facture');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `product`
--

CREATE TABLE `product` (
  `id_product` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `price` float NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `amount` int(11) NOT NULL,
  `id_category` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `product`
--

INSERT INTO `product` (`id_product`, `name`, `price`, `description`, `amount`, `id_category`) VALUES
(1, 'Corte Clásico', 15, 'Corte de cabello tradicional', 10, 1),
(2, 'Afeitado Tradicional', 10, 'Afeitado con navaja y toalla caliente', 15, 2),
(3, 'Tinte para Cabello', 30, 'Tinte permanente para cabello', 5, 3),
(4, 'Tratamiento de Keratina', 50, 'Hidratación profunda con keratina', 3, 4),
(5, 'Pomada para el Cabello', 12, 'Pomada con fijación media para peinado', 20, 5);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `product_invoice_detail`
--

CREATE TABLE `product_invoice_detail` (
  `amount` int(11) NOT NULL,
  `price` float DEFAULT NULL,
  `id_facture` int(11) NOT NULL,
  `id_product` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `product_invoice_detail`
--

INSERT INTO `product_invoice_detail` (`amount`, `price`, `id_facture`, `id_product`) VALUES
(2, 30, 1, 1),
(1, 20, 2, 2),
(3, 36, 3, 3),
(1, 18, 4, 4),
(2, 100, 5, 5);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `quotes`
--

CREATE TABLE `quotes` (
  `id_quotes` int(11) NOT NULL,
  `date_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `end_time` timestamp NOT NULL DEFAULT current_timestamp(),
  `state_quotes` varchar(50) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `barber_id` int(11) NOT NULL,
  `id_services` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `quotes`
--

INSERT INTO `quotes` (`id_quotes`, `date_time`, `end_time`, `state_quotes`, `user_id`, `barber_id`, `id_services`) VALUES
(2, '2025-05-01 06:00:00', '2025-04-14 07:39:53', 'pendiente', 2, 59, NULL),
(3, '2025-05-01 06:00:00', '2025-04-14 07:42:44', 'pendiente', 2, 59, NULL),
(4, '2025-04-20 05:00:00', '2025-04-14 07:43:55', 'pendiente', 2, 75, NULL),
(5, '2025-04-03 19:00:00', '2025-04-14 07:46:28', 'pendiente', 2, 75, NULL),
(6, '2025-04-30 18:00:00', '2025-04-14 19:39:08', 'pendiente', 2, 59, NULL),
(7, '2025-04-25 19:00:00', '2025-04-14 19:47:03', 'pendiente', 2, 59, NULL),
(8, '2025-04-26 18:00:00', '2025-04-14 19:51:34', 'pendiente', 2, 59, NULL),
(9, '2025-04-09 20:00:00', '2025-04-14 19:53:24', 'pendiente', 2, 59, NULL),
(10, '2025-04-02 18:00:00', '2025-04-14 19:55:55', 'pendiente', 2, 59, NULL),
(11, '2025-04-14 20:07:20', '2025-04-14 20:02:46', 'pendiente', 2, 59, NULL),
(12, '2025-04-10 18:00:00', '2025-04-14 20:11:30', 'pendiente', 2, 59, NULL),
(13, '2025-04-11 05:47:00', '2025-04-11 06:17:00', 'pendiente', 2, 59, NULL),
(14, '2025-04-23 19:16:00', '2025-04-23 19:46:00', 'pendiente', 2, 59, NULL),
(15, '2025-04-11 07:22:00', '2025-04-11 07:52:00', 'pendiente', 2, 59, NULL),
(16, '2025-04-10 19:20:00', '2025-04-10 19:50:00', 'pendiente', 2, 4, NULL),
(17, '2024-08-10 19:00:00', '2024-08-10 19:30:00', 'pendiente', 2, 4, NULL),
(18, '2024-08-12 21:00:00', '2024-08-12 21:30:00', 'pendiente', 2, 4, NULL),
(19, '2025-05-23 19:00:00', '2025-05-23 19:30:00', 'pendiente', 2, 4, NULL),
(20, '2025-08-01 18:00:00', '2025-08-01 18:30:00', 'pendiente', 2, 4, NULL),
(21, '2025-12-25 00:00:00', '2025-12-25 00:30:00', 'pendiente', 2, 4, NULL),
(22, '2025-05-01 23:00:00', '2025-05-01 23:30:00', 'pendiente', 2, 4, NULL),
(23, '2025-05-01 23:00:00', '2025-05-01 23:30:00', 'pendiente', 2, 4, NULL),
(24, '2025-04-15 03:00:00', '2025-04-15 03:30:00', 'pendiente', 2, 59, NULL),
(25, '2025-04-15 03:00:00', '2025-04-15 03:30:00', 'pendiente', 2, 59, NULL),
(26, '2025-04-15 17:29:03', '2025-04-14 18:30:00', 'pendiente', 1, 59, 1),
(27, '2025-04-14 23:00:00', '2025-04-14 23:30:00', 'pendiente', 1, 59, NULL),
(28, '2025-04-14 18:00:00', '2025-04-14 18:30:00', 'pendiente', 1, 59, NULL),
(29, '2025-04-14 18:00:00', '2025-04-14 18:30:00', 'pendiente', 2, 75, NULL),
(30, '2025-04-14 23:00:00', '2025-04-14 23:30:00', 'pendiente', 2, 75, NULL),
(31, '2025-04-14 23:00:00', '2025-04-14 23:30:00', 'pendiente', 2, 75, NULL),
(32, '2025-04-14 18:00:00', '2025-04-14 18:30:00', 'pendiente', 2, 59, NULL),
(33, '2025-04-30 18:00:00', '2025-04-30 18:30:00', 'pendiente', 2, 59, NULL),
(34, '2025-04-15 18:00:00', '2025-04-15 18:30:00', 'pendiente', 2, 59, NULL),
(35, '2025-04-30 18:00:00', '2025-04-30 18:30:00', 'pendiente', 2, 75, NULL),
(36, '2025-04-30 18:00:00', '2025-04-30 18:30:00', 'pendiente', 2, 75, NULL),
(37, '2025-04-30 18:00:00', '2025-04-30 18:30:00', 'pendiente', 2, 75, NULL),
(38, '2025-05-01 03:00:00', '2025-05-01 03:30:00', 'pendiente', 2, 59, NULL),
(39, '2025-04-30 22:00:00', '2025-04-30 22:30:00', 'pendiente', 2, 59, NULL),
(40, '2025-04-23 18:00:00', '2025-04-23 18:30:00', 'pendiente', 2, 59, NULL),
(41, '2025-04-27 19:00:00', '2025-04-27 19:30:00', 'pendiente', 2, 59, NULL),
(42, '2025-04-18 18:00:00', '2025-04-18 18:30:00', 'pendiente', 2, 59, NULL),
(43, '2025-04-17 18:00:00', '2025-04-17 18:30:00', 'pendiente', 2, 75, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `role`
--

CREATE TABLE `role` (
  `role_id` int(11) NOT NULL,
  `role_name` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `role`
--

INSERT INTO `role` (`role_id`, `role_name`) VALUES
(1, 'Admin'),
(3, 'Client'),
(2, 'Employee');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `role_module`
--

CREATE TABLE `role_module` (
  `roleModule_id` int(11) NOT NULL,
  `role_fk` int(11) NOT NULL,
  `module_fk` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `role_module`
--

INSERT INTO `role_module` (`roleModule_id`, `role_fk`, `module_fk`) VALUES
(1, 1, 1),
(2, 1, 2),
(3, 2, 1),
(4, 3, 1),
(5, 1, 3);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `services`
--

CREATE TABLE `services` (
  `id_services` int(11) NOT NULL,
  `name_service` varchar(255) DEFAULT NULL,
  `description` varchar(255) NOT NULL,
  `estimated_time` time DEFAULT NULL,
  `price` float DEFAULT NULL,
  `id_category_services` int(11) NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `id_status` int(11) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `services`
--

INSERT INTO `services` (`id_services`, `name_service`, `description`, `estimated_time`, `price`, `id_category_services`, `image`, `id_status`) VALUES
(1, 'Corte Clásico', 'Corte clasico para gente wapa', '00:30:00', 15, 1, 'combo01.png', 1),
(2, 'Afeitado Tradicional', 'Afeitado tranquilon para gente wapa', '00:20:00', 10, 2, 'combo01.png', 1),
(3, 'Tinte Capilar', 'Tinte bien mamalon para gente wapa', '01:00:00', 40, 3, 'combo01.png', 1),
(4, 'Tratamiento Hidratan', 'Tratamiento que hidrata para gente wapa', '00:45:00', 25, 4, 'combo01.png', 1),
(5, 'Corte Infantil', 'Corte infantil para niños bien wapos', '00:25:00', 12, 5, 'combo01.png', 1),
(6, 'Corte Clásico', 'Un corte tradicional con estilo moderno.', '00:30:00', 150, 1, NULL, NULL),
(7, 'Clásico', ' tradicional con estilo moderno.', '00:30:00', 150, 1, NULL, NULL),
(8, 'a', 'a', '01:00:00', 1500, 3, 'barbero4.jpg', 1),
(9, 'wolfcut', 'pelo largo y de librito al frente', '01:00:00', 25000, 1, 'wolfcut.jpg', 1),
(10, 'angie', 'angie', '00:30:00', 6000, 2, 'BarbaCortaCuadrada.jpg', 2),
(12, 'a', 'a', '00:30:00', 1500, 1, 'barbero3.jpg', 2),
(13, 'sherk', 'sherk', '01:30:00', 80000000, 1, 'barbero3.jpg', 1),
(14, 'andres', 'andres', '01:30:00', 8000, 1, 'BarbaCortaCuadrada.jpg', 2),
(15, 'eeee', 'eeeeeee', '00:00:00', 0, 1, '', 1),
(16, 'barba y corte mariposa', 'barba y corte mariposa', '01:30:00', 5000, 5, 'barbacandadco.jpg', 1),
(17, 'once de la noche ', 'once de la noche ', '11:00:00', 11, 2, 'barbero3.jpg', 1),
(18, 'actualizacion api', 'actualizacion api', '10:00:00', 1, 2, 'barbacandadco.jpg', 1),
(19, 'barbar perrilla', 'barbar perrilla', '01:30:00', 1500, 2, 'barbalaperilla.jpg', 1),
(20, 'salvaje', 'salvaje', '01:00:00', 10000, 1, NULL, 1),
(21, '666666666666', '6666666666', '00:00:00', 6.66667e16, 5, NULL, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `service_invoice_detail`
--

CREATE TABLE `service_invoice_detail` (
  `amount` int(11) NOT NULL,
  `price` float DEFAULT NULL,
  `id_facture` int(11) NOT NULL,
  `id_services` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `service_invoice_detail`
--

INSERT INTO `service_invoice_detail` (`amount`, `price`, `id_facture`, `id_services`) VALUES
(1, 15, 1, 1),
(1, 10, 2, 2),
(2, 80, 3, 3),
(1, 25, 4, 4),
(3, 36, 5, 5);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `service_status`
--

CREATE TABLE `service_status` (
  `id_status` int(11) NOT NULL,
  `name_status` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `service_status`
--

INSERT INTO `service_status` (`id_status`, `name_status`) VALUES
(1, 'Active'),
(2, 'Inactive');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `type_of_quotes`
--

CREATE TABLE `type_of_quotes` (
  `id_quotes` int(11) NOT NULL,
  `id_services` int(11) NOT NULL,
  `barber_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `user`
--

CREATE TABLE `user` (
  `user_id` int(11) NOT NULL,
  `user_email` varchar(30) NOT NULL,
  `user_password` varchar(256) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `document_number` varchar(20) NOT NULL,
  `userStatus_fk` int(11) NOT NULL,
  `role_fk` int(11) NOT NULL,
  `type_document_id` int(11) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `phone` varchar(20) NOT NULL,
  `reset_token` varchar(64) DEFAULT NULL,
  `reset_token_expires` bigint(20) DEFAULT NULL,
  `profile_image` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `user`
--

INSERT INTO `user` (`user_id`, `user_email`, `user_password`, `full_name`, `document_number`, `userStatus_fk`, `role_fk`, `type_document_id`, `address`, `phone`, `reset_token`, `reset_token_expires`, `profile_image`) VALUES
(1, 'kevinsabogal24@gmail.com', '$2b$10$4zzz43P8ZzJWGJU5nfLLpum9IJEYWUZQ9.MYeYAR3/TTa0OIIbXWq', 'Kevin David Sabogal', '1000619691', 1, 1, 1, 'Carrera 14 #22-45', '3003113203', NULL, NULL, NULL),
(2, 'andresecasvar05@gmail.com', '$2b$10$8fjyRjQ7yRyGWWuqUR4Kje/9JQsgCDF4ne6Vaz3mkKHD/wUxLFPI2', 'Andres Esteban Castañeda', '1000621126', 1, 1, 2, 'Carrera 14 #22-46', '3175248114', 'dc28b1c23bc20cd6b7caa4bfe50597b528cfd658f9ad980afc35011ebbf6b8bb', 1744439824665, NULL),
(3, 'leonoscarandres04@gmail.com', '$2b$10$zAt29/KSBa9msB95jO5lTeU4nv3Tp4fsRg/Lv2wE.WC4OIvZ5Dige', 'Oscar Andres Leon', '1000313313', 1, 3, 3, 'Carrera 14 #22-47', '3209241730', NULL, NULL, NULL),
(4, 'hharold855@gmail.com', '$2b$10$69ey/9t5R1YwcxtOSS2sa.RjRq.0AaerI3rhCColETWMIx/OmaD5m', 'Harold David Hernandez', '1000919919', 1, 2, 1, 'Carrera 14 #22-48', '3212709274', NULL, NULL, NULL),
(5, 'administrador5@gmail.com', '$2y$10$OCw6UzozG1/WR9K6RxFp6O9TfuBT5Luiub/tj2.T3rcPHpgJ1gvA2', 'Administrador', '7142565', 1, 1, 1, 'Carrera 14 #22-49', '000', NULL, NULL, NULL),
(59, 'venitoca.1@hotmail.com', '$2b$10$YM0Xagrq.7UC5WiHXkQY..FpDNqX0zdVXulYsdcM86cwve150gFAK', 'Daniel Venegas', '132365548', 1, 2, 1, 'Carrera 20 #24-02', '000', NULL, NULL, NULL),
(60, 'mario@gmail.com', '$2b$10$2mwrIThLDywBhN6pQh7RWuDeXEQ14gpvzpEznI4.VYDLfyL/8ci9.', 'Mario Mendoza', '1000625545', 2, 3, 2, 'Carrera 20 #84-69', '000', NULL, NULL, NULL),
(61, 'mariano@gmail.com', '$2b$10$BPrmoIyoGRCSW2/qXT8F5.fM8Hl8uUXJYB/JAOIUMggbfPyRap6c6', 'Mariano Castro', '123456565', 2, 3, 1, 'Carrera 20 #44-20', '000', NULL, NULL, NULL),
(62, 'gregory@gmail.com', '$2b$10$ARnDB2GDgKY.r9EFupKbheyocEAEiB39k9UvDSSmdAxXxp.Bn2Nje', 'Gregory Diaz', '1000325786', 1, 1, 3, 'Carrera 20 #24-96', '000', NULL, NULL, NULL),
(63, 'fgfernan@gmail.com', '$2b$10$Dm3nkmify5X0U4jqCRE8te8vPe6oCQ8bH38gcPaw5QUOHupjG.vv6', 'Felipe Garcia', '1030133364', 1, 3, 1, 'Carrera 69 #56-22', '000', NULL, NULL, NULL),
(69, 'viviana@gmail.com', '$2b$10$IPeC4JdBgxRaDGQBhZ21ou2VSX3/Bvl4HeagFzQOKdTbamQtWxHnS', 'Viviana Gomez', '1000619600', 3, 3, 1, 'Carrera 14 #22-87', '3202425632', NULL, NULL, NULL),
(70, 'gluglu@gmail.com', '$2b$10$MorZ1Jv.KkHoJ6RzNr6LDuiePbgGD5uFfzzbS/Ydb5jFoJjfxgoMu', 'Mamahuevo GluGlu', '1000621444', 3, 3, 3, 'Carrera 74 #22-46', '3200022332', NULL, NULL, NULL),
(72, 'maicol@gmail.com', '$2b$10$1yvJ0l.pPs3/DeH2Zuu4/ehqcEb19yBLyIXxEohlm.IP/RzjHaku6', 'Maicol Hernandez', '196325412', 1, 3, 1, 'Carrera 14 #65-21', '3216549885', NULL, NULL, NULL),
(73, 'venito@gmail.com', '$2b$10$2iFl/jAhBwod32gFzJw3ouv9EafymfQeOgz/Gs1ymgoO.2jPwBuN.', 'Venito Verganzas', '100545232', 3, 3, 3, 'Calle 30 #38-22', '3514115200', NULL, NULL, NULL),
(74, 'angie@gmail.com', '$2b$10$6CkpbVCIbb07w0S508mIFOA8k2OLfiQs4H38NexdNxAmn5tMsdz5W', 'angie', '1011200995', 3, 2, 1, 'calle 58#19b-32', '3057627848', NULL, NULL, NULL),
(75, 'andrescliente@gmail.com', '$2b$10$/EIszXv6kWzdgFEnsu3ueedmc9YaB982oeFAyT0xekYilAmFouimS', 'andres cliente', '3175248115', 1, 2, 1, 'calle 58#19b-32', '3175248115', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `userstatus`
--

CREATE TABLE `userstatus` (
  `userStatus_id` int(11) NOT NULL,
  `userStatus_name` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `userstatus`
--

INSERT INTO `userstatus` (`userStatus_id`, `userStatus_name`) VALUES
(1, 'Active'),
(2, 'Blocked'),
(3, 'Inactive');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `category_product`
--
ALTER TABLE `category_product`
  ADD PRIMARY KEY (`id_category`);

--
-- Indices de la tabla `category_services`
--
ALTER TABLE `category_services`
  ADD PRIMARY KEY (`id_category_services`);

--
-- Indices de la tabla `document_type`
--
ALTER TABLE `document_type`
  ADD PRIMARY KEY (`id_doctypes`);

--
-- Indices de la tabla `facture`
--
ALTER TABLE `facture`
  ADD PRIMARY KEY (`id_facture`),
  ADD KEY `fk_factura_usuario` (`user_fk`);

--
-- Indices de la tabla `module`
--
ALTER TABLE `module`
  ADD PRIMARY KEY (`module_id`),
  ADD UNIQUE KEY `module_name` (`module_name`),
  ADD UNIQUE KEY `module_route` (`module_route`);

--
-- Indices de la tabla `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`id_product`),
  ADD KEY `fk_categoria` (`id_category`);

--
-- Indices de la tabla `product_invoice_detail`
--
ALTER TABLE `product_invoice_detail`
  ADD KEY `fk_product_invoice_detail` (`id_facture`),
  ADD KEY `fk_detail_invoice_product_product` (`id_product`);

--
-- Indices de la tabla `quotes`
--
ALTER TABLE `quotes`
  ADD PRIMARY KEY (`id_quotes`),
  ADD KEY `fk_appointment_user` (`user_id`),
  ADD KEY `fk_quotes_services` (`id_services`),
  ADD KEY `fk_barber_user` (`barber_id`);

--
-- Indices de la tabla `role`
--
ALTER TABLE `role`
  ADD PRIMARY KEY (`role_id`),
  ADD UNIQUE KEY `role_name` (`role_name`);

--
-- Indices de la tabla `role_module`
--
ALTER TABLE `role_module`
  ADD PRIMARY KEY (`roleModule_id`),
  ADD KEY `role_module_role` (`role_fk`),
  ADD KEY `role_module_module` (`module_fk`);

--
-- Indices de la tabla `services`
--
ALTER TABLE `services`
  ADD PRIMARY KEY (`id_services`),
  ADD KEY `fk_categoria_Servicios` (`id_category_services`),
  ADD KEY `fk_status` (`id_status`);

--
-- Indices de la tabla `service_invoice_detail`
--
ALTER TABLE `service_invoice_detail`
  ADD KEY `fk_service_invoice_detail` (`id_facture`),
  ADD KEY `fk_detail_invoice_service_service` (`id_services`);

--
-- Indices de la tabla `service_status`
--
ALTER TABLE `service_status`
  ADD PRIMARY KEY (`id_status`);

--
-- Indices de la tabla `type_of_quotes`
--
ALTER TABLE `type_of_quotes`
  ADD KEY `fk_type_citation_citation` (`id_quotes`),
  ADD KEY `fk_type_appointment_service` (`id_services`);

--
-- Indices de la tabla `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `user_email` (`user_email`),
  ADD KEY `user_role` (`role_fk`),
  ADD KEY `user_status` (`userStatus_fk`),
  ADD KEY `fk_id_tipo_docuemnto_User` (`type_document_id`);

--
-- Indices de la tabla `userstatus`
--
ALTER TABLE `userstatus`
  ADD PRIMARY KEY (`userStatus_id`),
  ADD UNIQUE KEY `userStatus_name` (`userStatus_name`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `document_type`
--
ALTER TABLE `document_type`
  MODIFY `id_doctypes` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `facture`
--
ALTER TABLE `facture`
  MODIFY `id_facture` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `module`
--
ALTER TABLE `module`
  MODIFY `module_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `quotes`
--
ALTER TABLE `quotes`
  MODIFY `id_quotes` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT de la tabla `role`
--
ALTER TABLE `role`
  MODIFY `role_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `role_module`
--
ALTER TABLE `role_module`
  MODIFY `roleModule_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `services`
--
ALTER TABLE `services`
  MODIFY `id_services` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT de la tabla `user`
--
ALTER TABLE `user`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=76;

--
-- AUTO_INCREMENT de la tabla `userstatus`
--
ALTER TABLE `userstatus`
  MODIFY `userStatus_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `facture`
--
ALTER TABLE `facture`
  ADD CONSTRAINT `fk_factura_usuario` FOREIGN KEY (`user_fk`) REFERENCES `user` (`user_id`);

--
-- Filtros para la tabla `product`
--
ALTER TABLE `product`
  ADD CONSTRAINT `fk_categoria` FOREIGN KEY (`id_category`) REFERENCES `category_product` (`id_category`);

--
-- Filtros para la tabla `product_invoice_detail`
--
ALTER TABLE `product_invoice_detail`
  ADD CONSTRAINT `fk_detail_invoice_product_product` FOREIGN KEY (`id_product`) REFERENCES `product` (`id_product`),
  ADD CONSTRAINT `fk_product_invoice_detail` FOREIGN KEY (`id_facture`) REFERENCES `facture` (`id_facture`);

--
-- Filtros para la tabla `quotes`
--
ALTER TABLE `quotes`
  ADD CONSTRAINT `fk_appointment_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`),
  ADD CONSTRAINT `fk_barber_user` FOREIGN KEY (`barber_id`) REFERENCES `user` (`user_id`),
  ADD CONSTRAINT `fk_quotes_services` FOREIGN KEY (`id_services`) REFERENCES `services` (`id_services`);

--
-- Filtros para la tabla `role_module`
--
ALTER TABLE `role_module`
  ADD CONSTRAINT `role_module_module` FOREIGN KEY (`module_fk`) REFERENCES `module` (`module_id`),
  ADD CONSTRAINT `role_module_role` FOREIGN KEY (`role_fk`) REFERENCES `role` (`role_id`);

--
-- Filtros para la tabla `services`
--
ALTER TABLE `services`
  ADD CONSTRAINT `fk_categoria_Servicios` FOREIGN KEY (`id_category_services`) REFERENCES `category_services` (`id_category_services`),
  ADD CONSTRAINT `fk_status` FOREIGN KEY (`id_status`) REFERENCES `service_status` (`id_status`);

--
-- Filtros para la tabla `service_invoice_detail`
--
ALTER TABLE `service_invoice_detail`
  ADD CONSTRAINT `fk_detail_invoice_service_service` FOREIGN KEY (`id_services`) REFERENCES `services` (`id_services`),
  ADD CONSTRAINT `fk_service_invoice_detail` FOREIGN KEY (`id_facture`) REFERENCES `facture` (`id_facture`);

--
-- Filtros para la tabla `type_of_quotes`
--
ALTER TABLE `type_of_quotes`
  ADD CONSTRAINT `fk_type_appointment_service` FOREIGN KEY (`id_services`) REFERENCES `services` (`id_services`),
  ADD CONSTRAINT `fk_type_citation_citation` FOREIGN KEY (`id_quotes`) REFERENCES `quotes` (`id_quotes`);

--
-- Filtros para la tabla `user`
--
ALTER TABLE `user`
  ADD CONSTRAINT `fk_id_tipo_docuemnto_User` FOREIGN KEY (`type_document_id`) REFERENCES `document_type` (`id_doctypes`),
  ADD CONSTRAINT `user_role` FOREIGN KEY (`role_fk`) REFERENCES `role` (`role_id`),
  ADD CONSTRAINT `user_status` FOREIGN KEY (`userStatus_fk`) REFERENCES `userstatus` (`userStatus_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
