-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               5.7.21-log - MySQL Community Server (GPL)
-- Server OS:                    Win32
-- HeidiSQL Version:             9.5.0.5196
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dumping database structure for mrp-dev
DROP DATABASE IF EXISTS `mrp-dev`;
CREATE DATABASE IF NOT EXISTS `mrp-dev` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `mrp-dev`;

-- Dumping structure for table mrp-dev.email_verification
DROP TABLE IF EXISTS `email_verification`;
CREATE TABLE IF NOT EXISTS `email_verification` (
  `userID` char(36) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `email` varchar(255) NOT NULL,
  `verification_code` varchar(255) DEFAULT NULL,
  `was_used` tinyint(4) DEFAULT NULL,
  `ipAddress` varchar(255) DEFAULT NULL,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`userID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table mrp-dev.email_verification: ~0 rows (approximately)
DELETE FROM `email_verification`;
/*!40000 ALTER TABLE `email_verification` DISABLE KEYS */;
INSERT INTO `email_verification` (`userID`, `email`, `verification_code`, `was_used`, `ipAddress`, `createdAt`, `updatedAt`) VALUES
	('0d85a184-ec48-4ec8-8c36-c37e674af38c', '2tekno@gmail.com', '$2a$10$SldzRVSV44bUmRUeUr5SDujxS9WYLzm5gKYojckYvFoOZGQSkUkPe', 0, NULL, '2018-11-20 15:34:21', '2018-11-20 15:34:21');
/*!40000 ALTER TABLE `email_verification` ENABLE KEYS */;

-- Dumping structure for table mrp-dev.user
DROP TABLE IF EXISTS `user`;
CREATE TABLE IF NOT EXISTS `user` (
  `userID` char(36) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `userName` varchar(255) NOT NULL,
  `accountType` varchar(255) DEFAULT NULL,
  `firstName` varchar(255) NOT NULL,
  `lastName` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) DEFAULT NULL,
  `active` tinyint(1) NOT NULL,
  `salt` varchar(255) DEFAULT NULL,
  `ipAddress` varchar(255) DEFAULT NULL,
  `role` varchar(255) DEFAULT NULL,
  `licType` varchar(255) DEFAULT NULL,
  `licExpire` datetime DEFAULT NULL,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`userID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table mrp-dev.user: ~0 rows (approximately)
DELETE FROM `user`;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` (`userID`, `userName`, `accountType`, `firstName`, `lastName`, `email`, `password`, `active`, `salt`, `ipAddress`, `role`, `licType`, `licExpire`, `createdAt`, `updatedAt`) VALUES
	('0d85a184-ec48-4ec8-8c36-c37e674af38c', '2tekno@gmail.com', 'local', '', '', '2tekno@gmail.com', '$2a$10$UM45K/7Gr4CT0RcFMfREUu7oO2TZDzYqaCHygdQ7XkGxOkE6wPiJW', 0, NULL, '0', '', 'trial', '2018-12-04 15:34:18', '2018-11-20 15:34:18', '2018-11-20 15:34:18');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
