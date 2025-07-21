import '../database/database.dart';
import '../database/document_filter.dart';
import '../models/user.dart';
import 'constants/collections.dart';

class UserRepository {
  final Database _database;

  UserRepository(this._database);

  static const String _collectionPath = CollectionsName.users;

  Future<User?> getUser(String userId) async {
    final record = await _database.getRecordByDocumentPath(
      '$_collectionPath/$userId',
      [],
    );
    if (record != null) {
      return User.fromJson(record.cast<String, dynamic>());
    }
    return null;
  }

  Future<List<User>> getUsers({List<DocumentQuery>? filters}) async {
    final collection = await _database.getCollection(
      _collectionPath,
      filters: filters ?? [],
    );

    return collection?.values
            .map((json) => User.fromJson(json.cast<String, dynamic>()))
            .toList() ??
        [];
  }

  Future<String> createUser(User user) async {
    final userJson = user.toJson();
    userJson.remove('id');

    final userId = await _database.createRecord(_collectionPath, userJson, []);

    return userId ?? user.id;
  }

  Future<bool> updateUser(User user) async {
    final userJson = user.toJson();
    // Remove fields that shouldn't be updated
    userJson.remove('createdAtInUtc');

    return await _database.setRecord(
      documentPath: '$_collectionPath/${user.id}',
      recordMap: userJson,
      merge: true,
    );
  }

  Future<bool> deleteUser(String userId) async {
    await _database.removeRecordsByPath(_collectionPath, [userId], []);
    return true;
  }

  Future<User?> getUserByEmail(String email) async {
    final users = await getUsers(
      filters: [
        DocumentQuery('email', email, DocumentFieldCondition.isEqualTo),
      ],
    );
    return users.isNotEmpty ? users.first : null;
  }
}
