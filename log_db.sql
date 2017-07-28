/*
Navicat MySQL Data Transfer

Source Server         : 192.168.199.233
Source Server Version : 50630
Source Host           : 192.168.199.233:3306
Source Database       : log_db

Target Server Type    : MYSQL
Target Server Version : 50630
File Encoding         : 65001

Date: 2016-06-07 13:19:07
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `login_info0`
-- ----------------------------
DROP TABLE IF EXISTS `login_info0`;
CREATE TABLE `login_info0` (
  `login_info_id` int(20) NOT NULL AUTO_INCREMENT,
  `uid` varchar(50) CHARACTER SET utf8 NOT NULL,
  `ip` varchar(20) CHARACTER SET utf8 NOT NULL,
  `type` int(3) DEFAULT NULL COMMENT '0:ä¸‹çº¿\r\n1:ä¸Šçº¿ \r\n',
  `cause` int(3) DEFAULT NULL COMMENT '1:conn_closed\r\n2:timeout\r\n3:duplicate_id\r\n4:keepalive_timeout\r\n5:normal\r\n6:im error',
  `date_time` datetime NOT NULL,
  `remark` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`login_info_id`),
  KEY `uid` (`uid`),
  KEY `cause` (`cause`),
  KEY `type` (`type`),
  KEY `date_time` (`date_time`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 DELAY_KEY_WRITE=1;

-- ----------------------------
-- Records of login_info0
-- ----------------------------

-- ----------------------------
-- Table structure for `login_info1`
-- ----------------------------
DROP TABLE IF EXISTS `login_info1`;
CREATE TABLE `login_info1` (
  `login_info_id` int(20) NOT NULL AUTO_INCREMENT,
  `uid` varchar(50) CHARACTER SET utf8 NOT NULL,
  `ip` varchar(20) CHARACTER SET utf8 NOT NULL,
  `type` int(3) DEFAULT NULL COMMENT '0:ä¸‹çº¿\r\n1:ä¸Šçº¿ \r\n',
  `cause` int(3) DEFAULT NULL COMMENT '1:conn_closed\r\n2:timeout\r\n3:duplicate_id\r\n4:keepalive_timeout\r\n5:normal\r\n6:im error',
  `date_time` datetime NOT NULL,
  `remark` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`login_info_id`),
  KEY `uid` (`uid`),
  KEY `cause` (`cause`),
  KEY `type` (`type`),
  KEY `date_time` (`date_time`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 DELAY_KEY_WRITE=1;

-- ----------------------------
-- Records of login_info1
-- ----------------------------

-- ----------------------------
-- Table structure for `login_info2`
-- ----------------------------
DROP TABLE IF EXISTS `login_info2`;
CREATE TABLE `login_info2` (
  `login_info_id` int(20) NOT NULL AUTO_INCREMENT,
  `uid` varchar(50) CHARACTER SET utf8 NOT NULL,
  `ip` varchar(20) CHARACTER SET utf8 NOT NULL,
  `type` int(3) DEFAULT NULL COMMENT '0:ä¸‹çº¿\r\n1:ä¸Šçº¿ \r\n',
  `cause` int(3) DEFAULT NULL COMMENT '1:conn_closed\r\n2:timeout\r\n3:duplicate_id\r\n4:keepalive_timeout\r\n5:normal\r\n6:im error',
  `date_time` datetime NOT NULL,
  `remark` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`login_info_id`),
  KEY `uid` (`uid`),
  KEY `cause` (`cause`),
  KEY `type` (`type`),
  KEY `date_time` (`date_time`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 DELAY_KEY_WRITE=1;

-- ----------------------------
-- Records of login_info2
-- ----------------------------

-- ----------------------------
-- Table structure for `login_info3`
-- ----------------------------
DROP TABLE IF EXISTS `login_info3`;
CREATE TABLE `login_info3` (
  `login_info_id` int(20) NOT NULL AUTO_INCREMENT,
  `uid` varchar(50) CHARACTER SET utf8 NOT NULL,
  `ip` varchar(20) CHARACTER SET utf8 NOT NULL,
  `type` int(3) DEFAULT NULL COMMENT '0:ä¸‹çº¿\r\n1:ä¸Šçº¿ \r\n',
  `cause` int(3) DEFAULT NULL COMMENT '1:conn_closed\r\n2:timeout\r\n3:duplicate_id\r\n4:keepalive_timeout\r\n5:normal\r\n6:im error',
  `date_time` datetime NOT NULL,
  `remark` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`login_info_id`),
  KEY `uid` (`uid`),
  KEY `cause` (`cause`),
  KEY `type` (`type`),
  KEY `date_time` (`date_time`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 DELAY_KEY_WRITE=1;

-- ----------------------------
-- Records of login_info3
-- ----------------------------

-- ----------------------------
-- Table structure for `login_info4`
-- ----------------------------
DROP TABLE IF EXISTS `login_info4`;
CREATE TABLE `login_info4` (
  `login_info_id` int(20) NOT NULL AUTO_INCREMENT,
  `uid` varchar(50) CHARACTER SET utf8 NOT NULL,
  `ip` varchar(20) CHARACTER SET utf8 NOT NULL,
  `type` int(3) DEFAULT NULL COMMENT '0:ä¸‹çº¿\r\n1:ä¸Šçº¿ \r\n',
  `cause` int(3) DEFAULT NULL COMMENT '1:conn_closed\r\n2:timeout\r\n3:duplicate_id\r\n4:keepalive_timeout\r\n5:normal\r\n6:im error',
  `date_time` datetime NOT NULL,
  `remark` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`login_info_id`),
  KEY `uid` (`uid`),
  KEY `cause` (`cause`),
  KEY `type` (`type`),
  KEY `date_time` (`date_time`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 DELAY_KEY_WRITE=1;

-- ----------------------------
-- Records of login_info4
-- ----------------------------

-- ----------------------------
-- Table structure for `login_info5`
-- ----------------------------
DROP TABLE IF EXISTS `login_info5`;
CREATE TABLE `login_info5` (
  `login_info_id` int(20) NOT NULL AUTO_INCREMENT,
  `uid` varchar(50) CHARACTER SET utf8 NOT NULL,
  `ip` varchar(20) CHARACTER SET utf8 NOT NULL,
  `type` int(3) DEFAULT NULL COMMENT '0:ä¸‹çº¿\r\n1:ä¸Šçº¿ \r\n',
  `cause` int(3) DEFAULT NULL COMMENT '1:conn_closed\r\n2:timeout\r\n3:duplicate_id\r\n4:keepalive_timeout\r\n5:normal\r\n6:im error',
  `date_time` datetime NOT NULL,
  `remark` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`login_info_id`),
  KEY `uid` (`uid`),
  KEY `cause` (`cause`),
  KEY `type` (`type`),
  KEY `date_time` (`date_time`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 DELAY_KEY_WRITE=1;

-- ----------------------------
-- Records of login_info5
-- ----------------------------

-- ----------------------------
-- Table structure for `login_info6`
-- ----------------------------
DROP TABLE IF EXISTS `login_info6`;
CREATE TABLE `login_info6` (
  `login_info_id` int(20) NOT NULL AUTO_INCREMENT,
  `uid` varchar(50) CHARACTER SET utf8 NOT NULL,
  `ip` varchar(20) CHARACTER SET utf8 NOT NULL,
  `type` int(3) DEFAULT NULL COMMENT '0:ä¸‹çº¿\r\n1:ä¸Šçº¿ \r\n',
  `cause` int(3) DEFAULT NULL COMMENT '1:conn_closed\r\n2:timeout\r\n3:duplicate_id\r\n4:keepalive_timeout\r\n5:normal\r\n6:im error',
  `date_time` datetime NOT NULL,
  `remark` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`login_info_id`),
  KEY `uid` (`uid`),
  KEY `cause` (`cause`),
  KEY `type` (`type`),
  KEY `date_time` (`date_time`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 DELAY_KEY_WRITE=1;

-- ----------------------------
-- Records of login_info6
-- ----------------------------

-- ----------------------------
-- Table structure for `login_info7`
-- ----------------------------
DROP TABLE IF EXISTS `login_info7`;
CREATE TABLE `login_info7` (
  `login_info_id` int(20) NOT NULL AUTO_INCREMENT,
  `uid` varchar(50) CHARACTER SET utf8 NOT NULL,
  `ip` varchar(20) CHARACTER SET utf8 NOT NULL,
  `type` int(3) DEFAULT NULL COMMENT '0:ä¸‹çº¿\r\n1:ä¸Šçº¿ \r\n',
  `cause` int(3) DEFAULT NULL COMMENT '1:conn_closed\r\n2:timeout\r\n3:duplicate_id\r\n4:keepalive_timeout\r\n5:normal\r\n6:im error',
  `date_time` datetime NOT NULL,
  `remark` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`login_info_id`),
  KEY `uid` (`uid`),
  KEY `cause` (`cause`),
  KEY `type` (`type`),
  KEY `date_time` (`date_time`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 DELAY_KEY_WRITE=1;

-- ----------------------------
-- Records of login_info7
-- ----------------------------

-- ----------------------------
-- Table structure for `login_info8`
-- ----------------------------
DROP TABLE IF EXISTS `login_info8`;
CREATE TABLE `login_info8` (
  `login_info_id` int(20) NOT NULL AUTO_INCREMENT,
  `uid` varchar(50) CHARACTER SET utf8 NOT NULL,
  `ip` varchar(20) CHARACTER SET utf8 NOT NULL,
  `type` int(3) DEFAULT NULL COMMENT '0:ä¸‹çº¿\r\n1:ä¸Šçº¿ \r\n',
  `cause` int(3) DEFAULT NULL COMMENT '1:conn_closed\r\n2:timeout\r\n3:duplicate_id\r\n4:keepalive_timeout\r\n5:normal\r\n6:im error',
  `date_time` datetime NOT NULL,
  `remark` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`login_info_id`),
  KEY `uid` (`uid`),
  KEY `cause` (`cause`),
  KEY `type` (`type`),
  KEY `date_time` (`date_time`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 DELAY_KEY_WRITE=1;

-- ----------------------------
-- Records of login_info8
-- ----------------------------

-- ----------------------------
-- Table structure for `login_info9`
-- ----------------------------
DROP TABLE IF EXISTS `login_info9`;
CREATE TABLE `login_info9` (
  `login_info_id` int(20) NOT NULL AUTO_INCREMENT,
  `uid` varchar(50) CHARACTER SET utf8 NOT NULL,
  `ip` varchar(20) CHARACTER SET utf8 NOT NULL,
  `type` int(3) DEFAULT NULL COMMENT '0:ä¸‹çº¿\r\n1:ä¸Šçº¿ \r\n',
  `cause` int(3) DEFAULT NULL COMMENT '1:conn_closed\r\n2:timeout\r\n3:duplicate_id\r\n4:keepalive_timeout\r\n5:normal\r\n6:im error',
  `date_time` datetime NOT NULL,
  `remark` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`login_info_id`),
  KEY `uid` (`uid`),
  KEY `cause` (`cause`),
  KEY `type` (`type`),
  KEY `date_time` (`date_time`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 DELAY_KEY_WRITE=1;

-- ----------------------------
-- Records of login_info9
-- ----------------------------

-- ----------------------------
-- Table structure for `msg_info0`
-- ----------------------------
DROP TABLE IF EXISTS `msg_info0`;
CREATE TABLE `msg_info0` (
  `msg_info_id` int(20) NOT NULL AUTO_INCREMENT,
  `from_uid` varchar(50) CHARACTER SET utf8 NOT NULL,
  `to_uid` varchar(50) CHARACTER SET utf8 NOT NULL,
  `content` blob DEFAULT NULL,
  `type` int(1) NOT NULL COMMENT '1:chat\r\n2:sfile\r\n3:svideo\r\n4:chat_ex\r\n5:publish\r\n6:å…¶ä»–',
  `date_time` datetime NOT NULL,
  `remark` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`msg_info_id`),
  KEY `from` (`from_uid`),
  KEY `to` (`to_uid`),
  KEY `type` (`type`),
  KEY `date_time` (`date_time`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 DELAY_KEY_WRITE=1;

-- ----------------------------
-- Records of msg_info0
-- ----------------------------

-- ----------------------------
-- Table structure for `msg_info1`
-- ----------------------------
DROP TABLE IF EXISTS `msg_info1`;
CREATE TABLE `msg_info1` (
  `msg_info_id` int(20) NOT NULL AUTO_INCREMENT,
  `from_uid` varchar(50) CHARACTER SET utf8 NOT NULL,
  `to_uid` varchar(50) CHARACTER SET utf8 NOT NULL,
  `content` blob DEFAULT NULL,
  `type` int(1) NOT NULL COMMENT '1:chat\r\n2:sfile\r\n3:svideo\r\n4:chat_ex\r\n5:publish\r\n6:å…¶ä»–',
  `date_time` datetime NOT NULL,
  `remark` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`msg_info_id`),
  KEY `from` (`from_uid`),
  KEY `to` (`to_uid`),
  KEY `type` (`type`),
  KEY `date_time` (`date_time`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 DELAY_KEY_WRITE=1;

-- ----------------------------
-- Records of msg_info1
-- ----------------------------

-- ----------------------------
-- Table structure for `msg_info2`
-- ----------------------------
DROP TABLE IF EXISTS `msg_info2`;
CREATE TABLE `msg_info2` (
  `msg_info_id` int(20) NOT NULL AUTO_INCREMENT,
  `from_uid` varchar(50) CHARACTER SET utf8 NOT NULL,
  `to_uid` varchar(50) CHARACTER SET utf8 NOT NULL,
  `content` blob DEFAULT NULL,
  `type` int(1) NOT NULL COMMENT '1:chat\r\n2:sfile\r\n3:svideo\r\n4:chat_ex\r\n5:publish\r\n6:å…¶ä»–',
  `date_time` datetime NOT NULL,
  `remark` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`msg_info_id`),
  KEY `from` (`from_uid`),
  KEY `to` (`to_uid`),
  KEY `type` (`type`),
  KEY `date_time` (`date_time`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 DELAY_KEY_WRITE=1;

-- ----------------------------
-- Records of msg_info2
-- ----------------------------

-- ----------------------------
-- Table structure for `msg_info3`
-- ----------------------------
DROP TABLE IF EXISTS `msg_info3`;
CREATE TABLE `msg_info3` (
  `msg_info_id` int(20) NOT NULL AUTO_INCREMENT,
  `from_uid` varchar(50) CHARACTER SET utf8 NOT NULL,
  `to_uid` varchar(50) CHARACTER SET utf8 NOT NULL,
  `content` blob DEFAULT NULL,
  `type` int(1) NOT NULL COMMENT '1:chat\r\n2:sfile\r\n3:svideo\r\n4:chat_ex\r\n5:publish\r\n6:å…¶ä»–',
  `date_time` datetime NOT NULL,
  `remark` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`msg_info_id`),
  KEY `from` (`from_uid`),
  KEY `to` (`to_uid`),
  KEY `type` (`type`),
  KEY `date_time` (`date_time`)
)ENGINE=MyISAM DEFAULT CHARSET=latin1 DELAY_KEY_WRITE=1;

-- ------------------- ---------
-- Records of msg_info3
-- ----------------------------

-- ----------------------------
-- Table structure for `msg_info4`
-- ----------------------------
DROP TABLE IF EXISTS `msg_info4`;
CREATE TABLE `msg_info4` (
  `msg_info_id` int(20) NOT NULL AUTO_INCREMENT,
  `from_uid` varchar(50) CHARACTER SET utf8 NOT NULL,
  `to_uid` varchar(50) CHARACTER SET utf8 NOT NULL,
  `content` blob DEFAULT NULL,
  `type` int(1) NOT NULL COMMENT '1:chat\r\n2:sfile\r\n3:svideo\r\n4:chat_ex\r\n5:publish\r\n6:å…¶ä»–',
  `date_time` datetime NOT NULL,
  `remark` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`msg_info_id`),
  KEY `from` (`from_uid`),
  KEY `to` (`to_uid`),
  KEY `type` (`type`),
  KEY `date_time` (`date_time`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 DELAY_KEY_WRITE=1;

-- ----------------------------
-- Records of msg_info4
-- ----------------------------

-- ----------------------------
-- Table structure for `msg_info5`
-- ----------------------------
DROP TABLE IF EXISTS `msg_info5`;
CREATE TABLE `msg_info5` (
  `msg_info_id` int(20) NOT NULL AUTO_INCREMENT,
  `from_uid` varchar(50) CHARACTER SET utf8 NOT NULL,
  `to_uid` varchar(50) CHARACTER SET utf8 NOT NULL,
  `content` blob DEFAULT NULL,
  `type` int(1) NOT NULL COMMENT '1:chat\r\n2:sfile\r\n3:svideo\r\n4:chat_ex\r\n5:publish\r\n6:å…¶ä»–',
  `date_time` datetime NOT NULL,
  `remark` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`msg_info_id`),
  KEY `from` (`from_uid`),
  KEY `to` (`to_uid`),
  KEY `type` (`type`),
  KEY `date_time` (`date_time`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 DELAY_KEY_WRITE=1;

-- ----------------------------
-- Records of msg_info5
-- ----------------------------

-- ----------------------------
-- Table structure for `msg_info6`
-- ----------------------------
DROP TABLE IF EXISTS `msg_info6`;
CREATE TABLE `msg_info6` (
  `msg_info_id` int(20) NOT NULL AUTO_INCREMENT,
  `from_uid` varchar(50) CHARACTER SET utf8 NOT NULL,
  `to_uid` varchar(50) CHARACTER SET utf8 NOT NULL,
  `content` blob DEFAULT NULL,
  `type` int(1) NOT NULL COMMENT '1:chat\r\n2:sfile\r\n3:svideo\r\n4:chat_ex\r\n5:publish\r\n6:å…¶ä»–',
  `date_time` datetime NOT NULL,
  `remark` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`msg_info_id`),
  KEY `from` (`from_uid`),
  KEY `to` (`to_uid`),
  KEY `type` (`type`),
  KEY `date_time` (`date_time`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 DELAY_KEY_WRITE=1;

-- ----------------------------
-- Records of msg_info6
-- ----------------------------

-- ----------------------------
-- Table structure for `msg_info7`
-- ----------------------------
DROP TABLE IF EXISTS `msg_info7`;
CREATE TABLE `msg_info7` (
  `msg_info_id` int(20) NOT NULL AUTO_INCREMENT,
  `from_uid` varchar(50) CHARACTER SET utf8 NOT NULL,
  `to_uid` varchar(50) CHARACTER SET utf8 NOT NULL,
  `content` blob DEFAULT NULL,
  `type` int(1) NOT NULL COMMENT '1:chat\r\n2:sfile\r\n3:svideo\r\n4:chat_ex\r\n5:publish\r\n6:å…¶ä»–',
  `date_time` datetime NOT NULL,
  `remark` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`msg_info_id`),
  KEY `from` (`from_uid`),
  KEY `to` (`to_uid`),
  KEY `type` (`type`),
  KEY `date_time` (`date_time`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 DELAY_KEY_WRITE=1;

-- ----------------------------
-- Records of msg_info7
-- ----------------------------

-- ----------------------------
-- Table structure for `msg_info8`
-- ----------------------------
DROP TABLE IF EXISTS `msg_info8`;
CREATE TABLE `msg_info8` (
  `msg_info_id` int(20) NOT NULL AUTO_INCREMENT,
  `from_uid` varchar(50) CHARACTER SET utf8 NOT NULL,
  `to_uid` varchar(50) CHARACTER SET utf8 NOT NULL,
  `content` blob DEFAULT NULL,
  `type` int(1) NOT NULL COMMENT '1:chat\r\n2:sfile\r\n3:svideo\r\n4:chat_ex\r\n5:publish\r\n6:å…¶ä»–',
  `date_time` datetime NOT NULL,
  `remark` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`msg_info_id`),
  KEY `from` (`from_uid`),
  KEY `to` (`to_uid`),
  KEY `type` (`type`),
  KEY `date_time` (`date_time`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 DELAY_KEY_WRITE=1;

-- ----------------------------
-- Records of msg_info8
-- ----------------------------

-- ----------------------------
-- Table structure for `msg_info9`
-- ----------------------------
DROP TABLE IF EXISTS `msg_info9`;
CREATE TABLE `msg_info9` (
  `msg_info_id` int(20) NOT NULL AUTO_INCREMENT,
  `from_uid` varchar(50) CHARACTER SET utf8 NOT NULL,
  `to_uid` varchar(50) CHARACTER SET utf8 NOT NULL,
  `content` blob DEFAULT NULL,
  `type` int(1) NOT NULL COMMENT '1:chat\r\n2:sfile\r\n3:svideo\r\n4:chat_ex\r\n5:publish\r\n6:å…¶ä»–',
  `date_time` datetime NOT NULL,
  `remark` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`msg_info_id`),
  KEY `from` (`from_uid`),
  KEY `to` (`to_uid`),
  KEY `type` (`type`),
  KEY `date_time` (`date_time`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 DELAY_KEY_WRITE=1;

-- ----------------------------
-- Records of msg_info9
-- ----------------------------


-- ----------------------------
-- produrce login
-- ----------------------------

SET GLOBAL event_scheduler = 1; 

DELIMITER //
DROP PROCEDURE IF EXISTS clear_data;
create procedure clear_data(In table_name char(20),In max_size int, In each_delete_size int)
begin 
	
	set @sql_size = concat("select count(*) into @num from ", table_name);
	PREPARE sql_size FROM @sql_size;
	EXECUTE sql_size;

	set @diff_num = @num - max_size;
	IF @diff_num >= each_delete_size THEN
		set @delete_num = each_delete_size;
	ELSEIF @diff_num > 0 THEN
		set @delete_num = @diff_num;
	ELSE
		set @delete_num = 0;
	END IF;

	IF @delete_num != 0 THEN
		set @delete_sql = concat("delete from ", table_name, " order by msg_info_id limit ", @delete_num);
		PREPARE delete_sql FROM @delete_sql;
		EXECUTE delete_sql;
	end IF;

	select @delete_num;
end;

DROP EVENT IF EXISTS `data_clean`;
CREATE EVENT IF NOT EXISTS `data_clean`
ON SCHEDULE
EVERY 1 SECOND
STARTS TIMESTAMP(CURRENT_DATE,'0:00:00')
ENDS TIMESTAMP(current_Date, '3:00:00')
ON COMPLETION PRESERVE ENABLE
DO
    BEGIN
				call clear_data("msg_info0", 1000000, 400);
				call clear_data("msg_info1", 1000000, 400);
				call clear_data("msg_info2", 1000000, 400);
				call clear_data("msg_info3", 1000000, 400);
				call clear_data("msg_info4", 1000000, 400);
				call clear_data("msg_info5", 1000000, 400);
				call clear_data("msg_info6", 1000000, 400);
				call clear_data("msg_info7", 1000000, 400);
				call clear_data("msg_info8", 1000000, 400);
				call clear_data("msg_info9", 1000000, 400);
				call clear_data("login_info0", 10000, 100);
				call clear_data("login_info1", 10000, 100);
				call clear_data("login_info2", 10000, 100);
				call clear_data("login_info3", 10000, 100);
				call clear_data("login_info4", 10000, 100);
				call clear_data("login_info5", 10000, 100);
				call clear_data("login_info6", 10000, 100);
				call clear_data("login_info7", 10000, 100);
				call clear_data("login_info8", 10000, 100);
				call clear_data("login_info9", 10000, 100);
    END;
 //
DELIMITER ; 

-- ----------------------------
-- produrce login
-- ----------------------------