-- ci4.auth_addresses definition

CREATE TABLE `auth_addresses` (
  `id` int(6) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_by` int(5) DEFAULT NULL,
  `ordering_count` int(5) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `street` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `postcode` char(20) DEFAULT NULL,
  `country` char(4) DEFAULT NULL,
  `lang` char(3) DEFAULT NULL,
  `tel1` char(20) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `created_by` (`created_by`),
  KEY `auth_addresses_country` (`country`),
  KEY `street` (`street`),
  KEY `city` (`city`)
) ENGINE=InnoDB AUTO_INCREMENT=7169 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


-- ci4.auth_remember_tokens definition

CREATE TABLE `auth_remember_tokens` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `selector` varchar(255) NOT NULL,
  `hashedValidator` varchar(255) NOT NULL,
  `user_id` int(11) unsigned NOT NULL,
  `expires` datetime NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `selector` (`selector`),
  KEY `auth_remember_tokens_user_id_foreign` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


-- ci4.auth_token_logins definition

CREATE TABLE `auth_token_logins` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ip_address` varchar(255) NOT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `id_type` varchar(255) NOT NULL,
  `identifier` varchar(255) NOT NULL,
  `user_id` int(11) unsigned DEFAULT NULL,
  `date` datetime NOT NULL,
  `success` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_type_identifier` (`id_type`,`identifier`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


-- ci4.catalog_categories definition

CREATE TABLE `catalog_categories` (
  `id` int(9) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `ordering_count` int(11) NOT NULL,
  `name` varchar(30) DEFAULT NULL,
  `parent_id` int(5) DEFAULT NULL,
  `slug` varchar(255) DEFAULT NULL,
  `hidden` enum('y','n') DEFAULT 'n',
  `image_id` char(16) DEFAULT NULL COMMENT 'Image kategorie',
  `product_image_id` char(16) DEFAULT NULL COMMENT 'default image u produktů',
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`) USING BTREE,
  KEY `parent_id` (`parent_id`),
  KEY `image` (`image_id`),
  KEY `image_id` (`image_id`),
  KEY `product_image_id` (`product_image_id`)
) ENGINE=InnoDB AUTO_INCREMENT=185 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ci4.catalog_product_types definition

CREATE TABLE `catalog_product_types` (
  `id` int(9) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `ordering_count` int(11) NOT NULL,
  `name` varchar(150) DEFAULT NULL,
  `code` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ci4.catalog_products definition

CREATE TABLE `catalog_products` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `ordering_count` int(11) NOT NULL,
  `type_id` int(3) NOT NULL DEFAULT 1,
  `category_id` int(4) NOT NULL DEFAULT 1,
  `supplier_id` int(6) DEFAULT NULL,
  `collection_id` int(3) NOT NULL DEFAULT 2000,
  `code` varchar(30) DEFAULT NULL,
  `name` varchar(200) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `file_id` char(15) DEFAULT NULL,
  `video_url` longtext DEFAULT NULL,
  `extra_id` varchar(20) DEFAULT NULL,
  `hidden` enum('y','n') DEFAULT 'n',
  PRIMARY KEY (`id`),
  KEY `type_id` (`type_id`),
  KEY `code` (`code`),
  KEY `name` (`name`),
  KEY `category_id` (`category_id`),
  KEY `supplier_id` (`supplier_id`),
  KEY `hidden` (`hidden`),
  KEY `created_by` (`created_by`),
  KEY `file_id` (`file_id`)
) ENGINE=InnoDB AUTO_INCREMENT=96655 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ci4.catalog_suppliers definition

