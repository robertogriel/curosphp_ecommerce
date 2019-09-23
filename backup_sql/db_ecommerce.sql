-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 23-Set-2019 às 03:13
-- Versão do servidor: 10.3.16-MariaDB
-- versão do PHP: 7.3.7

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `db_ecommerce`
--

DELIMITER $$
--
-- Procedimentos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_addresses_save` (`pidaddress` INT(11), `pidperson` INT(11), `pdesaddress` VARCHAR(128), `pdesnumber` VARCHAR(16), `pdescomplement` VARCHAR(32), `pdescity` VARCHAR(32), `pdesstate` VARCHAR(32), `pdescountry` VARCHAR(32), `pdeszipcode` CHAR(8), `pdesdistrict` VARCHAR(32))  BEGIN

	IF pidaddress > 0 THEN
		
		UPDATE tb_addresses
        SET
			idperson = pidperson,
            desaddress = pdesaddress,
            desnumber = pdesnumber,
            descomplement = pdescomplement,
            descity = pdescity,
            desstate = pdesstate,
            descountry = pdescountry,
            deszipcode = pdeszipcode, 
            desdistrict = pdesdistrict
		WHERE idaddress = pidaddress;
        
    ELSE
		
		INSERT INTO tb_addresses (idperson, desaddress, desnumber, descomplement, descity, desstate, descountry, deszipcode, desdistrict)
        VALUES(pidperson, pdesaddress, pdesnumber, pdescomplement, pdescity, pdesstate, pdescountry, pdeszipcode, pdesdistrict);
        
        SET pidaddress = LAST_INSERT_ID();
        
    END IF;
    
    SELECT * FROM tb_addresses WHERE idaddress = pidaddress;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_carts_save` (`pidcart` INT, `pdessessionid` VARCHAR(64), `piduser` INT, `pdeszipcode` CHAR(8), `pvlfreight` DECIMAL(10,2), `pnrdays` INT)  BEGIN

    IF pidcart > 0 THEN
        
        UPDATE tb_carts
        SET
            dessessionid = pdessessionid,
            iduser = piduser,
            deszipcode = pdeszipcode,
            vlfreight = pvlfreight,
            nrdays = pnrdays
        WHERE idcart = pidcart;
        
    ELSE
        
        INSERT INTO tb_carts (dessessionid, iduser, deszipcode, vlfreight, nrdays)
        VALUES(pdessessionid, piduser, pdeszipcode, pvlfreight, pnrdays);
        
        SET pidcart = LAST_INSERT_ID();
        
    END IF;
    
    SELECT * FROM tb_carts WHERE idcart = pidcart;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_categories_save` (`pidcategory` INT, `pdescategory` VARCHAR(64))  BEGIN
	
	IF pidcategory > 0 THEN
		
		UPDATE tb_categories
        SET descategory = pdescategory
        WHERE idcategory = pidcategory;
        
    ELSE
		
		INSERT INTO tb_categories (descategory) VALUES(pdescategory);
        
        SET pidcategory = LAST_INSERT_ID();
        
    END IF;
    
    SELECT * FROM tb_categories WHERE idcategory = pidcategory;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_orders_save` (`pidorder` INT, `pidcart` INT(11), `piduser` INT(11), `pidstatus` INT(11), `pidaddress` INT(11), `pvltotal` DECIMAL(10,2))  BEGIN
	
	IF pidorder > 0 THEN
		
		UPDATE tb_orders
        SET
			idcart = pidcart,
            iduser = piduser,
            idstatus = pidstatus,
            idaddress = pidaddress,
            vltotal = pvltotal
		WHERE idorder = pidorder;
        
    ELSE
    
		INSERT INTO tb_orders (idcart, iduser, idstatus, idaddress, vltotal)
        VALUES(pidcart, piduser, pidstatus, pidaddress, pvltotal);
		
		SET pidorder = LAST_INSERT_ID();
        
    END IF;
    
    SELECT * 
    FROM tb_orders a
    INNER JOIN tb_ordersstatus b USING(idstatus)
    INNER JOIN tb_carts c USING(idcart)
    INNER JOIN tb_users d ON d.iduser = a.iduser
    INNER JOIN tb_addresses e USING(idaddress)
    WHERE idorder = pidorder;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_products_save` (`pidproduct` INT(11), `pdesproduct` VARCHAR(64), `pvlprice` DECIMAL(10,2), `pvlwidth` DECIMAL(10,2), `pvlheight` DECIMAL(10,2), `pvllength` DECIMAL(10,2), `pvlweight` DECIMAL(10,2), `pdesurl` VARCHAR(128))  BEGIN
	
	IF pidproduct > 0 THEN
		
		UPDATE tb_products
        SET 
			desproduct = pdesproduct,
            vlprice = pvlprice,
            vlwidth = pvlwidth,
            vlheight = pvlheight,
            vllength = pvllength,
            vlweight = pvlweight,
            desurl = pdesurl
        WHERE idproduct = pidproduct;
        
    ELSE
		
		INSERT INTO tb_products (desproduct, vlprice, vlwidth, vlheight, vllength, vlweight, desurl) 
        VALUES(pdesproduct, pvlprice, pvlwidth, pvlheight, pvllength, pvlweight, pdesurl);
        
        SET pidproduct = LAST_INSERT_ID();
        
    END IF;
    
    SELECT * FROM tb_products WHERE idproduct = pidproduct;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_userspasswordsrecoveries_create` (`piduser` INT, `pdesip` VARCHAR(45))  BEGIN
  
  INSERT INTO tb_userspasswordsrecoveries (iduser, desip)
    VALUES(piduser, pdesip);
    
    SELECT * FROM tb_userspasswordsrecoveries
    WHERE idrecovery = LAST_INSERT_ID();
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_usersupdate_save` (`piduser` INT, `pdesperson` VARCHAR(64), `pdeslogin` VARCHAR(64), `pdespassword` VARCHAR(256), `pdesemail` VARCHAR(128), `pnrphone` BIGINT, `pinadmin` TINYINT)  BEGIN
  
    DECLARE vidperson INT;
    
  SELECT idperson INTO vidperson
    FROM tb_users
    WHERE iduser = piduser;
    
    UPDATE tb_persons
    SET 
    desperson = pdesperson,
        desemail = pdesemail,
        nrphone = pnrphone
  WHERE idperson = vidperson;
    
    UPDATE tb_users
    SET
    deslogin = pdeslogin,
        despassword = pdespassword,
        inadmin = pinadmin
  WHERE iduser = piduser;
    
    SELECT * FROM tb_users a INNER JOIN tb_persons b USING(idperson) WHERE a.iduser = piduser;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_users_delete` (`piduser` INT)  BEGIN
    
    DECLARE vidperson INT;
    
    SET FOREIGN_KEY_CHECKS = 0;
	
	SELECT idperson INTO vidperson
    FROM tb_users
    WHERE iduser = piduser;
	
    DELETE FROM tb_addresses WHERE idperson = vidperson;
    DELETE FROM tb_addresses WHERE idaddress IN(SELECT idaddress FROM tb_orders WHERE iduser = piduser);
	DELETE FROM tb_persons WHERE idperson = vidperson;
    
    DELETE FROM tb_userslogs WHERE iduser = piduser;
    DELETE FROM tb_userspasswordsrecoveries WHERE iduser = piduser;
    DELETE FROM tb_orders WHERE iduser = piduser;
    DELETE FROM tb_cartsproducts WHERE idcart IN(SELECT idcart FROM tb_carts WHERE iduser = piduser);
    DELETE FROM tb_carts WHERE iduser = piduser;
    DELETE FROM tb_users WHERE iduser = piduser;
    
    SET FOREIGN_KEY_CHECKS = 1;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_users_save` (`pdesperson` VARCHAR(64), `pdeslogin` VARCHAR(64), `pdespassword` VARCHAR(256), `pdesemail` VARCHAR(128), `pnrphone` BIGINT, `pinadmin` TINYINT)  BEGIN
  
    DECLARE vidperson INT;
    
  INSERT INTO tb_persons (desperson, desemail, nrphone)
    VALUES(pdesperson, pdesemail, pnrphone);
    
    SET vidperson = LAST_INSERT_ID();
    
    INSERT INTO tb_users (idperson, deslogin, despassword, inadmin)
    VALUES(vidperson, pdeslogin, pdespassword, pinadmin);
    
    SELECT * FROM tb_users a INNER JOIN tb_persons b USING(idperson) WHERE a.iduser = LAST_INSERT_ID();
    
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_addresses`
--

