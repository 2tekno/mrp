-- --------------------------------------------------------
-- Host:                         mrpmanager.com
-- Server version:               5.5.42-37.1 - Percona Server (GPL), Release 37.1, Revision 727
-- Server OS:                    Linux
-- HeidiSQL Version:             9.3.0.4984
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping database structure for tekno_node
CREATE DATABASE IF NOT EXISTS `tekno_node` /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci */;
USE `tekno_node`;


-- Dumping structure for table tekno_node.category
CREATE TABLE IF NOT EXISTS `category` (
  `CategoryID` bigint(20) NOT NULL AUTO_INCREMENT,
  `ParentCategoryID` bigint(20) DEFAULT '0',
  `CategoryDescription` varchar(200) DEFAULT NULL,
  `CategoryDescriptionFull` varchar(1000) DEFAULT NULL,
  `Created` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`CategoryID`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8;

-- Dumping data for table tekno_node.category: ~26 rows (approximately)
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` (`CategoryID`, `ParentCategoryID`, `CategoryDescription`, `CategoryDescriptionFull`, `Created`) VALUES
	(1, 0, 'Antique', 'Antique', NULL),
	(2, 0, 'Art', 'Art', NULL),
	(3, 1, 'Architectural & Garden', 'Architectural & Garden', NULL),
	(4, 1, 'Asian Antiques', 'Asian Antiques', NULL),
	(5, 1, 'Books & Manuscripts', 'Books & Manuscripts', NULL),
	(6, 1, 'Decorative Arts', 'Decorative Arts', NULL),
	(7, 2, 'Direct from the Artist', 'Direct from the Artist', NULL),
	(8, 2, 'Art from Dealers & Resellers', 'Art from Dealers & Resellers', NULL),
	(9, 0, 'Books', 'Books', NULL),
	(10, 0, 'Business & Industrial', 'Business & Industrial', NULL),
	(11, 10, 'Agriculture & Forestry', 'Agriculture & Forestry', NULL),
	(12, 0, 'Construction', 'Construction', NULL),
	(13, 10, 'Electrical & Test Equipment', 'Electrical & Test Equipment', NULL),
	(14, 0, 'Automotive', 'Automotive', NULL),
	(15, 2, 'Wholesale Lots', 'Wholesale Lots', NULL),
	(16, 0, 'Cameras & Photo', 'Cameras & Photo', NULL),
	(17, 16, 'Binoculars & Telescopes', 'Binoculars & Telescopes', NULL),
	(18, 0, 'Camera Drones', 'Camera Drones', NULL),
	(19, 0, 'Camcorders', 'Camcorders', NULL),
	(20, 0, 'Digital Cameras', 'Digital Cameras', NULL),
	(21, 0, 'Camera & Photo Accessories', 'Camera & Photo Accessories', NULL),
	(22, 0, 'Digital Photo Frames', 'Digital Photo Frames', NULL),
	(23, 0, 'Film Photography', 'Film Photography', NULL),
	(24, 0, 'Flashes & Flash Accessories', 'Flashes & Flash Accessories', NULL),
	(25, 0, 'Lenses & Filters', 'Lenses & Filters', NULL),
	(26, 0, 'Cell Phones & Accessories', 'Cell Phones & Accessories', NULL);
/*!40000 ALTER TABLE `category` ENABLE KEYS */;


-- Dumping structure for table tekno_node.categoryproperty
CREATE TABLE IF NOT EXISTS `categoryproperty` (
  `CategoryPropertyID` bigint(20) NOT NULL AUTO_INCREMENT,
  `CategoryID` bigint(20) NOT NULL,
  `PropertyID` bigint(20) NOT NULL,
  `PropertyValue` varchar(200) DEFAULT NULL,
  `Sequence` tinytext,
  `Created` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`CategoryPropertyID`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

-- Dumping data for table tekno_node.categoryproperty: ~6 rows (approximately)
/*!40000 ALTER TABLE `categoryproperty` DISABLE KEYS */;
INSERT INTO `categoryproperty` (`CategoryPropertyID`, `CategoryID`, `PropertyID`, `PropertyValue`, `Sequence`, `Created`) VALUES
	(1, 14, 4, 'Honda', NULL, NULL),
	(2, 14, 7, '100K', NULL, NULL),
	(3, 14, 9, '2020rssarara', NULL, NULL),
	(4, 14, 1, 'Red', NULL, NULL),
	(6, 9, 10, 'mmmmmmmmmmm', NULL, NULL),
	(7, 9, 11, 'New', NULL, NULL);
/*!40000 ALTER TABLE `categoryproperty` ENABLE KEYS */;


-- Dumping structure for table tekno_node.posting
CREATE TABLE IF NOT EXISTS `posting` (
  `PostingID` bigint(20) NOT NULL AUTO_INCREMENT,
  `UserID` bigint(20) NOT NULL,
  `CategoryID` bigint(20) NOT NULL,
  `PostingText` varchar(1000) NOT NULL,
  `Title` varchar(1000) NOT NULL,
  `Price` decimal(14,2) DEFAULT NULL,
  `Active` bit(1) DEFAULT NULL,
  `DeletedByUser` bit(1) DEFAULT NULL,
  `Created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Edited` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `Expired` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `IpAddress` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`PostingID`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8;

-- Dumping data for table tekno_node.posting: ~0 rows (approximately)
/*!40000 ALTER TABLE `posting` DISABLE KEYS */;
INSERT INTO `posting` (`PostingID`, `UserID`, `CategoryID`, `PostingText`, `Title`, `Price`, `Active`, `DeletedByUser`, `Created`, `Edited`, `Expired`, `IpAddress`) VALUES
	(1, 18, 9, 'Description here', 'Title here', 123.00, NULL, NULL, '2016-05-12 16:52:50', '0000-00-00 00:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
	(2, 18, 14, 'Dxxxxxxxxxxxxxxx', 'xxxxxxxx', 555.00, NULL, NULL, '2016-05-12 16:54:19', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
	(3, 18, 9, 'werewrw', 'werwrw', 333.00, NULL, NULL, '2016-05-12 16:57:21', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
	(4, 18, 9, 'jfjf', 'fgjfgh', 44567.00, NULL, NULL, '2016-05-12 16:58:49', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
	(5, 18, 9, 'xxxxxxxxxx', 'xxxxxxxxxxx', 222.00, b'0', NULL, '2016-05-12 17:18:03', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
	(6, 18, 9, 'Description hereegrerge', 'fgerg', 333.00, b'0', NULL, '2016-05-12 17:21:10', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
	(7, 18, 9, 'Description here', 'Title here', 333.00, b'0', NULL, '2016-05-12 17:24:25', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
	(8, 18, 9, 'Description here', 'Title here', 333.00, b'0', NULL, '2016-05-12 17:34:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
	(9, 18, 9, 'Description here', 'Title here', 333.00, b'0', NULL, '2016-05-12 17:36:06', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
	(10, 18, 9, 'aaaaaaaaaa', 'aaaaaa', 333.00, b'0', NULL, '2016-05-12 17:38:41', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
	(11, 18, 9, 'aaaaaaaaaa', 'aaaaaa', 333.00, b'0', NULL, '2016-05-12 17:40:49', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
	(12, 18, 9, 'efwefw', 'sdfwdfw', 222.00, b'0', NULL, '2016-05-12 17:45:03', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
	(13, 18, 9, 'efwefw', 'sdfwdfw', 222.00, b'0', NULL, '2016-05-12 17:49:52', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
	(14, 18, 9, 'efwefw', 'sdfwdfw', 222.00, b'0', NULL, '2016-05-12 17:52:46', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
	(15, 18, 9, 'efwefw', 'sdfwdfw', 222.00, b'0', NULL, '2016-05-12 18:15:18', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
	(16, 18, 9, 'efwefw', 'sdfwdfw', 222.00, b'0', NULL, '2016-05-12 18:15:18', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
	(17, 18, 9, 'efwefw', 'sdfwdfw', 222.00, b'0', NULL, '2016-05-12 18:15:18', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
	(18, 18, 9, 'efwefw', 'sdfwdfw', 222.00, b'0', NULL, '2016-05-12 18:20:18', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
	(19, 18, 9, 'efwefw', 'sdfwdfw', 222.00, b'0', NULL, '2016-05-12 18:21:03', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
	(20, 18, 9, 'efwefw', 'sdfwdfw', 222.00, b'0', NULL, '2016-05-12 18:22:55', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
	(21, 18, 9, 'efwefw', 'sdfwdfw', 222.00, b'0', NULL, '2016-05-12 18:24:39', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
	(22, 18, 9, 'efwefw', 'sdfwdfw', 222.00, b'0', NULL, '2016-05-12 18:27:23', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
	(23, 18, 9, 'efwefw', 'sdfwdfw', 222.00, b'0', NULL, '2016-05-12 18:28:59', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
	(24, 18, 14, 'Description here', 'Title here', 1234.00, b'0', NULL, '2016-05-12 18:31:11', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
	(25, 18, 14, 'Description heretyjtyj', 'Title herevb gntyt', 70000.00, b'0', NULL, '2016-05-12 23:10:52', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
	(26, 18, 9, 'Description here', 'Title here', 5555.00, b'0', NULL, '2016-05-12 23:43:07', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL),
	(27, 18, 19, 'Description here', 'Title here', 111.00, b'0', NULL, '2016-05-13 00:22:22', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL);
/*!40000 ALTER TABLE `posting` ENABLE KEYS */;


-- Dumping structure for table tekno_node.postingproperty
CREATE TABLE IF NOT EXISTS `postingproperty` (
  `PostingPropertyID` bigint(20) NOT NULL AUTO_INCREMENT,
  `PostingID` bigint(20) NOT NULL,
  `PropertyID` bigint(20) NOT NULL,
  `PropertyValue` varchar(200) DEFAULT NULL,
  `Created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`PostingPropertyID`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

-- Dumping data for table tekno_node.postingproperty: ~0 rows (approximately)
/*!40000 ALTER TABLE `postingproperty` DISABLE KEYS */;
INSERT INTO `postingproperty` (`PostingPropertyID`, `PostingID`, `PropertyID`, `PropertyValue`, `Created`) VALUES
	(1, 23, 10, 'weqdqwdq', '2016-05-12 18:28:59'),
	(2, 23, 11, 'used', '2016-05-12 18:28:59'),
	(3, 24, 4, 'fddgfdg', '2016-05-12 18:31:11'),
	(4, 24, 7, 'dfgdg', '2016-05-12 18:31:11'),
	(5, 24, 9, '2012', '2016-05-12 18:31:11'),
	(6, 24, 1, 'dfgd', '2016-05-12 18:31:11'),
	(7, 25, 4, 'Honda', '2016-05-12 23:10:52'),
	(8, 25, 7, '100K', '2016-05-12 23:10:52'),
	(9, 25, 9, '2020rssarara', '2016-05-12 23:10:52'),
	(10, 25, 1, 'Red', '2016-05-12 23:10:52'),
	(11, 26, 10, 'mmmmmmmmmmm', '2016-05-12 23:43:07'),
	(12, 26, 11, 'New', '2016-05-12 23:43:07');
/*!40000 ALTER TABLE `postingproperty` ENABLE KEYS */;


-- Dumping structure for table tekno_node.property
CREATE TABLE IF NOT EXISTS `property` (
  `PropertyID` bigint(20) NOT NULL AUTO_INCREMENT,
  `PropertyDescription` varchar(200) DEFAULT NULL,
  `PropertyDescriptionFull` varchar(1000) DEFAULT NULL,
  `PropertyDataTypeID` int(11) DEFAULT NULL,
  `Created` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`PropertyID`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

-- Dumping data for table tekno_node.property: ~8 rows (approximately)
/*!40000 ALTER TABLE `property` DISABLE KEYS */;
INSERT INTO `property` (`PropertyID`, `PropertyDescription`, `PropertyDescriptionFull`, `PropertyDataTypeID`, `Created`) VALUES
	(1, 'Color', 'Color', 3, NULL),
	(3, 'Size', 'Size', 1, NULL),
	(4, 'Make', 'Make', 3, NULL),
	(7, 'Mileage', 'Mileage', 1, NULL),
	(8, 'Model', 'Model', 1, NULL),
	(9, 'Year', 'Year', 2, NULL),
	(10, 'Author', 'Author', 1, NULL),
	(11, 'Condition', 'Condition', 1, NULL);
/*!40000 ALTER TABLE `property` ENABLE KEYS */;


-- Dumping structure for table tekno_node.propertydatatype
CREATE TABLE IF NOT EXISTS `propertydatatype` (
  `PropertyDataTypeID` bigint(20) NOT NULL AUTO_INCREMENT,
  `PropertyDataTypeDescription` varchar(200) DEFAULT NULL,
  `Created` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`PropertyDataTypeID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- Dumping data for table tekno_node.propertydatatype: ~3 rows (approximately)
/*!40000 ALTER TABLE `propertydatatype` DISABLE KEYS */;
INSERT INTO `propertydatatype` (`PropertyDataTypeID`, `PropertyDataTypeDescription`, `Created`) VALUES
	(1, 'Text', NULL),
	(2, 'Number', NULL),
	(3, 'List', NULL);
/*!40000 ALTER TABLE `propertydatatype` ENABLE KEYS */;


-- Dumping structure for table tekno_node.users
CREATE TABLE IF NOT EXISTS `users` (
  `UserID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `UserName` varchar(30) DEFAULT '',
  `FirstName` varchar(30) DEFAULT '',
  `LastName` varchar(30) DEFAULT '',
  `Email` varchar(70) DEFAULT '',
  `Password` varchar(60) NOT NULL DEFAULT '',
  `Active` bit(1) NOT NULL DEFAULT b'1',
  `Created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Modified` timestamp NULL DEFAULT NULL,
  `Salt` varchar(50) NOT NULL DEFAULT '',
  `IpAddress` varchar(50) DEFAULT '',
  PRIMARY KEY (`UserID`),
  UNIQUE KEY `email` (`Email`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8;

-- Dumping data for table tekno_node.users: ~1 rows (approximately)
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` (`UserID`, `UserName`, `FirstName`, `LastName`, `Email`, `Password`, `Active`, `Created`, `Modified`, `Salt`, `IpAddress`) VALUES
	(18, '2tekno@gmail.com', '', '', '', '$2a$10$X6LBQHrrboFQ7KQwCHayTuGffzBp/eqeh49n2X2jSkIhgBtiz1QeO', b'1', '0000-00-00 00:00:00', '2016-04-20 22:08:10', '', '');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
