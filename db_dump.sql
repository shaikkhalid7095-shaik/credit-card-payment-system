-- MySQL dump 10.13  Distrib 9.7.1, for Win64 (x86_64)
--
-- Host: localhost    Database: credit_card_payment_db
-- ------------------------------------------------------
-- Server version	9.7.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',3,'add_permission'),(6,'Can change permission',3,'change_permission'),(7,'Can delete permission',3,'delete_permission'),(8,'Can view permission',3,'view_permission'),(9,'Can add group',2,'add_group'),(10,'Can change group',2,'change_group'),(11,'Can delete group',2,'delete_group'),(12,'Can view group',2,'view_group'),(13,'Can add user',4,'add_user'),(14,'Can change user',4,'change_user'),(15,'Can delete user',4,'delete_user'),(16,'Can view user',4,'view_user'),(17,'Can add content type',5,'add_contenttype'),(18,'Can change content type',5,'change_contenttype'),(19,'Can delete content type',5,'delete_contenttype'),(20,'Can view content type',5,'view_contenttype'),(21,'Can add session',6,'add_session'),(22,'Can change session',6,'change_session'),(23,'Can delete session',6,'delete_session'),(24,'Can view session',6,'view_session'),(25,'Can add Blacklisted Token',7,'add_blacklistedtoken'),(26,'Can change Blacklisted Token',7,'change_blacklistedtoken'),(27,'Can delete Blacklisted Token',7,'delete_blacklistedtoken'),(28,'Can view Blacklisted Token',7,'view_blacklistedtoken'),(29,'Can add Outstanding Token',8,'add_outstandingtoken'),(30,'Can change Outstanding Token',8,'change_outstandingtoken'),(31,'Can delete Outstanding Token',8,'delete_outstandingtoken'),(32,'Can view Outstanding Token',8,'view_outstandingtoken'),(33,'Can add card',9,'add_card'),(34,'Can change card',9,'change_card'),(35,'Can delete card',9,'delete_card'),(36,'Can view card',9,'view_card'),(37,'Can add transaction',10,'add_transaction'),(38,'Can change transaction',10,'change_transaction'),(39,'Can delete transaction',10,'delete_transaction'),(40,'Can view transaction',10,'view_transaction');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
INSERT INTO `auth_user` VALUES (1,'pbkdf2_sha256$1500000$5U3RdKMIFLlQxrznwblX7w$nAQAEFhx35ZvPzce+impdhvUJO5QqkJ5VcYI1ecRMYg=','2026-10-11 17:08:44.316670',1,'Khalid','','','khalid@gmail.com',1,1,'2026-10-11 16:21:18.455412'),(2,'pbkdf2_sha256$1500000$PGhxbSu8p6gf1DZMpfocaW$uxLNkhNfP7jQxgxGZXiDZX8C41Snf98GQF0xdvIiEOY=',NULL,0,'checkuser','','','check1@test.com',0,1,'2026-10-11 16:25:19.018705'),(3,'pbkdf2_sha256$1500000$ynSEiwlKBSQkc0fzUuyrh8$4OhCeiwth1HAnkd8/McsoClKEOORMCf0dO95KojTQL4=',NULL,0,'shaikuser','','','shaik@test.com',0,1,'2026-10-11 16:51:27.222037');
/*!40000 ALTER TABLE `auth_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_groups`
--

LOCK TABLES `auth_user_groups` WRITE;
/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_user_permissions`
--

LOCK TABLES `auth_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `auth_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cards_card`
--

DROP TABLE IF EXISTS `cards_card`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cards_card` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `expiry_month` smallint unsigned NOT NULL,
  `expiry_year` smallint unsigned NOT NULL,
  `card_type` varchar(10) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `user_id` int NOT NULL,
  `last_four` varchar(4) NOT NULL,
  `masked_card` varchar(25) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `cards_card_user_id_9c174339_fk_auth_user_id` (`user_id`),
  CONSTRAINT `cards_card_user_id_9c174339_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `cards_card_chk_1` CHECK ((`expiry_month` >= 0)),
  CONSTRAINT `cards_card_chk_2` CHECK ((`expiry_year` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cards_card`
--

LOCK TABLES `cards_card` WRITE;
/*!40000 ALTER TABLE `cards_card` DISABLE KEYS */;
INSERT INTO `cards_card` VALUES (1,12,2030,'CREDIT','2026-10-11 16:56:43.775763','2026-10-11 16:56:43.775781',3,'4242','**** **** **** 4242');
/*!40000 ALTER TABLE `cards_card` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(2,'auth','group'),(3,'auth','permission'),(4,'auth','user'),(9,'cards','card'),(5,'contenttypes','contenttype'),(6,'sessions','session'),(7,'token_blacklist','blacklistedtoken'),(8,'token_blacklist','outstandingtoken'),(10,'transactions','transaction');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2026-10-11 16:20:02.805361'),(2,'auth','0001_initial','2026-10-11 16:20:03.034891'),(3,'admin','0001_initial','2026-10-11 16:20:03.121617'),(4,'admin','0002_logentry_remove_auto_add','2026-10-11 16:20:03.128997'),(5,'admin','0003_logentry_add_action_flag_choices','2026-10-11 16:20:03.136147'),(6,'contenttypes','0002_remove_content_type_name','2026-10-11 16:20:03.196004'),(7,'auth','0002_alter_permission_name_max_length','2026-10-11 16:20:03.229660'),(8,'auth','0003_alter_user_email_max_length','2026-10-11 16:20:03.245448'),(9,'auth','0004_alter_user_username_opts','2026-10-11 16:20:03.252017'),(10,'auth','0005_alter_user_last_login_null','2026-10-11 16:20:03.279820'),(11,'auth','0006_require_contenttypes_0002','2026-10-11 16:20:03.282224'),(12,'auth','0007_alter_validators_add_error_messages','2026-10-11 16:20:03.288592'),(13,'auth','0008_alter_user_username_max_length','2026-10-11 16:20:03.318062'),(14,'auth','0009_alter_user_last_name_max_length','2026-10-11 16:20:03.352399'),(15,'auth','0010_alter_group_name_max_length','2026-10-11 16:20:03.362821'),(16,'auth','0011_update_proxy_permissions','2026-10-11 16:20:03.368399'),(17,'auth','0012_alter_user_first_name_max_length','2026-10-11 16:20:03.395624'),(18,'cards','0001_initial','2026-10-11 16:20:03.436231'),(19,'cards','0002_alter_card_options_remove_card_available_limit_and_more','2026-10-11 16:20:03.714774'),(20,'sessions','0001_initial','2026-10-11 16:20:03.731844'),(21,'token_blacklist','0001_initial','2026-10-11 16:20:03.801586'),(22,'token_blacklist','0002_outstandingtoken_jti_hex','2026-10-11 16:20:03.827392'),(23,'token_blacklist','0003_auto_20171017_2007','2026-10-11 16:20:03.835230'),(24,'token_blacklist','0004_auto_20171017_2013','2026-10-11 16:20:03.871590'),(25,'token_blacklist','0005_remove_outstandingtoken_jti','2026-10-11 16:20:03.895832'),(26,'token_blacklist','0006_auto_20171017_2113','2026-10-11 16:20:03.909940'),(27,'token_blacklist','0007_auto_20171017_2214','2026-10-11 16:20:04.001428'),(28,'token_blacklist','0008_migrate_to_bigautofield','2026-10-11 16:20:04.104841'),(29,'token_blacklist','0010_fix_migrate_to_bigautofield','2026-10-11 16:20:04.112248'),(30,'token_blacklist','0011_linearizes_history','2026-10-11 16:20:04.114045'),(31,'token_blacklist','0012_alter_outstandingtoken_user','2026-10-11 16:20:04.124042'),(32,'token_blacklist','0013_alter_blacklistedtoken_options_and_more','2026-10-11 16:20:04.134578'),(33,'transactions','0001_initial','2026-10-11 16:20:04.201460'),(34,'transactions','0002_alter_transaction_status','2026-10-11 16:20:04.207223'),(35,'transactions','0003_alter_transaction_status','2026-10-11 16:20:04.212266');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('7a9ha80mfnwgcws3dft33fwd3w4tktqx','.eJxVjDkOwjAURO_iGlnYjjdKes5gzfeCA8iR4qRC3J1ESgHlzHszbxawLjWsPc9hTOzCBDv9doT4zG0H6YF2n3ic2jKPxHeFH7Tz25Ty63q4fwcVvW5rN1Ax3ouorLOwQpKVGgJxKMqpLWsUwChvtLLSyEiKzskT-SwzUNjnC8j0N9A:1xFx2S:mkh6q_0tAITsdahcK7yqwWatsauth1EIP3qr3bjhLBA','2026-10-25 17:08:44.334656');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `transaction_id` varchar(50) NOT NULL,
  `user_id` int NOT NULL,
  `card_id` int NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `currency` varchar(3) NOT NULL,
  `payment_method` varchar(20) NOT NULL,
  `status` varchar(20) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `failure_reason` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `completed_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ix_payments_transaction_id` (`transaction_id`),
  KEY `ix_payments_user_id` (`user_id`),
  KEY `ix_payments_id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
INSERT INTO `payments` VALUES (1,'TXN-0651B2474121',3,2,500.00,'INR','CARD','SUCCESS','Test payment',NULL,'2026-10-11 16:58:45','2026-10-11 16:58:45','2026-10-11 16:58:45'),(2,'TXN-9BA0F06BB5D6',3,2,60000.00,'INR','CARD','FAILED','more than limit','Amount exceeds card limit','2026-10-11 16:59:44','2026-10-11 16:59:44',NULL);
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `token_blacklist_blacklistedtoken`
--

DROP TABLE IF EXISTS `token_blacklist_blacklistedtoken`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `token_blacklist_blacklistedtoken` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `blacklisted_at` datetime(6) NOT NULL,
  `token_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token_id` (`token_id`),
  CONSTRAINT `token_blacklist_blacklistedtoken_token_id_3cc7fe56_fk` FOREIGN KEY (`token_id`) REFERENCES `token_blacklist_outstandingtoken` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `token_blacklist_blacklistedtoken`
--

LOCK TABLES `token_blacklist_blacklistedtoken` WRITE;
/*!40000 ALTER TABLE `token_blacklist_blacklistedtoken` DISABLE KEYS */;
INSERT INTO `token_blacklist_blacklistedtoken` VALUES (1,'2026-10-11 17:16:14.367416',4);
/*!40000 ALTER TABLE `token_blacklist_blacklistedtoken` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `token_blacklist_outstandingtoken`
--

DROP TABLE IF EXISTS `token_blacklist_outstandingtoken`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `token_blacklist_outstandingtoken` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `token` longtext NOT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `expires_at` datetime(6) NOT NULL,
  `user_id` int DEFAULT NULL,
  `jti` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token_blacklist_outstandingtoken_jti_hex_d9bdf6f7_uniq` (`jti`),
  KEY `token_blacklist_outs_user_id_83bc629a_fk_auth_user` (`user_id`),
  CONSTRAINT `token_blacklist_outs_user_id_83bc629a_fk_auth_user` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `token_blacklist_outstandingtoken`
--

LOCK TABLES `token_blacklist_outstandingtoken` WRITE;
/*!40000 ALTER TABLE `token_blacklist_outstandingtoken` DISABLE KEYS */;
INSERT INTO `token_blacklist_outstandingtoken` VALUES (1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc5MTgyMjUwMSwiaWF0IjoxNzkxNzM2MTAxLCJqdGkiOiIyZTZiOGIxMWE1YzA0NjY5YTE4YWVhNzhkYTE4MjFlZCIsInVzZXJfaWQiOiIyIn0.zhv3atBZRNX2-dOYlTgssG_wi3c5q5hpbN8RVY7NTJc','2026-10-11 16:28:21.255050','2026-10-12 16:28:21.000000',2,'2e6b8b11a5c04669a18aea78da1821ed'),(2,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc5MTgyMjUyMiwiaWF0IjoxNzkxNzM2MTIyLCJqdGkiOiI1M2Y0OGU3YjNmYzc0ZGZjOGEwZWQ1MjZkZTRkNGJmNyIsInVzZXJfaWQiOiIyIn0._lBSAuagps-H05k8krN-teauD0907JtrZGJ8TQuAeNQ','2026-10-11 16:28:42.313138','2026-10-12 16:28:42.000000',2,'53f48e7b3fc74dfc8a0ed526de4d4bf7'),(3,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc5MTgyMjU2OSwiaWF0IjoxNzkxNzM2MTY5LCJqdGkiOiI5YTQ3MWQ0YTEwYzE0NGYzYmUxZGZjNzYwMzg3MzY5MyIsInVzZXJfaWQiOiIyIn0.VxTbjjUh7NfF-bvaPWHVmyRWSYehPVuDsO54zcdHTOU','2026-10-11 16:29:29.430739','2026-10-12 16:29:29.000000',2,'9a471d4a10c144f3be1dfc7603873693'),(4,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc5MTgyMzk1MiwiaWF0IjoxNzkxNzM3NTUyLCJqdGkiOiI5OGRkMmJiN2MwODI0OGM2YTcyODVmNzkzOWFlMWY3YyIsInVzZXJfaWQiOiIzIn0.I-XmY3fCBawc0HqjwVbVsCDLWQgqWk9eyF2aA9TlQRI','2026-10-11 16:52:32.621783','2026-10-12 16:52:32.000000',3,'98dd2bb7c08248c6a7285f7939ae1f7c');
/*!40000 ALTER TABLE `token_blacklist_outstandingtoken` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transactions_transaction`
--

DROP TABLE IF EXISTS `transactions_transaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transactions_transaction` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `transaction_id` varchar(50) NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `currency` varchar(3) NOT NULL,
  `payment_method` varchar(20) NOT NULL,
  `status` varchar(10) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `failure_reason` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `completed_at` datetime(6) DEFAULT NULL,
  `card_id` bigint DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `transaction_id` (`transaction_id`),
  KEY `transactions_transaction_card_id_b6891695_fk_cards_card_id` (`card_id`),
  KEY `transactions_transaction_user_id_b9ecc248_fk_auth_user_id` (`user_id`),
  CONSTRAINT `transactions_transaction_card_id_b6891695_fk_cards_card_id` FOREIGN KEY (`card_id`) REFERENCES `cards_card` (`id`),
  CONSTRAINT `transactions_transaction_user_id_b9ecc248_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transactions_transaction`
--

LOCK TABLES `transactions_transaction` WRITE;
/*!40000 ALTER TABLE `transactions_transaction` DISABLE KEYS */;
INSERT INTO `transactions_transaction` VALUES (1,'TXN42706C211542',500.00,'INR','CARD','SUCCESS','Test payment',NULL,'2026-10-11 16:58:45.138092','2026-10-11 16:58:45.274188','2026-10-11 16:58:45.274044',NULL,3),(2,'TXNB09B9D63DE93',60000.00,'INR','CARD','FAILED','more than limit','Amount exceeds card limit','2026-10-11 16:59:43.543832','2026-10-11 16:59:43.628231',NULL,NULL,3);
/*!40000 ALTER TABLE `transactions_transaction` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-11 22:50:16