CREATE TABLE `catalog_suppliers` (
  `id` int(6) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_by` int(5) DEFAULT NULL,
  `ordering_count` int(5) DEFAULT NULL,
  `name` varchar(120) DEFAULT NULL,
  `delivery_days` int(3) DEFAULT 10,
  `date_delivery` datetime NOT NULL,
  `file_id` char(20) DEFAULT NULL,
  `delivery_addresse_id` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `created_by` (`created_by`)
) ENGINE=InnoDB AUTO_INCREMENT=4437 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


-- ci4.catalog_values definition

CREATE TABLE `catalog_values` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `created_by` int(10) NOT NULL DEFAULT 1,
  `ordering_count` int(10) NOT NULL,
  `param_id` int(10) NOT NULL,
  `code` varchar(20) DEFAULT NULL,
  `name` varchar(254) DEFAULT NULL,
  `file_id` varchar(20) DEFAULT NULL,
  `multidata` longtext DEFAULT NULL COMMENT 'json data',
  PRIMARY KEY (`id`),
  UNIQUE KEY `catalog_values_code_IDX` (`code`,`param_id`) USING BTREE,
  KEY `param_id` (`param_id`),
  KEY `code` (`code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- ci4.catalog_variants definition

CREATE TABLE `catalog_variants` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `created_by` int(10) NOT NULL,
  `ordering_count` int(10) DEFAULT NULL,
  `product_id` int(10) NOT NULL,
  `sku` varchar(50) DEFAULT NULL,
  `name` varchar(120) DEFAULT NULL,
  `qty` int(5) NOT NULL DEFAULT 0,
  `qty_minimum` int(5) NOT NULL DEFAULT 0,
  `qty_maximum` int(5) NOT NULL DEFAULT 0,
  `action_id` int(3) DEFAULT NULL,
  `file_id` varchar(20) DEFAULT NULL COMMENT 'Obrazek varianty',
  `discount_id` int(4) DEFAULT NULL,
  `hidden` enum('y','n') NOT NULL DEFAULT 'n',
  PRIMARY KEY (`id`),
  UNIQUE KEY `sku` (`sku`) USING BTREE,
  KEY `product_id` (`product_id`),
  KEY `hidden` (`hidden`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- ci4.data_streams definition

CREATE TABLE `data_streams` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_by` int(4) DEFAULT NULL,
  `ordering_count` int(5) DEFAULT NULL,
  `module_slug` char(60) DEFAULT NULL,
  `stream_slug` char(50) DEFAULT NULL,
  `model_classname` char(80) DEFAULT NULL,
  `stream_name` varchar(120) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `stream_settings` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `created_by` (`created_by`),
  KEY `module_slug` (`module_slug`),
  KEY `stream_slug` (`stream_slug`)
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


-- ci4.data_types definition

CREATE TABLE `data_types` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_by` int(4) DEFAULT NULL,
  `ordering_count` int(5) DEFAULT NULL,
  `name` char(50) DEFAULT NULL,
  `version` float DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `created_by` (`created_by`),
  KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


-- ci4.file_folders definition

CREATE TABLE `file_folders` (
  `id` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_by` int(11) DEFAULT 1,
  `ordering_count` int(11) DEFAULT 0,
  `parent_id` int(11) DEFAULT 0,
  `slug` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  KEY `parent_id` (`parent_id`),
  KEY `slug` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ci4.files definition

CREATE TABLE `files` (
  `id` char(15) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `ordering_count` int(11) NOT NULL DEFAULT 0,
  `created_by` int(11) NOT NULL DEFAULT 1,
  `folder_id` int(5) DEFAULT NULL,
  `type` enum('a','v','d','i','o') DEFAULT NULL,
  `name` varchar(150) NOT NULL,
  `description` varchar(100) DEFAULT NULL,
  `filename` varchar(255) NOT NULL,
  `extension` char(6) NOT NULL,
  `mimetype` char(100) DEFAULT NULL,
  `width` int(5) DEFAULT NULL,
  `height` int(5) DEFAULT NULL,
  `filesize` int(11) NOT NULL DEFAULT 0,
  `download_count` int(11) DEFAULT 0,
  `generate_issue` enum('y','n','1','2') DEFAULT 'n',
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `folder_id` (`folder_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ci4.migrations definition

CREATE TABLE `migrations` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `version` varchar(255) NOT NULL,
  `class` varchar(255) NOT NULL,
  `group` varchar(255) NOT NULL,
  `namespace` varchar(255) NOT NULL,
  `time` int(11) NOT NULL,
  `batch` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=87 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


-- ci4.orders definition

CREATE TABLE `orders` (
  `id` int(6) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `ordering_count` int(6) DEFAULT NULL,
  `created_by` int(11) NOT NULL,
  `handled_by` int(3) DEFAULT NULL,
  `extracode` char(35) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `status_id` int(3) NOT NULL DEFAULT 1,
  `client_id` int(11) NOT NULL,
  `transit_id` int(3) DEFAULT NULL,
  `payment_id` int(3) DEFAULT NULL,
  `invoice_user_id` int(11) DEFAULT NULL,
  `delivery_addresse_id` int(8) DEFAULT NULL,
  `date_delivery` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `handled_by` (`handled_by`),
  KEY `status_id` (`status_id`),
  KEY `production_delivery_addresse_id` (`delivery_addresse_id`),
  KEY `InvoiceUser` (`invoice_user_id`),
  KEY `ClientFK` (`client_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


-- ci4.orders_rows definition

CREATE TABLE `orders_rows` (
  `id` int(6) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `ordering_count` int(6) DEFAULT NULL,
  `created_by` int(11) NOT NULL,
  `order_id` int(10) NOT NULL,
  `product_id` int(15) NOT NULL,
  `status_id` int(3) NOT NULL DEFAULT 1,
  `description` longtext DEFAULT NULL,
  `date_delivery` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `status_id` (`status_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


-- ci4.orders_rows_values definition

CREATE TABLE `orders_rows_values` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `created_by` int(10) NOT NULL,
  `ordering_count` int(10) NOT NULL,
  `order_row_id` int(15) NOT NULL,
  `field_value_id` int(15) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- ci4.pages definition

CREATE TABLE `pages` (
  `id` int(5) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_by` int(5) DEFAULT NULL,
  `ordering_count` int(5) DEFAULT NULL,
  `parent_id` int(6) DEFAULT NULL,
  `name` varchar(120) DEFAULT NULL,
  `slug` varchar(60) DEFAULT NULL,
  `uri` varchar(120) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `created_by` (`created_by`),
  KEY `parent_id` (`parent_id`),
  KEY `slug` (`slug`),
  KEY `uri` (`uri`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- ci4.production_files definition

CREATE TABLE `production_files` (
  `id` int(5) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_by` int(5) DEFAULT NULL,
  `ordering_count` int(5) DEFAULT NULL,
  `production_id` int(11) NOT NULL,
  `file_id` varchar(15) NOT NULL,
  `status_id` tinyint(2) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `created_by` (`created_by`),
  KEY `file_id` (`file_id`)
) ENGINE=InnoDB AUTO_INCREMENT=79041 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


-- ci4.production_status definition

CREATE TABLE `production_status` (
  `id` int(5) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_by` int(5) DEFAULT NULL,
  `ordering_count` int(5) DEFAULT NULL,
  `name` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `created_by` (`created_by`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


-- ci4.sessions definition

CREATE TABLE `sessions` (
  `id` varchar(128) NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `timestamp` int(10) unsigned NOT NULL DEFAULT 0,
  `data` text NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `timestamp` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


-- ci4.settings definition

CREATE TABLE `settings` (
  `id` int(9) NOT NULL AUTO_INCREMENT,
  `class` varchar(255) NOT NULL,
  `key` varchar(255) NOT NULL,
  `value` text DEFAULT NULL,
  `type` varchar(31) NOT NULL DEFAULT 'string',
  `context` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


-- ci4.users definition

CREATE TABLE `users` (
  `id` int(6) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_by` int(6) NOT NULL DEFAULT 1,
  `ordering_count` int(6) DEFAULT NULL,
  `username` varchar(30) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(150) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `status_message` varchar(255) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 0,
  `last_active` datetime DEFAULT NULL,
  `main_addresse_id` int(5) DEFAULT NULL,
  `invoice_user_id` int(6) DEFAULT NULL,
  `delivery_addresse_id` int(6) DEFAULT NULL,
  `dealer_id` int(6) DEFAULT NULL,
  `transit_id` int(3) DEFAULT NULL,
  `payment_id` int(3) DEFAULT NULL,
  `ico` varchar(60) DEFAULT NULL,
  `company` varchar(200) DEFAULT NULL,
  `dic` varchar(60) DEFAULT NULL,
  `icz` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  KEY `users_invoice_addresse_id` (`invoice_user_id`),
  KEY `users_delivery_addresse_id` (`delivery_addresse_id`),
  KEY `active` (`active`),
  KEY `created_by` (`created_by`),
  KEY `users_ico` (`ico`),
  KEY `users_company` (`company`)
) ENGINE=InnoDB AUTO_INCREMENT=7068 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


-- ci4.auth_groups_users definition

CREATE TABLE `auth_groups_users` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_by` int(6) DEFAULT NULL,
  `ordering_count` int(6) DEFAULT NULL,
  `user_id` int(6) NOT NULL,
  `group` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  UNIQUE KEY `group_user_id` (`user_id`,`group`) USING BTREE,
  KEY `group` (`group`),
  CONSTRAINT `auth_groups_users_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7069 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


-- ci4.auth_identities definition

CREATE TABLE `auth_identities` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_by` int(6) NOT NULL DEFAULT 1,
  `ordering_count` int(6) NOT NULL,
  `user_id` int(6) NOT NULL,
  `type` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `secret` varchar(255) DEFAULT NULL,
  `secret2` varchar(255) DEFAULT NULL,
  `expires` datetime DEFAULT NULL,
  `extra` text DEFAULT NULL,
  `force_reset` tinyint(1) NOT NULL DEFAULT 0,
  `last_used_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `type_secret` (`type`,`secret`),
  KEY `created_by` (`created_by`),
  KEY `auth_identities_name` (`name`),
  KEY `secret` (`secret`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `auth_identities_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7070 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


-- ci4.auth_logins definition

CREATE TABLE `auth_logins` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ip_address` varchar(255) NOT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `id_type` varchar(255) NOT NULL,
  `identifier` varchar(255) NOT NULL,
  `user_id` int(6) DEFAULT NULL,
  `date` datetime NOT NULL,
  `success` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_type_identifier` (`id_type`,`identifier`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `auth_logins_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=226 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


-- ci4.auth_permissions_users definition

CREATE TABLE `auth_permissions_users` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(6) NOT NULL,
  `permission` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `auth_permissions_users_user_id_foreign` (`user_id`),
  CONSTRAINT `auth_permissions_users_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


-- ci4.auth_user_addresse definition

CREATE TABLE `auth_user_addresse` (
  `id` int(6) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_by` int(5) DEFAULT NULL,
  `ordering_count` int(5) DEFAULT NULL,
  `user_id` int(6) NOT NULL,
  `addresse_id` int(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_addresse_id` (`user_id`,`addresse_id`),
  KEY `created_by` (`created_by`),
  KEY `addresse_id` (`addresse_id`),
  CONSTRAINT `auth_user_addresse_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `auth_user_addresse_ibfk_2` FOREIGN KEY (`addresse_id`) REFERENCES `auth_addresses` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7169 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


-- ci4.catalog_products_categories definition

CREATE TABLE `catalog_products_categories` (
  `id` int(9) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `ordering_count` int(11) NOT NULL,
  `category_id` int(4) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `category_id` (`category_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `FK1_catalog_products_categories` FOREIGN KEY (`category_id`) REFERENCES `catalog_categories` (`id`),
  CONSTRAINT `FK2_catalog_products_categories` FOREIGN KEY (`product_id`) REFERENCES `catalog_products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=14298 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ci4.data_streams_fields definition

CREATE TABLE `data_streams_fields` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_by` int(4) DEFAULT NULL,
  `ordering_count` int(5) DEFAULT NULL,
  `field_direction` enum('row','column') NOT NULL DEFAULT 'row',
  `type_id` int(5) DEFAULT NULL,
  `stream_id` int(5) DEFAULT NULL,
  `field_slug` char(40) DEFAULT NULL,
  `field_name` varchar(120) DEFAULT NULL,
  `field_dbschema` longtext DEFAULT NULL,
  `field_data` longtext DEFAULT NULL,
  `field_html` longtext DEFAULT NULL,
  `field_rules` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `data_streams_field_slug` (`stream_id`,`field_slug`) USING BTREE,
  KEY `created_by` (`created_by`),
  KEY `stream_id` (`stream_id`),
  KEY `field_name` (`field_name`),
  KEY `field_slug` (`field_slug`) USING BTREE,
  KEY `data_streams_fields_data_types_FK` (`type_id`),
  CONSTRAINT `data_streams_fields_data_streams_FK` FOREIGN KEY (`stream_id`) REFERENCES `data_streams` (`id`) ON DELETE CASCADE,
  CONSTRAINT `data_streams_fields_data_types_FK` FOREIGN KEY (`type_id`) REFERENCES `data_types` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=237 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


-- ci4.data_streams_values definition

CREATE TABLE `data_streams_values` (
  `id` int(5) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_by` int(5) DEFAULT NULL,
  `ordering_count` int(5) DEFAULT NULL,
  `stream_id` int(10) DEFAULT NULL COMMENT 'Transport',
  `entry_id` int(15) NOT NULL,
  `param_id` int(10) NOT NULL COMMENT 'id from data stream fields',
  `value` varchar(255) DEFAULT NULL COMMENT 'value or id param',
  PRIMARY KEY (`id`),
  KEY `created_by` (`created_by`),
  KEY `param_id` (`param_id`) USING BTREE,
  KEY `data_streams_values_data_streams_FK` (`stream_id`),
  CONSTRAINT `data_streams_values_data_streams_FK` FOREIGN KEY (`stream_id`) REFERENCES `data_streams` (`id`) ON DELETE CASCADE,
  CONSTRAINT `data_streams_values_data_streams_fields_FK` FOREIGN KEY (`param_id`) REFERENCES `data_streams_fields` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='Hodnoty parametrů - obecné';


-- ci4.production definition

CREATE TABLE `production` (
  `id` int(6) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `ordering_count` int(6) DEFAULT NULL,
  `created_by` int(11) NOT NULL,
  `handled_by` int(3) DEFAULT NULL,
  `code` char(35) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `status_id` int(3) NOT NULL DEFAULT 1,
  `client_id` int(11) NOT NULL,
  `transit_id` int(3) DEFAULT NULL,
  `payment_id` int(3) DEFAULT NULL,
  `invoice_user_id` int(11) DEFAULT NULL,
  `delivery_addresse_id` int(8) DEFAULT NULL,
  `date_delivery` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `handled_by` (`handled_by`),
  KEY `status_id` (`status_id`),
  KEY `production_delivery_addresse_id` (`delivery_addresse_id`),
  KEY `InvoiceUser` (`invoice_user_id`),
  KEY `ClientFK` (`client_id`),
  CONSTRAINT `ClientFK` FOREIGN KEY (`client_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=40345 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


-- ci4.catalog_products_params definition

CREATE TABLE `catalog_products_params` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `created_by` int(10) NOT NULL,
  `ordering_count` int(10) NOT NULL,
  `product_id` int(10) NOT NULL,
  `param_id` int(10) NOT NULL,
  `catalog_value_id` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `product_id_2` (`product_id`,`param_id`),
  KEY `product_id` (`product_id`),
  KEY `param_id` (`param_id`),
  CONSTRAINT `catalog_products_params_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `catalog_products` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `catalog_products_params_ibfk_2` FOREIGN KEY (`param_id`) REFERENCES `data_streams_fields` (`id`) ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- ci4.catalog_variants_params definition

CREATE TABLE `catalog_variants_params` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `created_by` int(10) NOT NULL,
  `ordering_count` int(10) NOT NULL,
  `variant_id` int(10) NOT NULL,
  `param_id` int(10) NOT NULL,
  `catalog_value_id` int(10) DEFAULT NULL COMMENT 'catalog_value_id',
  PRIMARY KEY (`id`),
  UNIQUE KEY `catalog_variants_values_param_id_IDX` (`param_id`,`variant_id`) USING BTREE,
  KEY `variant_id` (`variant_id`),
  KEY `param_id` (`param_id`),
  KEY `param_value_id` (`catalog_value_id`),
  CONSTRAINT `catalog_variants_params_ibfk_3` FOREIGN KEY (`catalog_value_id`) REFERENCES `catalog_values` (`id`) ON UPDATE NO ACTION,
  CONSTRAINT `catalog_variants_params_ibfk_4` FOREIGN KEY (`variant_id`) REFERENCES `catalog_variants` (`id`) ON DELETE CASCADE,
  CONSTRAINT `catalog_variants_values_data_streams_fields_FK` FOREIGN KEY (`param_id`) REFERENCES `data_streams_fields` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;