-- phpMyAdmin SQL Dump
-- version 4.0.4
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jan 22, 2014 at 06:31 PM
-- Server version: 5.6.12-log
-- PHP Version: 5.4.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `toolsvoa_t2`
--
CREATE DATABASE IF NOT EXISTS `toolsvoa_t2` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `toolsvoa_t2`;

-- --------------------------------------------------------

--
-- Table structure for table `insights_beats`
--

CREATE TABLE IF NOT EXISTS `insights_beats` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  `is_deleted` enum('Yes','No') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'No',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=13 ;

-- --------------------------------------------------------

--
-- Table structure for table `insights_divisions`
--

CREATE TABLE IF NOT EXISTS `insights_divisions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  `is_deleted` enum('Yes','No') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'No',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=9 ;

-- --------------------------------------------------------

--
-- Table structure for table `insights_editors`
--

CREATE TABLE IF NOT EXISTS `insights_editors` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  `division_id` int(10) unsigned NOT NULL,
  `service_id` int(10) unsigned NOT NULL,
  `is_deleted` enum('Yes','No') COLLATE utf8_unicode_ci DEFAULT 'No',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=29 ;

-- --------------------------------------------------------

--
-- Table structure for table `insights_entries`
--

CREATE TABLE IF NOT EXISTS `insights_entries` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `slug` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  `deadline` datetime NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `description` text COLLATE utf8_unicode_ci NOT NULL,
  `is_deleted` enum('Yes','No') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'No',
  `is_starred` enum('Yes','No') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'No',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=273 ;

-- --------------------------------------------------------

--
-- Table structure for table `insights_map`
--

CREATE TABLE IF NOT EXISTS `insights_map` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` enum('reporters','editors','divisions','services','beats','mediums','regions') COLLATE utf8_unicode_ci NOT NULL,
  `entry_id` int(10) unsigned NOT NULL,
  `other_id` int(10) unsigned NOT NULL,
  `is_deleted` enum('Yes','No') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'No',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=1268 ;

-- --------------------------------------------------------

--
-- Table structure for table `insights_mediums`
--

CREATE TABLE IF NOT EXISTS `insights_mediums` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  `is_deleted` enum('Yes','No') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'No',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=4 ;

-- --------------------------------------------------------

--
-- Table structure for table `insights_regions`
--

CREATE TABLE IF NOT EXISTS `insights_regions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  `is_deleted` enum('Yes','No') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'No',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=8 ;

-- --------------------------------------------------------

--
-- Table structure for table `insights_reporters`
--

CREATE TABLE IF NOT EXISTS `insights_reporters` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  `division_id` int(10) unsigned NOT NULL,
  `service_id` int(10) unsigned NOT NULL,
  `is_deleted` enum('Yes','No') COLLATE utf8_unicode_ci DEFAULT 'No',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=58 ;

-- --------------------------------------------------------

--
-- Table structure for table `insights_services`
--

CREATE TABLE IF NOT EXISTS `insights_services` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `division_id` int(10) unsigned NOT NULL,
  `name` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  `is_deleted` enum('Yes','No') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'No',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=65 ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
