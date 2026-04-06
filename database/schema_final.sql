-- MySQL dump 10.13  Distrib 8.0.44, for macos15 (arm64)
--
-- Host: 127.0.0.1    Database: health_insurance
-- ------------------------------------------------------
-- Server version	8.0.45

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
-- Table structure for table `CLAIMS`
--

DROP TABLE IF EXISTS `CLAIMS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CLAIMS` (
  `claim_id` bigint unsigned NOT NULL,
  `member_id` bigint unsigned NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `date` date NOT NULL,
  `insurance_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`claim_id`),
  KEY `ix_claims_member_date` (`member_id`,`date`),
  KEY `ix_claims_insurance_date` (`insurance_id`,`date`),
  CONSTRAINT `fk_claims_insurance` FOREIGN KEY (`insurance_id`) REFERENCES `INSURANCE` (`insurance_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_claims_member` FOREIGN KEY (`member_id`) REFERENCES `MEMBERS` (`member_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `CONDITION`
--

DROP TABLE IF EXISTS `CONDITION`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CONDITION` (
  `Condition_ID` bigint unsigned NOT NULL,
  `Condition_name` varchar(255) NOT NULL,
  PRIMARY KEY (`Condition_ID`),
  UNIQUE KEY `ux_condition_name` (`Condition_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ENROLLMENT`
--

DROP TABLE IF EXISTS `ENROLLMENT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ENROLLMENT` (
  `Enrollment_ID` bigint unsigned NOT NULL,
  `Coverage_tier` varchar(50) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `state` char(2) NOT NULL,
  `plan_id` bigint unsigned NOT NULL,
  `premium` decimal(12,2) NOT NULL,
  PRIMARY KEY (`Enrollment_ID`),
  KEY `ix_enrollment_plan_id` (`plan_id`),
  KEY `ix_enrollment_state` (`state`),
  CONSTRAINT `fk_enrollment_plan` FOREIGN KEY (`plan_id`) REFERENCES `PLAN` (`plan_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `FACILITY`
--

DROP TABLE IF EXISTS `FACILITY`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `FACILITY` (
  `Facility_ID` bigint unsigned NOT NULL,
  `NPI` char(10) DEFAULT NULL,
  `Name` varchar(255) NOT NULL,
  `State` char(2) NOT NULL,
  `Contact_info` json DEFAULT NULL,
  PRIMARY KEY (`Facility_ID`),
  KEY `ix_facility_state` (`State`),
  KEY `ix_facility_npi` (`NPI`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `INSURANCE`
--

DROP TABLE IF EXISTS `INSURANCE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `INSURANCE` (
  `insurance_id` bigint unsigned NOT NULL,
  `insurance_name` varchar(255) NOT NULL,
  `contact_info` json DEFAULT NULL,
  PRIMARY KEY (`insurance_id`),
  UNIQUE KEY `ux_insurance_name` (`insurance_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `MEMBER_CONDITION`
--

DROP TABLE IF EXISTS `MEMBER_CONDITION`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MEMBER_CONDITION` (
  `Member_ID` bigint unsigned NOT NULL,
  `Condition_ID` bigint unsigned NOT NULL,
  `Diagnostic_date` date NOT NULL,
  PRIMARY KEY (`Member_ID`,`Condition_ID`,`Diagnostic_date`),
  KEY `ix_member_condition_condition` (`Condition_ID`),
  KEY `ix_member_condition_diagnostic_date` (`Diagnostic_date`),
  CONSTRAINT `fk_member_condition_condition` FOREIGN KEY (`Condition_ID`) REFERENCES `CONDITION` (`Condition_ID`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_member_condition_member` FOREIGN KEY (`Member_ID`) REFERENCES `MEMBERS` (`member_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `MEMBERS`
--

DROP TABLE IF EXISTS `MEMBERS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MEMBERS` (
  `member_id` bigint unsigned NOT NULL,
  `DOB` date NOT NULL,
  `Sex` enum('F','M','O') NOT NULL,
  `Primary_Care_Facility_ID` bigint unsigned DEFAULT NULL,
  `State` char(2) NOT NULL,
  `Weight` decimal(6,2) DEFAULT NULL,
  `Height` decimal(5,2) DEFAULT NULL,
  `heart_rate` smallint unsigned DEFAULT NULL,
  `blood_pressure` varchar(15) DEFAULT NULL,
  `blood_oxygen` tinyint unsigned DEFAULT NULL,
  `smoker` tinyint(1) DEFAULT NULL,
  `drinker` tinyint(1) DEFAULT NULL,
  `housing_insecurity` tinyint(1) DEFAULT NULL,
  `employment_status` tinyint(1) DEFAULT NULL,
  `hours_sleep_per_day` decimal(4,1) DEFAULT NULL,
  `minutes_exercise_per_week` smallint unsigned DEFAULT NULL,
  `Insurance_ID` bigint unsigned DEFAULT NULL,
  `Enrollment_ID` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`member_id`),
  KEY `ix_members_state` (`State`),
  KEY `ix_members_facility` (`Primary_Care_Facility_ID`),
  KEY `ix_members_insurance` (`Insurance_ID`),
  KEY `ix_members_enrollment` (`Enrollment_ID`),
  CONSTRAINT `fk_members_enrollment` FOREIGN KEY (`Enrollment_ID`) REFERENCES `ENROLLMENT` (`Enrollment_ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_members_facility` FOREIGN KEY (`Primary_Care_Facility_ID`) REFERENCES `FACILITY` (`Facility_ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_members_insurance` FOREIGN KEY (`Insurance_ID`) REFERENCES `INSURANCE` (`insurance_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `PLAN`
--

DROP TABLE IF EXISTS `PLAN`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PLAN` (
  `plan_id` bigint unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `insurance_id` bigint unsigned NOT NULL,
  `base_rate` decimal(12,2) NOT NULL,
  `deductable` decimal(12,2) NOT NULL,
  PRIMARY KEY (`plan_id`),
  UNIQUE KEY `ux_plan_insurance_name` (`insurance_id`,`name`),
  KEY `ix_plan_insurance_id` (`insurance_id`),
  CONSTRAINT `fk_plan_insurance` FOREIGN KEY (`insurance_id`) REFERENCES `INSURANCE` (`insurance_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-06 15:12:46
