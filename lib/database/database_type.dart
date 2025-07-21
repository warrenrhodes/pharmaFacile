class DatabaseConfigInterface {
  final String? host;
  final int? port;
  final String? user;
  final String? password;
  final String? database;
  final String? username;

  DatabaseConfigInterface({
    this.host,
    this.port,
    this.user,
    this.password,
    this.database,
    this.username,
  });
}

class DatabaseConfig {
  static DatabaseConfigInterface mysql() {
    return DatabaseConfigInterface(
      host: 'localhost',
      port: 3306,
      user: 'root',
      password: 'root',
      database: 'pharmacie',
    );
  }

  static DatabaseConfigInterface postgresql() {
    return DatabaseConfigInterface(
      host: 'localhost',
      port: 5432,
      user: 'root',
      password: 'root',
      database: 'pharmacie',
    );
  }

  static DatabaseConfigInterface sqlite() {
    return DatabaseConfigInterface(database: 'pharmacie');
  }
}