CREATE TABLE `tb_addresses` (
  `idaddress` int(11) NOT NULL,
  `idperson` int(11) NOT NULL,
  `desaddress` varchar(128) NOT NULL,
  `desnumber` varchar(16) NOT NULL,
  `descomplement` varchar(32) DEFAULT NULL,
  `descity` varchar(32) NOT NULL,
  `desstate` varchar(32) NOT NULL,
  `descountry` varchar(32) NOT NULL,
  `deszipcode` char(8) NOT NULL,
  `desdistrict` varchar(32) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_addresses`
--

INSERT INTO `tb_addresses` (`idaddress`, `idperson`, `desaddress`, `desnumber`, `descomplement`, `descity`, `desstate`, `descountry`, `deszipcode`, `desdistrict`, `dtregister`) VALUES
(1, 11, 'Rua Ezequiel Paula Ramos', '', '', 'Limeira', 'SP', 'Brasil', '13484327', 'Jardim Piratininga', '2019-09-18 01:38:48'),
(2, 11, 'Rua Ezequiel de Paula Ramos', '72', 'Casa', 'Limeira', 'São Paulo', 'Brasil', '13484327', 'Jardim Piratininga', '2019-09-18 01:41:26'),
(3, 11, 'Rua Ezequiel Paula Ramos', '72', '', 'Limeira', 'SP', 'Brasil', '13484327', 'Jardim Piratininga', '2019-09-22 17:48:03'),
(4, 11, 'Rua Ezequiel Paula Ramos', '72', '', 'Limeira', 'SP', 'Brasil', '13484327', 'Jardim Piratininga', '2019-09-22 18:12:55'),
(5, 11, 'Rua Ezequiel Paula Ramos', '72', '', 'Limeira', 'SP', 'Brasil', '13484327', 'Jardim Piratininga', '2019-09-22 18:13:06'),
(6, 11, 'Rua Ezequiel Paula Ramos', '72', '', 'Limeira', 'SP', 'Brasil', '13484327', 'Jardim Piratininga', '2019-09-22 18:14:58'),
(7, 11, 'Rua Ezequiel Paula Ramos', '72', '', 'Limeira', 'SP', 'Brasil', '13484327', 'Jardim Piratininga', '2019-09-22 18:17:05'),
(8, 11, 'Rua Ezequiel Paula Ramos', '45', '', 'Limeira', 'SP', 'Brasil', '13484327', 'Jardim Piratininga', '2019-09-22 18:18:33'),
(9, 11, 'Rua Ezequiel Paula Ramos', '43', '', 'Limeira', 'SP', 'Brasil', '13484327', 'Jardim Piratininga', '2019-09-22 18:33:51'),
(10, 11, 'Rua Ezequiel Paula Ramos', '21', '', 'Limeira', 'SP', 'Brasil', '13484327', 'Jardim Piratininga', '2019-09-22 19:01:24'),
(11, 11, 'Rua Ezequiel Paula Ramos', '6', '', 'Limeira', 'SP', 'Brasil', '13484327', 'Jardim Piratininga', '2019-09-22 19:04:27'),
(12, 11, 'Rua Ezequiel Paula Ramos', '3', '', 'Limeira', 'SP', 'Brasil', '13484327', 'Jardim Piratininga', '2019-09-22 19:12:04'),
(13, 8, 'Rua Ezequiel Paula Ramos', '32', '', 'Limeira', 'SP', 'Brasil', '13484327', 'Jardim Piratininga', '2019-09-22 20:00:58'),
(14, 8, 'Rua Ezequiel Paula Ramos', '32', '', 'Limeira', 'SP', 'Brasil', '13484327', 'Jardim Piratininga', '2019-09-22 22:33:35'),
(15, 8, 'Rua Ezequiel Paula Ramos', '32', '', 'Limeira', 'SP', 'Brasil', '13484327', 'Jardim Piratininga', '2019-09-22 22:36:34'),
(16, 8, 'Rua Ezequiel Paula Ramos', '54', '', 'Limeira', 'SP', 'Brasil', '13484327', 'Jardim Piratininga', '2019-09-22 22:44:19'),
(17, 8, 'Rua Ezequiel Paula Ramos', '654', '', 'Limeira', 'SP', 'Brasil', '13484327', 'Jardim Piratininga', '2019-09-22 22:59:52'),
(18, 8, 'Rua Ezequiel Paula Ramos', '654', '', 'Limeira', 'SP', 'Brasil', '13484327', 'Jardim Piratininga', '2019-09-22 23:00:05'),
(19, 8, 'Rua Ezequiel Paula Ramos', '654', '', 'Limeira', 'SP', 'Brasil', '13484327', 'Jardim Piratininga', '2019-09-22 23:00:14'),
(20, 8, 'Rua Ezequiel Paula Ramos', '654', '', 'Limeira', 'SP', 'Brasil', '13484327', 'Jardim Piratininga', '2019-09-22 23:02:13'),
(21, 8, 'Rua Ezequiel Paula Ramos', '565', '', 'Limeira', 'SP', 'Brasil', '13484327', 'Jardim Piratininga', '2019-09-22 23:03:04'),
(22, 8, 'Rua Ezequiel Paula Ramos', '43', '', 'Limeira', 'SP', 'Brasil', '13484327', 'Jardim Piratininga', '2019-09-23 00:32:58'),
(23, 11, 'Rua Ezequiel Paula Ramos', '72', '', 'Limeira', 'SP', 'Brasil', '13484327', 'Jardim Piratininga', '2019-09-23 00:49:12'),
(24, 11, 'Rua Ezequiel Paula Ramos', '72', '', 'Limeira', 'SP', 'Brasil', '13484327', 'Jardim Piratininga', '2019-09-23 00:49:41'),
(25, 11, 'Rua Ezequiel Paula Ramos', '72', '', 'Limeira', 'SP', 'Brasil', '13484327', 'Jardim Piratininga', '2019-09-23 00:49:51'),
(26, 11, 'Rua Ezequiel Paula Ramos', '72', '', 'Limeira', 'SP', 'Brasil', '13484327', 'Jardim Piratininga', '2019-09-23 00:51:56');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_carts`
--

CREATE TABLE `tb_carts` (
  `idcart` int(11) NOT NULL,
  `dessessionid` varchar(64) NOT NULL,
  `iduser` int(11) DEFAULT NULL,
  `deszipcode` char(8) DEFAULT NULL,
  `vlfreight` decimal(10,2) DEFAULT NULL,
  `nrdays` int(11) DEFAULT NULL,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_carts`
--

INSERT INTO `tb_carts` (`idcart`, `dessessionid`, `iduser`, `deszipcode`, `vlfreight`, `nrdays`, `dtregister`) VALUES
(1, '17uj0kl3ovk9bo935ctqvc57cv', 8, NULL, NULL, NULL, '2019-09-11 22:03:01'),
(2, 'qnnio1k91aa7jjvcmor8a3vlfh', NULL, NULL, NULL, NULL, '2019-09-15 19:24:20'),
(3, '99q2jelat8aell3cq76a0vbjel', NULL, '65010200', '75.99', 11, '2019-09-16 20:12:47'),
(4, '13c6tbugbl1d3jfbqdr4rmoet6', NULL, NULL, NULL, NULL, '2019-09-16 22:06:12'),
(5, 'r4r3biidiics9ojn7fipkjdh19', NULL, '13484327', '28.69', 7, '2019-09-16 22:06:36'),
(6, 'h2cs3e5v2qtplgt7nr9o6tfria', NULL, '13484327', '28.69', 7, '2019-09-16 22:16:49'),
(7, 'a823ud6jprrkp9cagqroadv5hg', 8, NULL, NULL, NULL, '2019-09-16 22:49:27'),
(9, 'ehlm99306n3qcg2c3io1jdrufh', NULL, '13484327', '47.39', 7, '2019-09-22 17:46:33'),
(10, 'lrmesniqm8sdlmj537p5k03rus', NULL, '13484327', '28.69', 7, '2019-09-23 00:41:28'),
(11, 'ajotqultpsfgk53mgq5ehqhu41', 12, '13484327', '28.69', 7, '2019-09-23 00:49:23'),
(12, 't8jrhrkqbhvp3tteh1nlo0cu1d', 12, '13484327', NULL, NULL, '2019-09-23 00:49:48'),
(13, 'o9q1gnalfhmh7rfaks1c4igrc4', 12, '13484327', '28.69', 7, '2019-09-23 00:49:54');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_cartsproducts`
--

CREATE TABLE `tb_cartsproducts` (
  `idcartproduct` int(11) NOT NULL,
  `idcart` int(11) NOT NULL,
  `idproduct` int(11) NOT NULL,
  `dtremoved` datetime DEFAULT NULL,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_cartsproducts`
--

INSERT INTO `tb_cartsproducts` (`idcartproduct`, `idcart`, `idproduct`, `dtremoved`, `dtregister`) VALUES
(1, 2, 4, '2019-09-15 16:42:16', '2019-09-15 19:32:48'),
(2, 2, 4, '2019-09-15 16:42:16', '2019-09-15 19:42:12'),
(3, 2, 4, '2019-09-15 16:42:18', '2019-09-15 19:42:14'),
(4, 2, 6, '2019-09-15 16:42:32', '2019-09-15 19:42:24'),
(5, 2, 6, '2019-09-15 16:42:34', '2019-09-15 19:42:27'),
(6, 2, 6, '2019-09-15 16:51:48', '2019-09-15 19:42:30'),
(7, 2, 4, '2019-09-15 16:43:30', '2019-09-15 19:42:49'),
(8, 2, 4, '2019-09-15 16:43:30', '2019-09-15 19:43:19'),
(9, 2, 4, '2019-09-15 16:43:31', '2019-09-15 19:43:22'),
(10, 2, 4, '2019-09-15 16:43:32', '2019-09-15 19:43:23'),
(11, 2, 4, '2019-09-15 16:43:32', '2019-09-15 19:43:24'),
(12, 2, 4, '2019-09-15 16:43:33', '2019-09-15 19:43:25'),
(13, 2, 4, '2019-09-15 16:49:32', '2019-09-15 19:43:26'),
(14, 2, 4, '2019-09-15 16:49:32', '2019-09-15 19:43:26'),
(15, 2, 4, '2019-09-15 16:49:32', '2019-09-15 19:43:27'),
(16, 2, 4, '2019-09-15 16:49:32', '2019-09-15 19:43:28'),
(17, 2, 6, '2019-09-15 16:51:48', '2019-09-15 19:49:50'),
(18, 2, 6, '2019-09-15 16:51:48', '2019-09-15 19:51:45'),
(19, 2, 6, '2019-09-15 16:51:48', '2019-09-15 19:51:45'),
(20, 2, 6, '2019-09-15 16:51:48', '2019-09-15 19:51:45'),
(21, 2, 6, '2019-09-15 16:51:48', '2019-09-15 19:51:45'),
(22, 2, 6, '2019-09-15 16:51:48', '2019-09-15 19:51:45'),
(23, 2, 6, '2019-09-15 16:51:48', '2019-09-15 19:51:45'),
(24, 2, 6, '2019-09-15 16:51:48', '2019-09-15 19:51:45'),
(25, 2, 6, '2019-09-15 16:51:48', '2019-09-15 19:51:45'),
(26, 2, 6, '2019-09-15 16:51:48', '2019-09-15 19:51:45'),
(27, 2, 6, '2019-09-15 16:51:48', '2019-09-15 19:51:45'),
(28, 2, 3, '2019-09-15 16:52:14', '2019-09-15 19:51:52'),
(29, 2, 4, NULL, '2019-09-15 19:52:02'),
(30, 2, 4, NULL, '2019-09-15 19:52:02'),
(31, 2, 4, NULL, '2019-09-15 19:52:02'),
(32, 2, 4, NULL, '2019-09-15 19:52:02'),
(33, 2, 4, NULL, '2019-09-15 19:52:02'),
(34, 2, 4, NULL, '2019-09-15 19:52:02'),
(35, 2, 4, NULL, '2019-09-15 19:52:02'),
(36, 2, 4, NULL, '2019-09-15 19:52:02'),
(37, 2, 4, NULL, '2019-09-15 19:52:02'),
(38, 2, 4, NULL, '2019-09-15 19:52:02'),
(39, 2, 4, NULL, '2019-09-15 19:52:02'),
(40, 2, 4, NULL, '2019-09-15 19:52:02'),
(41, 2, 4, NULL, '2019-09-15 19:52:02'),
(42, 2, 4, NULL, '2019-09-15 19:52:02'),
(43, 2, 4, NULL, '2019-09-15 19:52:02'),
(44, 2, 4, NULL, '2019-09-15 19:52:02'),
(45, 2, 4, NULL, '2019-09-15 19:52:02'),
(46, 2, 4, NULL, '2019-09-15 19:52:02'),
(47, 2, 4, NULL, '2019-09-15 19:52:02'),
(48, 2, 4, NULL, '2019-09-15 19:52:02'),
(49, 2, 4, NULL, '2019-09-15 19:52:02'),
(50, 2, 4, NULL, '2019-09-15 19:52:02'),
(51, 2, 4, NULL, '2019-09-15 19:52:02'),
(52, 2, 4, NULL, '2019-09-15 19:52:02'),
(53, 2, 4, NULL, '2019-09-15 19:52:02'),
(54, 2, 4, NULL, '2019-09-15 19:52:02'),
(55, 2, 4, NULL, '2019-09-15 19:52:02'),
(56, 2, 4, NULL, '2019-09-15 19:52:02'),
(57, 2, 4, NULL, '2019-09-15 19:52:02'),
(58, 2, 4, NULL, '2019-09-15 19:52:02'),
(59, 2, 4, NULL, '2019-09-15 19:52:02'),
(60, 2, 4, NULL, '2019-09-15 19:52:02'),
(61, 2, 4, NULL, '2019-09-15 19:52:02'),
(62, 2, 4, NULL, '2019-09-15 19:52:02'),
(63, 2, 4, NULL, '2019-09-15 19:52:02'),
(64, 2, 4, NULL, '2019-09-15 19:52:02'),
(65, 2, 4, NULL, '2019-09-15 19:52:02'),
(66, 2, 4, NULL, '2019-09-15 19:52:02'),
(67, 2, 4, NULL, '2019-09-15 19:52:02'),
(68, 2, 4, NULL, '2019-09-15 19:52:02'),
(69, 2, 4, NULL, '2019-09-15 19:52:02'),
(70, 2, 4, NULL, '2019-09-15 19:52:02'),
(71, 2, 4, NULL, '2019-09-15 19:52:02'),
(72, 2, 4, NULL, '2019-09-15 19:52:02'),
(73, 2, 4, NULL, '2019-09-15 19:52:02'),
(74, 2, 4, NULL, '2019-09-15 19:52:02'),
(75, 2, 4, NULL, '2019-09-15 19:52:02'),
(76, 2, 4, NULL, '2019-09-15 19:52:02'),
(77, 3, 4, '2019-09-16 17:53:13', '2019-09-16 20:12:54'),
(78, 3, 4, '2019-09-16 18:28:07', '2019-09-16 20:53:17'),
(79, 3, 4, '2019-09-16 18:28:09', '2019-09-16 21:25:51'),
(80, 3, 4, '2019-09-16 18:33:07', '2019-09-16 21:28:03'),
(81, 3, 4, '2019-09-16 18:33:09', '2019-09-16 21:28:12'),
(82, 3, 4, '2019-09-16 18:34:32', '2019-09-16 21:33:02'),
(83, 3, 4, '2019-09-16 18:34:59', '2019-09-16 21:34:24'),
(84, 3, 4, '2019-09-16 18:35:03', '2019-09-16 21:34:27'),
(85, 3, 4, NULL, '2019-09-16 21:34:28'),
(86, 5, 4, NULL, '2019-09-16 22:06:36'),
(87, 6, 4, NULL, '2019-09-16 22:16:49'),
(91, 9, 4, '2019-09-22 16:04:16', '2019-09-22 17:46:40'),
(92, 9, 6, '2019-09-22 16:01:08', '2019-09-22 19:00:57'),
(93, 9, 6, '2019-09-22 16:19:40', '2019-09-22 19:00:57'),
(94, 9, 6, '2019-09-22 16:19:45', '2019-09-22 19:19:08'),
(95, 9, 6, '2019-09-22 17:00:50', '2019-09-22 19:19:33'),
(96, 9, 9, NULL, '2019-09-22 20:00:47'),
(97, 9, 4, '2019-09-22 19:53:39', '2019-09-22 22:42:18'),
(98, 9, 4, NULL, '2019-09-22 22:53:36'),
(99, 10, 4, NULL, '2019-09-23 00:41:31'),
(100, 11, 4, NULL, '2019-09-23 00:49:32'),
(101, 13, 4, NULL, '2019-09-23 00:50:01');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_categories`
--

CREATE TABLE `tb_categories` (
  `idcategory` int(11) NOT NULL,
  `descategory` varchar(32) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_categories`
--

INSERT INTO `tb_categories` (`idcategory`, `descategory`, `dtregister`) VALUES
(1, 'CalÃ§ados Masculinos', '2019-09-08 22:09:58'),
(2, 'Smartphones', '2019-09-08 22:19:22'),
(3, 'Notebooks', '2019-09-08 22:19:27'),
(4, 'Motorola', '2019-09-11 21:09:40');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_orders`
--

CREATE TABLE `tb_orders` (
  `idorder` int(11) NOT NULL,
  `idcart` int(11) NOT NULL,
  `iduser` int(11) NOT NULL,
  `idstatus` int(11) NOT NULL,
  `idaddress` int(11) NOT NULL,
  `vltotal` decimal(10,2) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_orders`
--

INSERT INTO `tb_orders` (`idorder`, `idcart`, `iduser`, `idstatus`, `idaddress`, `vltotal`, `dtregister`) VALUES
(15, 10, 12, 1, 23, '97.69', '2019-09-23 00:49:12'),
(16, 11, 12, 1, 24, '97.69', '2019-09-23 00:49:42'),
(17, 12, 12, 1, 25, '0.00', '2019-09-23 00:49:51'),
(18, 13, 12, 1, 26, '97.69', '2019-09-23 00:51:56');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_ordersstatus`
--

CREATE TABLE `tb_ordersstatus` (
  `idstatus` int(11) NOT NULL,
  `desstatus` varchar(32) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_ordersstatus`
--

INSERT INTO `tb_ordersstatus` (`idstatus`, `desstatus`, `dtregister`) VALUES
(1, 'Em Aberto', '2017-03-13 06:00:00'),
(2, 'Aguardando Pagamento', '2017-03-13 06:00:00'),
(3, 'Pago', '2017-03-13 06:00:00'),
(4, 'Entregue', '2017-03-13 06:00:00');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_persons`
--

CREATE TABLE `tb_persons` (
  `idperson` int(11) NOT NULL,
  `desperson` varchar(64) NOT NULL,
  `desemail` varchar(128) DEFAULT NULL,
  `nrphone` bigint(20) DEFAULT NULL,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_persons`
--

INSERT INTO `tb_persons` (`idperson`, `desperson`, `desemail`, `nrphone`, `dtregister`) VALUES
(7, 'Suporte', 'suporte@hcode.com.br', 1112345678, '2017-03-15 19:10:27'),
(8, 'Roberto', 'roberto@griel.com.br', 0, '2019-09-08 22:05:41'),
(11, 'Roberto Griel Filho', 'rgrielfilho@outlook.com', 0, '2019-09-17 13:42:59');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_products`
--

CREATE TABLE `tb_products` (
  `idproduct` int(11) NOT NULL,
  `desproduct` varchar(64) NOT NULL,
  `vlprice` decimal(10,2) NOT NULL,
  `vlwidth` decimal(10,2) NOT NULL,
  `vlheight` decimal(10,2) NOT NULL,
  `vllength` decimal(10,2) NOT NULL,
  `vlweight` decimal(10,2) NOT NULL,
  `desurl` varchar(128) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_products`
--

INSERT INTO `tb_products` (`idproduct`, `desproduct`, `vlprice`, `vlwidth`, `vlheight`, `vllength`, `vlweight`, `desurl`, `dtregister`) VALUES
(3, 'Notebook 14\" 4GB 1TB', '1949.99', '345.00', '23.00', '30.00', '2000.00', 'notebook-14-4gb-1tb', '2017-03-13 06:00:00'),
(4, 'CalÃ§ado Masculino', '69.00', '23.00', '13.00', '32.00', '0.90', 'calcado-masculino', '2019-09-08 22:40:50'),
(5, 'Smartphone Motorola Moto G5 Plus', '1135.23', '15.20', '7.40', '0.70', '0.16', 'smartphone-motorola-moto-g5-plus', '2019-09-08 23:24:16'),
(6, 'Smartphone Moto Z Play', '1887.78', '14.10', '0.90', '1.16', '0.13', 'smartphone-moto-z-play', '2019-09-08 23:24:16'),
(7, 'Smartphone Samsung Galaxy J5 Pro', '1299.00', '14.60', '7.10', '0.80', '0.16', 'smartphone-samsung-galaxy-j5', '2019-09-08 23:24:16'),
(8, 'Smartphone Samsung Galaxy J7 Prime', '1149.00', '15.10', '7.50', '0.80', '0.16', 'smartphone-samsung-galaxy-j7', '2019-09-08 23:24:16'),
(9, 'Smartphone Samsung Galaxy J3 Dual', '679.90', '14.20', '7.10', '0.70', '0.14', 'smartphone-samsung-galaxy-j3', '2019-09-08 23:24:16');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_productscategories`
--

CREATE TABLE `tb_productscategories` (
  `idcategory` int(11) NOT NULL,
  `idproduct` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_productscategories`
--

INSERT INTO `tb_productscategories` (`idcategory`, `idproduct`) VALUES
(1, 4),
(2, 5),
(2, 6),
(2, 7),
(2, 8),
(2, 9),
(3, 3),
(4, 6);

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_users`
--

CREATE TABLE `tb_users` (
  `iduser` int(11) NOT NULL,
  `idperson` int(11) NOT NULL,
  `deslogin` varchar(64) NOT NULL,
  `despassword` varchar(256) NOT NULL,
  `inadmin` tinyint(4) NOT NULL DEFAULT 0,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_users`
--

INSERT INTO `tb_users` (`iduser`, `idperson`, `deslogin`, `despassword`, `inadmin`, `dtregister`) VALUES
(7, 7, 'suporte', '$2y$12$HFjgUm/mk1RzTy4ZkJaZBe0Mc/BA2hQyoUckvm.lFa6TesjtNpiMe', 1, '2017-03-15 19:10:27'),
(8, 8, 'roberto', '$2y$12$sm/PnG6dhOF25hVyI58N2eyR.mEGM9iewYRE/qRlHQoBs5KHX2SjW', 1, '2019-09-08 22:05:41'),
(12, 11, 'rgrielfilho@outlook.com', '$2y$12$X7LSm4Y0MfKkZLRrsLPZqucQHkIvVsR6os5qKP6EuXEoGdUUU81.G', 0, '2019-09-17 13:42:59');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_userslogs`
--

CREATE TABLE `tb_userslogs` (
  `idlog` int(11) NOT NULL,
  `iduser` int(11) NOT NULL,
  `deslog` varchar(128) NOT NULL,
  `desip` varchar(45) NOT NULL,
  `desuseragent` varchar(128) NOT NULL,
  `dessessionid` varchar(64) NOT NULL,
  `desurl` varchar(128) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_userspasswordsrecoveries`
--

CREATE TABLE `tb_userspasswordsrecoveries` (
  `idrecovery` int(11) NOT NULL,
  `iduser` int(11) NOT NULL,
  `desip` varchar(45) NOT NULL,
  `dtrecovery` datetime DEFAULT NULL,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_userspasswordsrecoveries`
--

INSERT INTO `tb_userspasswordsrecoveries` (`idrecovery`, `iduser`, `desip`, `dtrecovery`, `dtregister`) VALUES
(1, 7, '127.0.0.1', NULL, '2017-03-15 19:10:59'),
(2, 7, '127.0.0.1', '2017-03-15 13:33:45', '2017-03-15 19:11:18'),
(3, 7, '127.0.0.1', '2017-03-15 13:37:35', '2017-03-15 19:37:12'),
(4, 8, '127.0.0.1', '2019-09-11 15:52:39', '2019-09-11 18:51:53'),
(5, 12, '127.0.0.1', NULL, '2019-09-17 14:00:07'),
(6, 12, '127.0.0.1', '2019-09-17 11:28:54', '2019-09-17 14:01:47'),
(7, 8, '127.0.0.1', NULL, '2019-09-17 14:09:25'),
(8, 8, '127.0.0.1', NULL, '2019-09-17 14:10:27'),
(9, 8, '127.0.0.1', NULL, '2019-09-17 14:12:18'),
(10, 8, '127.0.0.1', NULL, '2019-09-17 14:13:06'),
(11, 8, '127.0.0.1', NULL, '2019-09-17 14:17:17'),
(12, 12, '127.0.0.1', NULL, '2019-09-17 14:17:59'),
(13, 12, '127.0.0.1', NULL, '2019-09-17 14:19:03'),
(14, 12, '127.0.0.1', NULL, '2019-09-17 14:29:32'),
(15, 12, '127.0.0.1', '2019-09-17 11:33:07', '2019-09-17 14:32:10'),
(16, 12, '127.0.0.1', '2019-09-22 14:47:18', '2019-09-22 17:46:59'),
(17, 12, '127.0.0.1', NULL, '2019-09-23 00:42:02'),
(18, 12, '127.0.0.1', NULL, '2019-09-23 00:45:06');

--
-- Índices para tabelas despejadas
--

--
-- Índices para tabela `tb_addresses`
--
ALTER TABLE `tb_addresses`
  ADD PRIMARY KEY (`idaddress`),
  ADD KEY `fk_addresses_persons_idx` (`idperson`);

--
-- Índices para tabela `tb_carts`
--
ALTER TABLE `tb_carts`
  ADD PRIMARY KEY (`idcart`),
  ADD KEY `FK_carts_users_idx` (`iduser`);

--
-- Índices para tabela `tb_cartsproducts`
--
ALTER TABLE `tb_cartsproducts`
  ADD PRIMARY KEY (`idcartproduct`),
  ADD KEY `FK_cartsproducts_carts_idx` (`idcart`),
  ADD KEY `FK_cartsproducts_products_idx` (`idproduct`);

--
-- Índices para tabela `tb_categories`
--
ALTER TABLE `tb_categories`
  ADD PRIMARY KEY (`idcategory`);

--
-- Índices para tabela `tb_orders`
--
ALTER TABLE `tb_orders`
  ADD PRIMARY KEY (`idorder`),
  ADD KEY `FK_orders_users_idx` (`iduser`),
  ADD KEY `fk_orders_ordersstatus_idx` (`idstatus`),
  ADD KEY `fk_orders_carts_idx` (`idcart`),
  ADD KEY `fk_orders_addresses_idx` (`idaddress`);

--
-- Índices para tabela `tb_ordersstatus`
--
ALTER TABLE `tb_ordersstatus`
  ADD PRIMARY KEY (`idstatus`);

--
-- Índices para tabela `tb_persons`
--
ALTER TABLE `tb_persons`
  ADD PRIMARY KEY (`idperson`);

--
-- Índices para tabela `tb_products`
--
ALTER TABLE `tb_products`
  ADD PRIMARY KEY (`idproduct`);

--
-- Índices para tabela `tb_productscategories`
--
ALTER TABLE `tb_productscategories`
  ADD PRIMARY KEY (`idcategory`,`idproduct`),
  ADD KEY `fk_productscategories_products_idx` (`idproduct`);

--
-- Índices para tabela `tb_users`
--
ALTER TABLE `tb_users`
  ADD PRIMARY KEY (`iduser`),
  ADD KEY `FK_users_persons_idx` (`idperson`);

--
-- Índices para tabela `tb_userslogs`
--
ALTER TABLE `tb_userslogs`
  ADD PRIMARY KEY (`idlog`),
  ADD KEY `fk_userslogs_users_idx` (`iduser`);

--
-- Índices para tabela `tb_userspasswordsrecoveries`
--
ALTER TABLE `tb_userspasswordsrecoveries`
  ADD PRIMARY KEY (`idrecovery`),
  ADD KEY `fk_userspasswordsrecoveries_users_idx` (`iduser`);

--
-- AUTO_INCREMENT de tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `tb_addresses`
--
ALTER TABLE `tb_addresses`
  MODIFY `idaddress` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT de tabela `tb_carts`
--
ALTER TABLE `tb_carts`
  MODIFY `idcart` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT de tabela `tb_cartsproducts`
--
ALTER TABLE `tb_cartsproducts`
  MODIFY `idcartproduct` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=102;

--
-- AUTO_INCREMENT de tabela `tb_categories`
--
ALTER TABLE `tb_categories`
  MODIFY `idcategory` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de tabela `tb_orders`
--
ALTER TABLE `tb_orders`
  MODIFY `idorder` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT de tabela `tb_ordersstatus`
--
ALTER TABLE `tb_ordersstatus`
  MODIFY `idstatus` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de tabela `tb_persons`
--
ALTER TABLE `tb_persons`
  MODIFY `idperson` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT de tabela `tb_products`
--
ALTER TABLE `tb_products`
  MODIFY `idproduct` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de tabela `tb_users`
--
ALTER TABLE `tb_users`
  MODIFY `iduser` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT de tabela `tb_userslogs`
--
ALTER TABLE `tb_userslogs`
  MODIFY `idlog` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `tb_userspasswordsrecoveries`
--
ALTER TABLE `tb_userspasswordsrecoveries`
  MODIFY `idrecovery` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- Restrições para despejos de tabelas
--

--
-- Limitadores para a tabela `tb_addresses`
--
ALTER TABLE `tb_addresses`
  ADD CONSTRAINT `fk_addresses_persons` FOREIGN KEY (`idperson`) REFERENCES `tb_persons` (`idperson`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `tb_carts`
--
ALTER TABLE `tb_carts`
  ADD CONSTRAINT `fk_carts_users` FOREIGN KEY (`iduser`) REFERENCES `tb_users` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `tb_cartsproducts`
--
ALTER TABLE `tb_cartsproducts`
  ADD CONSTRAINT `fk_cartsproducts_carts` FOREIGN KEY (`idcart`) REFERENCES `tb_carts` (`idcart`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_cartsproducts_products` FOREIGN KEY (`idproduct`) REFERENCES `tb_products` (`idproduct`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `tb_orders`
--
ALTER TABLE `tb_orders`
  ADD CONSTRAINT `fk_orders_addresses` FOREIGN KEY (`idaddress`) REFERENCES `tb_addresses` (`idaddress`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_orders_carts` FOREIGN KEY (`idcart`) REFERENCES `tb_carts` (`idcart`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_orders_ordersstatus` FOREIGN KEY (`idstatus`) REFERENCES `tb_ordersstatus` (`idstatus`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_orders_users` FOREIGN KEY (`iduser`) REFERENCES `tb_users` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `tb_productscategories`
--
ALTER TABLE `tb_productscategories`
  ADD CONSTRAINT `fk_productscategories_categories` FOREIGN KEY (`idcategory`) REFERENCES `tb_categories` (`idcategory`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_productscategories_products` FOREIGN KEY (`idproduct`) REFERENCES `tb_products` (`idproduct`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `tb_users`
--
ALTER TABLE `tb_users`
  ADD CONSTRAINT `fk_users_persons` FOREIGN KEY (`idperson`) REFERENCES `tb_persons` (`idperson`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `tb_userslogs`
--
ALTER TABLE `tb_userslogs`
  ADD CONSTRAINT `fk_userslogs_users` FOREIGN KEY (`iduser`) REFERENCES `tb_users` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `tb_userspasswordsrecoveries`
--
ALTER TABLE `tb_userspasswordsrecoveries`
  ADD CONSTRAINT `fk_userspasswordsrecoveries_users` FOREIGN KEY (`iduser`) REFERENCES `tb_users` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
