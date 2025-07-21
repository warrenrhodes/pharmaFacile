import 'package:appwrite/appwrite.dart';

class AppWriteConfig {
  static Client client = Client()
      .setEndpoint("https://fra.cloud.appwrite.io/v1")
      .setProject("6875891b003785cb2e4e");
  static final account = Account(client);
  static final databases = Databases(client);
  static final storage = Storage(client);
  static const databaseID = '6876d21300113b340539';
}
