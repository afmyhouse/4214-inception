define( 'DB_NAME', getenv('MYSQL_DATABASE') ?: 'wordpress_db' );
define( 'DB_USER', getenv('MYSQL_USER') ?: 'wp_user' );
define( 'DB_PASSWORD', getenv('MYSQL_PASSWORD') ?: 'wp_pass' );
define( 'DB_HOST', getenv('DB_HOST') ?: 'mariadb:3306' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );

define('AUTH_KEY', getenv('AUTH_KEY'));
define('SECURE_AUTH_KEY',  getenv(SECURE_AUTH_KEY));
define('LOGGED_IN_KEY',    getenv(LOGGED_IN_KEY));
define('NONCE_KEY',        getenv(NONCE_KEY));
define('AUTH_SALT',        getenv(AUTH_SALT));
define('SECURE_AUTH_SALT', getenv(SECURE_AUTH_SALT));
define('LOGGED_IN_SALT',   getenv(LOGGED_IN_SALT));
define('NONCE_SALT',       getenv(NONCE_SALT));

define('WP_HOME', 'https://local.wordpress.local');
define('WP_SITEURL', 'http://wordpress.local');
