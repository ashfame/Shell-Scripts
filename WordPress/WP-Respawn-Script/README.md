WordPress Respawn Script
========================

Removes all the WordPress tables from the database and restore a database backup file.

Note:
-----

* Call the script by either passing the path to wp-config.php (or any file which holds WP DB credentials), else it will look for wp-config.php in the current directory.

* Will import the database back from wp.sql file which should exist in the current directory