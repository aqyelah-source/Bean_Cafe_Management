-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: localhost    Database: bean_cafe_db
-- ------------------------------------------------------
-- Server version	5.5.5-10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin` (
  `admin_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`admin_id`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `fk_admin_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
INSERT INTO `admin` VALUES (1,1);
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `menu`
--

DROP TABLE IF EXISTS `menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `menu` (
  `menu_id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) NOT NULL,
  `menu_name` varchar(100) NOT NULL,
  `category` varchar(50) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `availability` varchar(20) NOT NULL,
  PRIMARY KEY (`menu_id`),
  KEY `fk_menu_admin` (`admin_id`),
  CONSTRAINT `fk_menu_admin` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`admin_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menu`
--

LOCK TABLES `menu` WRITE;
/*!40000 ALTER TABLE `menu` DISABLE KEYS */;
INSERT INTO `menu` VALUES (1,1,'Americano','Coffee',7.00,'Available'),(2,1,'Cafe Latte','Coffee',10.00,'Available'),(3,1,'Cappuccino','Coffee',10.00,'Available'),(5,1,'Chocolate','Non-Coffee',9.00,'Available'),(6,1,'Matcha Latte','Non-Coffee',11.00,'Available'),(7,1,'Strawberry Milk','Non-Coffee',10.00,'Available'),(8,1,'Peach Tea','Non-Coffee',8.00,'Available'),(9,1,'Chocolate Cake','Dessert',12.00,'Available'),(10,1,'Cheesecake','Dessert',13.00,'Available'),(11,1,'Tiramisu','Dessert',14.00,'Available'),(12,1,'Croissant','Dessert',8.00,'Available'),(14,1,'Brownies','Dessert',12.00,'Available');
/*!40000 ALTER TABLE `menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_history`
--

DROP TABLE IF EXISTS `order_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_history` (
  `history_id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL,
  `status` varchar(20) NOT NULL,
  `updated_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`history_id`),
  KEY `fk_history_order` (`order_id`),
  CONSTRAINT `fk_history_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=92 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_history`
--

LOCK TABLES `order_history` WRITE;
/*!40000 ALTER TABLE `order_history` DISABLE KEYS */;
INSERT INTO `order_history` VALUES (40,16,'Pending','2026-09-29 23:49:41'),(41,17,'Pending','2026-09-29 23:50:05'),(42,18,'Pending','2026-09-29 23:50:17'),(43,19,'Pending','2026-09-29 23:50:22'),(44,20,'Pending','2026-09-29 23:50:30'),(45,21,'Pending','2026-09-30 00:19:56'),(46,16,'Preparing','2026-09-30 00:20:03'),(47,16,'Ready','2026-09-30 00:20:06'),(48,16,'Completed','2026-09-30 00:20:08'),(49,17,'Preparing','2026-09-30 00:20:16'),(50,17,'Ready','2026-09-30 00:20:19'),(51,17,'Completed','2026-09-30 00:20:22'),(52,18,'Preparing','2026-09-30 00:20:27'),(53,18,'Ready','2026-09-30 00:20:30'),(54,18,'Completed','2026-09-30 00:20:35'),(55,19,'Preparing','2026-09-30 00:20:43'),(56,19,'Ready','2026-09-30 00:20:48'),(57,19,'Completed','2026-09-30 00:20:53'),(58,20,'Preparing','2026-09-30 00:20:59'),(59,20,'Ready','2026-09-30 00:21:02'),(60,20,'Completed','2026-09-30 00:21:09'),(61,21,'Preparing','2026-09-30 00:21:16'),(62,21,'Ready','2026-09-30 00:21:19'),(63,21,'Completed','2026-09-30 00:21:24'),(64,22,'Pending','2026-09-30 00:22:07'),(65,23,'Pending','2026-09-30 00:22:16'),(66,24,'Pending','2026-09-30 00:22:22'),(67,25,'Pending','2026-09-30 00:22:27'),(68,22,'Preparing','2026-09-30 00:22:33'),(69,23,'Preparing','2026-09-30 00:22:42'),(70,24,'Cancelled','2026-09-30 00:22:52'),(71,25,'Preparing','2026-09-30 00:23:02'),(72,26,'Pending','2026-09-30 00:24:08'),(73,27,'Pending','2026-09-30 00:24:14'),(74,28,'Pending','2026-09-30 00:24:21'),(75,22,'Ready','2026-09-30 00:24:56'),(76,23,'Ready','2026-09-30 00:25:03'),(77,29,'Pending','2026-09-30 10:27:41'),(78,26,'Preparing','2026-09-30 11:06:23'),(79,22,'Completed','2026-09-30 11:06:38'),(80,133,'Pending','2026-10-01 11:32:47'),(81,133,'Preparing','2026-10-01 11:45:43'),(82,133,'Ready','2026-10-01 11:45:54'),(83,133,'Completed','2026-10-01 11:46:03'),(84,134,'Pending','2026-10-01 12:58:51'),(85,134,'Preparing','2026-10-01 13:05:07'),(86,134,'Ready','2026-10-01 13:05:17'),(87,134,'Completed','2026-10-01 13:05:26'),(88,135,'Pending','2026-10-01 14:41:41'),(89,135,'Preparing','2026-10-01 14:42:35'),(90,135,'Ready','2026-10-01 14:42:45'),(91,135,'Completed','2026-10-01 14:42:50');
/*!40000 ALTER TABLE `order_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_items` (
  `order_item_id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL,
  `menu_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  PRIMARY KEY (`order_item_id`),
  KEY `fk_orderitems_order` (`order_id`),
  KEY `fk_orderitems_menu` (`menu_id`),
  CONSTRAINT `fk_orderitems_menu` FOREIGN KEY (`menu_id`) REFERENCES `menu` (`menu_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_orderitems_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES (27,16,11,1,14.00),(28,16,10,1,13.00),(29,16,3,1,10.00),(30,16,2,1,10.00),(31,17,7,1,10.00),(32,17,5,1,9.00),(33,17,3,1,10.00),(34,18,12,1,8.00),(35,18,11,1,14.00),(37,19,2,1,10.00),(38,20,12,1,8.00),(39,20,9,1,12.00),(40,21,12,1,8.00),(41,21,11,1,14.00),(42,21,3,1,10.00),(43,21,2,1,10.00),(44,22,3,1,10.00),(45,22,2,1,10.00),(46,23,14,1,12.00),(47,23,7,1,10.00),(48,24,3,1,10.00),(49,24,2,1,10.00),(50,25,12,1,8.00),(51,25,10,1,13.00),(52,26,12,1,8.00),(53,26,11,1,14.00),(54,27,12,1,8.00),(55,27,2,1,10.00),(56,28,9,1,12.00),(57,28,8,1,8.00),(58,29,2,1,10.00),(59,29,1,1,7.00),(60,133,9,1,12.00),(62,134,11,2,28.00),(63,134,7,1,10.00),(64,135,12,2,16.00),(65,135,2,1,10.00);
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `order_id` int(11) NOT NULL AUTO_INCREMENT,
  `staff_id` int(11) NOT NULL,
  `order_date` datetime NOT NULL DEFAULT current_timestamp(),
  `total_price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `status` varchar(20) NOT NULL DEFAULT 'Preparing',
  PRIMARY KEY (`order_id`),
  KEY `fk_orders_staff` (`staff_id`),
  CONSTRAINT `fk_orders_staff` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`staff_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=136 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (16,14,'2026-09-29 23:49:41',47.00,'Completed'),(17,14,'2026-09-29 23:50:05',29.00,'Completed'),(18,14,'2026-09-29 23:50:17',34.00,'Completed'),(19,14,'2026-09-29 23:50:22',10.00,'Completed'),(20,14,'2026-09-29 23:50:30',20.00,'Completed'),(21,13,'2026-09-30 00:19:56',42.00,'Completed'),(22,13,'2026-09-30 00:22:07',20.00,'Completed'),(23,13,'2026-09-30 00:22:16',22.00,'Ready'),(24,13,'2026-09-30 00:22:22',20.00,'Cancelled'),(25,13,'2026-09-30 00:22:27',21.00,'Preparing'),(26,12,'2026-09-30 00:24:08',22.00,'Preparing'),(27,12,'2026-09-30 00:24:14',18.00,'Pending'),(28,12,'2026-09-30 00:24:21',20.00,'Pending'),(29,14,'2026-09-30 10:27:41',17.00,'Pending'),(30,12,'2026-01-03 08:35:00',18.50,'Completed'),(31,13,'2026-01-05 10:20:00',27.00,'Completed'),(32,14,'2026-01-08 12:45:00',42.50,'Completed'),(33,15,'2026-01-11 15:10:00',21.00,'Completed'),(34,12,'2026-01-14 09:25:00',36.50,'Completed'),(35,13,'2026-01-17 13:40:00',49.00,'Completed'),(36,14,'2026-01-20 16:15:00',24.50,'Completed'),(37,15,'2026-01-23 11:30:00',31.00,'Completed'),(38,12,'2026-01-26 14:20:00',55.50,'Completed'),(39,13,'2026-01-29 17:05:00',29.00,'Completed'),(40,13,'2026-02-02 08:50:00',23.00,'Completed'),(41,14,'2026-02-04 10:15:00',38.50,'Completed'),(42,15,'2026-02-06 12:30:00',44.00,'Completed'),(43,12,'2026-02-08 14:20:00',19.50,'Completed'),(44,13,'2026-02-10 09:40:00',33.00,'Completed'),(45,14,'2026-02-12 13:10:00',51.50,'Completed'),(46,15,'2026-02-14 16:25:00',28.00,'Completed'),(47,12,'2026-02-16 11:45:00',46.00,'Completed'),(48,13,'2026-02-18 08:30:00',25.50,'Completed'),(49,14,'2026-02-20 12:40:00',57.00,'Completed'),(50,15,'2026-02-23 15:20:00',35.00,'Completed'),(51,12,'2026-02-26 17:10:00',41.50,'Completed'),(52,14,'2026-03-02 09:10:00',30.50,'Completed'),(53,15,'2026-03-04 11:30:00',45.00,'Completed'),(54,12,'2026-03-07 13:15:00',22.50,'Completed'),(55,13,'2026-03-10 15:40:00',55.00,'Completed'),(56,14,'2026-03-13 08:45:00',37.00,'Completed'),(57,15,'2026-03-16 12:20:00',48.50,'Completed'),(58,12,'2026-03-19 14:50:00',26.00,'Completed'),(59,13,'2026-03-21 17:05:00',41.50,'Completed'),(60,14,'2026-03-24 10:10:00',62.00,'Completed'),(61,15,'2026-03-27 13:30:00',34.50,'Completed'),(62,12,'2026-03-30 16:00:00',50.00,'Completed'),(63,15,'2026-04-02 08:30:00',35.00,'Completed'),(64,12,'2026-04-04 10:45:00',52.50,'Completed'),(65,13,'2026-04-06 12:15:00',29.00,'Completed'),(66,14,'2026-04-08 14:35:00',43.50,'Completed'),(67,15,'2026-04-10 09:20:00',61.00,'Completed'),(68,12,'2026-04-12 13:00:00',24.50,'Completed'),(69,13,'2026-04-14 16:10:00',39.00,'Completed'),(70,14,'2026-04-16 11:50:00',47.00,'Completed'),(71,15,'2026-04-18 08:40:00',58.50,'Completed'),(72,12,'2026-04-20 12:30:00',32.00,'Completed'),(73,13,'2026-04-22 15:15:00',66.00,'Completed'),(74,14,'2026-04-24 17:20:00',27.50,'Completed'),(75,15,'2026-04-27 10:25:00',49.50,'Completed'),(76,12,'2026-04-29 14:10:00',54.00,'Completed'),(77,12,'2026-05-02 08:40:00',41.50,'Completed'),(78,13,'2026-05-04 10:30:00',28.00,'Completed'),(79,14,'2026-05-06 12:20:00',56.50,'Completed'),(80,15,'2026-05-08 15:00:00',34.00,'Completed'),(81,12,'2026-05-10 09:15:00',62.00,'Completed'),(82,13,'2026-05-12 13:35:00',45.50,'Completed'),(83,14,'2026-05-15 16:30:00',31.00,'Completed'),(84,15,'2026-05-18 11:10:00',53.00,'Completed'),(85,12,'2026-05-20 08:55:00',26.50,'Completed'),(86,13,'2026-05-22 12:45:00',67.00,'Completed'),(87,14,'2026-05-24 14:30:00',48.00,'Completed'),(88,15,'2026-05-27 16:10:00',37.50,'Completed'),(89,12,'2026-05-30 10:20:00',59.00,'Completed'),(90,13,'2026-06-02 08:25:00',32.50,'Completed'),(91,14,'2026-06-04 10:50:00',58.00,'Completed'),(92,15,'2026-06-06 12:40:00',40.00,'Completed'),(93,12,'2026-06-08 14:15:00',67.50,'Completed'),(94,13,'2026-06-10 09:35:00',29.50,'Completed'),(95,14,'2026-06-12 13:25:00',51.00,'Completed'),(96,15,'2026-06-14 16:45:00',36.00,'Completed'),(97,12,'2026-06-16 11:20:00',60.50,'Completed'),(98,13,'2026-06-18 14:05:00',44.00,'Completed'),(99,14,'2026-06-20 08:50:00',72.00,'Completed'),(100,15,'2026-06-22 12:30:00',33.50,'Completed'),(101,12,'2026-06-24 15:10:00',55.00,'Completed'),(102,13,'2026-06-26 17:00:00',46.50,'Completed'),(103,14,'2026-06-28 10:40:00',64.00,'Completed'),(104,15,'2026-06-30 13:50:00',38.00,'Completed'),(105,14,'2026-07-02 08:45:00',44.00,'Completed'),(106,15,'2026-07-04 10:10:00',63.00,'Completed'),(107,12,'2026-07-06 12:25:00',35.50,'Completed'),(108,13,'2026-07-09 14:40:00',72.00,'Completed'),(109,14,'2026-07-12 09:30:00',48.50,'Completed'),(110,15,'2026-07-15 13:15:00',57.00,'Completed'),(111,12,'2026-07-18 16:20:00',31.50,'Completed'),(112,13,'2026-07-20 11:55:00',66.00,'Completed'),(113,14,'2026-07-22 08:35:00',39.00,'Completed'),(114,15,'2026-07-25 12:45:00',74.50,'Completed'),(115,12,'2026-07-27 15:20:00',52.00,'Completed'),(116,13,'2026-07-30 17:05:00',43.50,'Completed'),(117,15,'2026-08-02 08:30:00',51.00,'Completed'),(118,12,'2026-08-04 10:35:00',39.50,'Completed'),(119,13,'2026-08-06 12:50:00',74.00,'Completed'),(120,14,'2026-08-08 15:05:00',46.50,'Completed'),(121,15,'2026-08-10 09:40:00',68.00,'Completed'),(122,12,'2026-08-12 13:30:00',42.00,'Completed'),(123,13,'2026-08-14 16:15:00',59.50,'Completed'),(124,14,'2026-08-16 11:25:00',77.00,'Completed'),(125,15,'2026-08-18 14:40:00',33.50,'Completed'),(126,12,'2026-08-20 17:10:00',64.00,'Completed'),(127,13,'2026-08-22 08:50:00',48.50,'Completed'),(128,14,'2026-08-23 10:55:00',82.00,'Completed'),(129,15,'2026-08-25 12:30:00',37.00,'Completed'),(130,12,'2026-08-27 14:25:00',69.50,'Completed'),(131,13,'2026-08-29 16:40:00',55.00,'Completed'),(132,14,'2026-08-31 11:15:00',71.00,'Completed'),(133,14,'2026-10-01 11:32:47',36.00,'Completed'),(134,14,'2026-10-01 12:58:51',38.00,'Completed'),(135,14,'2026-10-01 14:41:41',26.00,'Completed');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `report`
--

DROP TABLE IF EXISTS `report`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `report` (
  `report_id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) NOT NULL,
  `report_month` int(11) NOT NULL,
  `report_year` int(11) NOT NULL,
  `total_orders` int(11) NOT NULL DEFAULT 0,
  `total_sales` decimal(10,2) NOT NULL DEFAULT 0.00,
  `generated_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`report_id`),
  KEY `fk_report_admin` (`admin_id`),
  CONSTRAINT `fk_report_admin` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`admin_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `report`
--

LOCK TABLES `report` WRITE;
/*!40000 ALTER TABLE `report` DISABLE KEYS */;
INSERT INTO `report` VALUES (1,1,9,2026,1,36.30,'2026-09-26 15:22:42'),(2,1,9,2026,1,28.80,'2026-09-26 18:00:20');
/*!40000 ALTER TABLE `report` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff`
--

DROP TABLE IF EXISTS `staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff` (
  `staff_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `admin_id` int(11) NOT NULL,
  `position` varchar(50) NOT NULL,
  `shift` varchar(20) NOT NULL,
  PRIMARY KEY (`staff_id`),
  UNIQUE KEY `user_id` (`user_id`),
  KEY `fk_staff_admin` (`admin_id`),
  CONSTRAINT `fk_staff_admin` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`admin_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_staff_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff`
--

LOCK TABLES `staff` WRITE;
/*!40000 ALTER TABLE `staff` DISABLE KEYS */;
INSERT INTO `staff` VALUES (12,13,1,'Cashier','Evening'),(13,14,1,'Barista','Evening'),(14,15,1,'Cashier','Morning'),(15,16,1,'Kitchen Staff','Evening');
/*!40000 ALTER TABLE `staff` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(20) NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'Bean Cafe Admin','admin01','$2a$10$nVvucVcDR7ZuCWzW7kAiYOKbB/Yus9qx4WKMEpCeDR7wwlyjDyCwW','Admin'),(13,'SITI NABILAH','nabilah01','$2a$10$viHjh8pgyhJypEqDvlWC8.J4sSi0EYBlTFp3VzWUYJTRjafHDdiHy','Staff'),(14,'SITI NUR AZMINA','mina01','$2a$10$2kvIkw.pRL9mdbQvv/Dzwu.SMp5kor/Z3Yn4E9rUUWXHxI6gpWQ3C','Staff'),(15,'AQIELAH','aqielah01','$2a$10$pUcCTE89c30caBJvcrTOH.iMdmlhfNKUwNpS/qnZ8uYFd5gJzpnOS','Staff'),(16,'NURUL AIN QISTINA','ain01','$2a$10$uPOjSdueXCK8iymCiIvRsOsKYdrYKBX5Jv.l9zoDfODH1hvyK89Cm','Staff');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-05 22:56:14
