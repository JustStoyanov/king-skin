CREATE TABLE `character_skins` (
    `id` int(10) NOT NULL AUTO_INCREMENT,
    `charid` int(10) NOT NULL,
    `current_skin` longtext DEFAULT '[]',
    `saved_haircuts` longtext DEFAULT '[]',
    `saved_outfits` longtext DEFAULT '[]',
    `prop_status` longtext DEFAULT '[]',
    `job_skin` int(10) DEFAULT 0,
    `non_job_skin` longtext DEFAULT '[]',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;