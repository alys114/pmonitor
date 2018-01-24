-- MySQL dump 10.13  Distrib 5.5.55, for Linux (x86_64)
--
-- Host: localhost    Database: pmonitor
-- ------------------------------------------------------
-- Server version	5.5.55-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `hosts`
--

DROP TABLE IF EXISTS `hosts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hosts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `host` varchar(64) DEFAULT NULL,
  `ip` varchar(32) DEFAULT NULL,
  `port` varchar(8) DEFAULT NULL,
  `dns_name` varchar(64) DEFAULT NULL,
  `remark` varchar(128) DEFAULT NULL,
  `pc` varchar(64) DEFAULT NULL,
  `buy_year` varchar(64) DEFAULT NULL,
  `modify_user` varchar(64) DEFAULT NULL,
  `modify_datetime` datetime DEFAULT NULL,
  `hosts_group_id` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `hosts_group_id` (`hosts_group_id`),
  CONSTRAINT `hosts_ibfk_1` FOREIGN KEY (`hosts_group_id`) REFERENCES `hosts_group` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hosts`
--

LOCK TABLES `hosts` WRITE;
/*!40000 ALTER TABLE `hosts` DISABLE KEYS */;
INSERT INTO `hosts` VALUES (1,'db01','172.16.1.51','3306','db01','MySQL Server','HP 730','2015-12','root','2018-01-20 11:36:08',1,1),(2,'db02','172.16.1.52','3306','db02','MySQL Server','HP 730','2015-12','root','2018-01-20 11:36:08',1,1),(3,'web01','172.16.1.7','80','web01','Nginx Server','HP 730','2015-12','root','2018-01-20 11:36:08',2,1),(4,'web02','172.16.1.8','80','web02','Nginx Server','HP 730','2015-12','root','2018-01-20 11:36:08',2,1),(5,'lb01','172.16.1.9','80','lb01','LB Server','HP 730','2015-12','root','2018-01-20 12:25:58',2,1),(6,'lb02','172.16.1.10','80','lb02','LB Server','HP 730','2015-12','root','2018-01-20 12:25:29',2,1),(7,'Redis01','172.16.1.70','6379','Redis01','data cache','HP 710','2017','admin','2018-01-20 13:38:44',1,1);
/*!40000 ALTER TABLE `hosts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hosts_group`
--

DROP TABLE IF EXISTS `hosts_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hosts_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hosts_group`
--

LOCK TABLES `hosts_group` WRITE;
/*!40000 ALTER TABLE `hosts_group` DISABLE KEYS */;
INSERT INTO `hosts_group` VALUES (1,'db cluster'),(2,'web server');
/*!40000 ALTER TABLE `hosts_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) DEFAULT NULL,
  `password` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10000 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'dba','202cb962ac59075b964b07152d234b70'),(2,'web','202cb962ac59075b964b07152d234b70'),(9999,'root','202cb962ac59075b964b07152d234b70');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_m2m_hosts_group`
--

DROP TABLE IF EXISTS `user_m2m_hosts_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_m2m_hosts_group` (
  `user_id` int(11) DEFAULT NULL,
  `hosts_group_id` int(11) DEFAULT NULL,
  KEY `user_id` (`user_id`),
  KEY `hosts_group_id` (`hosts_group_id`),
  CONSTRAINT `user_m2m_hosts_group_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `user_m2m_hosts_group_ibfk_2` FOREIGN KEY (`hosts_group_id`) REFERENCES `hosts_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_m2m_hosts_group`
--

LOCK TABLES `user_m2m_hosts_group` WRITE;
/*!40000 ALTER TABLE `user_m2m_hosts_group` DISABLE KEYS */;
INSERT INTO `user_m2m_hosts_group` VALUES (2,2),(1,1),(9999,1),(9999,2);
/*!40000 ALTER TABLE `user_m2m_hosts_group` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-01-20 13:08:19
