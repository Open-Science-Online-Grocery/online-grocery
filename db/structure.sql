
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
DROP TABLE IF EXISTS `ar_internal_metadata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ar_internal_metadata` (
  `key` varchar(255) NOT NULL,
  `value` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `cart_summary_labels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cart_summary_labels` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `built_in` tinyint(1) DEFAULT 0,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `categories` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `condition_cart_summary_labels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `condition_cart_summary_labels` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `condition_id` bigint(20) DEFAULT NULL,
  `cart_summary_label_id` bigint(20) DEFAULT NULL,
  `equation_tokens` text DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `always_show` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `index_condition_cart_summary_labels_on_condition_id` (`condition_id`),
  KEY `index_condition_cart_summary_labels_on_cart_summary_label_id` (`cart_summary_label_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `condition_labels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `condition_labels` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `condition_id` bigint(20) DEFAULT NULL,
  `label_id` bigint(20) DEFAULT NULL,
  `position` varchar(255) DEFAULT NULL,
  `size` int(11) DEFAULT NULL,
  `equation_tokens` text DEFAULT NULL,
  `always_show` tinyint(1) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `tooltip_text` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_condition_labels_on_condition_id` (`condition_id`),
  KEY `index_condition_labels_on_label_id` (`label_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `condition_product_sort_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `condition_product_sort_fields` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `condition_id` bigint(20) DEFAULT NULL,
  `product_sort_field_id` bigint(20) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_condition_product_sort_fields_on_condition_id` (`condition_id`),
  KEY `index_condition_product_sort_fields_on_product_sort_field_id` (`product_sort_field_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `conditions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `conditions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `experiment_id` bigint(20) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `nutrition_styles` text DEFAULT NULL,
  `default_sort_field_id` bigint(20) DEFAULT NULL,
  `default_sort_order` varchar(255) DEFAULT NULL,
  `sort_equation_tokens` text DEFAULT NULL,
  `filter_by_custom_categories` tinyint(1) NOT NULL DEFAULT 0,
  `show_price_total` tinyint(1) NOT NULL DEFAULT 1,
  `food_count_format` varchar(255) DEFAULT NULL,
  `only_add_from_detail_page` tinyint(1) DEFAULT 0,
  `nutrition_equation_tokens` text DEFAULT NULL,
  `minimum_spend` decimal(10,2) DEFAULT NULL,
  `maximum_spend` decimal(10,2) DEFAULT NULL,
  `may_add_to_cart_by_dollar_amount` tinyint(1) DEFAULT 0,
  `show_guiding_stars` tinyint(1) DEFAULT 1,
  `qualtrics_code` varchar(255) DEFAULT NULL,
  `sort_type` varchar(255) DEFAULT NULL,
  `show_products_by_subcategory` tinyint(1) DEFAULT 1,
  `allow_searching` tinyint(1) DEFAULT 1,
  `show_custom_attribute_on_product` tinyint(1) NOT NULL DEFAULT 0,
  `show_custom_attribute_on_checkout` tinyint(1) NOT NULL DEFAULT 0,
  `custom_attribute_units` varchar(255) DEFAULT NULL,
  `custom_attribute_name` varchar(255) DEFAULT NULL,
  `display_old_price` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_conditions_on_experiment_id` (`experiment_id`),
  KEY `index_conditions_on_default_sort_field_id` (`default_sort_field_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `config_files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `config_files` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `file` varchar(255) DEFAULT NULL,
  `condition_id` bigint(20) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_config_files_on_condition_id` (`condition_id`),
  KEY `index_config_files_on_id_and_type` (`id`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `custom_product_attributes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `custom_product_attributes` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `condition_id` bigint(20) DEFAULT NULL,
  `product_attribute_csv_file_id` bigint(20) DEFAULT NULL,
  `product_id` bigint(20) DEFAULT NULL,
  `custom_attribute_amount` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_custom_product_attributes_on_condition_id` (`condition_id`),
  KEY `index_custom_product_attributes_on_product_attribute_csv_file_id` (`product_attribute_csv_file_id`),
  KEY `index_custom_product_attributes_on_product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `custom_product_prices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `custom_product_prices` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `condition_id` bigint(20) DEFAULT NULL,
  `product_price_csv_file_id` bigint(20) DEFAULT NULL,
  `product_id` bigint(20) DEFAULT NULL,
  `new_price` decimal(64,12) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_custom_product_prices_on_condition_id` (`condition_id`),
  KEY `index_custom_product_prices_on_product_price_csv_file_id` (`product_price_csv_file_id`),
  KEY `index_custom_product_prices_on_product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `custom_sortings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `custom_sortings` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `session_identifier` varchar(255) DEFAULT NULL,
  `condition_id` bigint(20) DEFAULT NULL,
  `sort_file_id` bigint(20) DEFAULT NULL,
  `product_id` bigint(20) DEFAULT NULL,
  `sort_order` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_custom_sortings_on_condition_id` (`condition_id`),
  KEY `index_custom_sortings_on_sort_file_id` (`sort_file_id`),
  KEY `index_custom_sortings_on_product_id` (`product_id`),
  KEY `index_custom_sortings_on_session_identifier` (`session_identifier`),
  KEY `index_custom_sortings_on_sort_order` (`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `experiment_results`;
/*!50001 DROP VIEW IF EXISTS `experiment_results`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `experiment_results` AS SELECT
 1 AS `experiment_id`,
  1 AS `experiment_name`,
  1 AS `condition_name`,
  1 AS `session_identifier`,
  1 AS `action_type`,
  1 AS `product_id`,
  1 AS `product_name`,
  1 AS `quantity`,
  1 AS `serial_position`,
  1 AS `detail`,
  1 AS `performed_at` */;
SET character_set_client = @saved_cs_client;
DROP TABLE IF EXISTS `experiments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `experiments` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_experiments_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `labels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `labels` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `built_in` tinyint(1) DEFAULT 0,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `participant_actions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `participant_actions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `session_identifier` varchar(255) DEFAULT NULL,
  `condition_id` bigint(20) DEFAULT NULL,
  `action_type` varchar(255) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `product_id` bigint(20) DEFAULT NULL,
  `serial_position` int(11) DEFAULT NULL,
  `detail` varchar(255) DEFAULT NULL,
  `performed_at` datetime DEFAULT NULL,
  `frontend_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_participant_actions_on_condition_id` (`condition_id`),
  KEY `index_participant_actions_on_product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `product_attribute_csv_files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_attribute_csv_files` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `csv_file` varchar(255) DEFAULT NULL,
  `condition_id` bigint(20) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_product_attribute_csv_files_on_condition_id` (`condition_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `product_price_csv_files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_price_csv_files` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `csv_file` varchar(255) DEFAULT NULL,
  `condition_id` bigint(20) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_product_price_csv_files_on_condition_id` (`condition_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `product_sort_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_sort_fields` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `product_suggestions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_suggestions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `product_id` bigint(20) DEFAULT NULL,
  `add_on_product_id` bigint(20) DEFAULT NULL,
  `suggestion_csv_file_id` bigint(20) DEFAULT NULL,
  `condition_id` bigint(20) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_product_suggestions_on_product_id` (`product_id`),
  KEY `index_product_suggestions_on_add_on_product_id` (`add_on_product_id`),
  KEY `index_product_suggestions_on_suggestion_csv_file_id` (`suggestion_csv_file_id`),
  KEY `index_product_suggestions_on_condition_id` (`condition_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `product_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_tags` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `product_id` bigint(20) NOT NULL,
  `tag_id` bigint(20) NOT NULL,
  `subtag_id` bigint(20) DEFAULT NULL,
  `condition_id` bigint(20) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_product_tags_on_product_id` (`product_id`),
  KEY `index_product_tags_on_tag_id` (`tag_id`),
  KEY `index_product_tags_on_subtag_id` (`subtag_id`),
  KEY `index_product_tags_on_condition_id` (`condition_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `products` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `size` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `image_src` text DEFAULT NULL,
  `serving_size` varchar(255) DEFAULT NULL,
  `servings` varchar(255) DEFAULT NULL,
  `calories_from_fat` int(11) DEFAULT NULL,
  `calories` int(11) DEFAULT NULL,
  `total_fat` decimal(10,1) DEFAULT NULL,
  `saturated_fat` decimal(10,1) DEFAULT NULL,
  `trans_fat` decimal(10,1) DEFAULT NULL,
  `poly_fat` decimal(10,1) DEFAULT NULL,
  `mono_fat` decimal(10,1) DEFAULT NULL,
  `cholesterol` decimal(6,2) DEFAULT NULL,
  `sodium` int(11) DEFAULT NULL,
  `potassium` int(11) DEFAULT NULL,
  `carbs` int(11) DEFAULT NULL,
  `fiber` int(11) DEFAULT NULL,
  `sugar` int(11) DEFAULT NULL,
  `protein` int(11) DEFAULT NULL,
  `vitamins` text DEFAULT NULL,
  `ingredients` text DEFAULT NULL,
  `allergens` text DEFAULT NULL,
  `price` decimal(64,12) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `subcategory_id` int(11) DEFAULT NULL,
  `starpoints` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `subsubcategory_id` bigint(20) DEFAULT NULL,
  `aws_image_url` varchar(255) DEFAULT NULL,
  `serving_size_grams` decimal(6,1) DEFAULT NULL,
  `caloric_density` decimal(6,1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_products_on_subsubcategory_id` (`subsubcategory_id`),
  KEY `index_products_on_category_id` (`category_id`),
  KEY `index_products_on_subcategory_id` (`subcategory_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  PRIMARY KEY (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `subcategories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `subcategories` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `category_id` int(11) DEFAULT NULL,
  `display_order` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_subcategories_on_category_id` (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `subcategory_exclusions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `subcategory_exclusions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `condition_id` bigint(20) DEFAULT NULL,
  `subcategory_id` bigint(20) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_subcategory_exclusions_on_condition_id` (`condition_id`),
  KEY `index_subcategory_exclusions_on_subcategory_id` (`subcategory_id`),
  KEY `index_subcategory_exclusions_on_condition_id_and_subcategory_id` (`condition_id`,`subcategory_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `subsubcategories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `subsubcategories` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `subcategory_id` bigint(20) DEFAULT NULL,
  `display_order` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_subsubcategories_on_subcategory_id` (`subcategory_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `subtags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `subtags` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `tag_id` bigint(20) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_subtags_on_tag_id` (`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tags` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL DEFAULT '',
  `encrypted_password` varchar(255) NOT NULL DEFAULT '',
  `reset_password_token` varchar(255) DEFAULT NULL,
  `reset_password_sent_at` datetime DEFAULT NULL,
  `remember_created_at` datetime DEFAULT NULL,
  `sign_in_count` int(11) NOT NULL DEFAULT 0,
  `current_sign_in_at` datetime DEFAULT NULL,
  `last_sign_in_at` datetime DEFAULT NULL,
  `current_sign_in_ip` varchar(255) DEFAULT NULL,
  `last_sign_in_ip` varchar(255) DEFAULT NULL,
  `confirmation_token` varchar(255) DEFAULT NULL,
  `confirmed_at` datetime DEFAULT NULL,
  `confirmation_sent_at` datetime DEFAULT NULL,
  `unconfirmed_email` varchar(255) DEFAULT NULL,
  `failed_attempts` int(11) NOT NULL DEFAULT 0,
  `unlock_token` varchar(255) DEFAULT NULL,
  `locked_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `first_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_email` (`email`),
  UNIQUE KEY `index_users_on_reset_password_token` (`reset_password_token`),
  UNIQUE KEY `index_users_on_confirmation_token` (`confirmation_token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50001 DROP VIEW IF EXISTS `experiment_results`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `experiment_results` AS select `experiments`.`id` AS `experiment_id`,`experiments`.`name` AS `experiment_name`,`conditions`.`name` AS `condition_name`,`participant_actions`.`session_identifier` AS `session_identifier`,`participant_actions`.`action_type` AS `action_type`,`participant_actions`.`product_id` AS `product_id`,`products`.`name` AS `product_name`,`participant_actions`.`quantity` AS `quantity`,`participant_actions`.`serial_position` AS `serial_position`,`participant_actions`.`detail` AS `detail`,`participant_actions`.`performed_at` AS `performed_at` from (((`experiments` join `conditions` on(`conditions`.`experiment_id` = `experiments`.`id`)) join `participant_actions` on(`participant_actions`.`condition_id` = `conditions`.`id`)) left join `products` on(`participant_actions`.`product_id` = `products`.`id`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

INSERT INTO `schema_migrations` (version) VALUES
('20180919181445'),
('20180919182806'),
('20180920131524'),
('20180924160613'),
('20181029180040'),
('20181101134850'),
('20181101140714'),
('20181101144453'),
('20181101192221'),
('20181101195927'),
('20181101201931'),
('20181102153742'),
('20181105145354'),
('20181106180529'),
('20181107141053'),
('20181107212757'),
('20181108190400'),
('20181108190901'),
('20181108205830'),
('20181109184849'),
('20181109192449'),
('20181111220655'),
('20181112171539'),
('20181112183838'),
('20181114142831'),
('20181114144446'),
('20181119164647'),
('20181126022808'),
('20181127155504'),
('20181127212210'),
('20181130211619'),
('20181211164301'),
('20181211184522'),
('20190221200154'),
('20190227175452'),
('20190227180805'),
('20190306151626'),
('20190307193245'),
('20190319133936'),
('20190822140435'),
('20190822140828'),
('20210204170847'),
('20210208152732'),
('20210210181943'),
('20210217174649'),
('20210223151548'),
('20210310181245'),
('20210930175208'),
('20211001155043'),
('20211005133810'),
('20211006163426'),
('20211007184814'),
('20211101155624'),
('20211101190836'),
('20211221205528'),
('20211222160023'),
('20220114152549'),
('20221229170233'),
('20221229172827'),
('20221229180249'),
('20230102153452'),
('20230119135913'),
('20230119140755'),
('20230123192926'),
('20230208163854');


