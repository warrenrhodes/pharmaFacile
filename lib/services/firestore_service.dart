import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Get a document by path
  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument(String path) {
    return _db.doc(path).get();
  }

  /// Set a document by path
  Future<void> setDocument(String path, Map<String, dynamic> data) {
    return _db.doc(path).set(data);
  }

  /// Update a document by path
  Future<void> updateDocument(String path, Map<String, dynamic> data) {
    return _db.doc(path).update(data);
  }

  /// Delete a document by path
  Future<void> deleteDocument(String path) {
    return _db.doc(path).delete();
  }

  /// Get a collection as a stream
  Stream<QuerySnapshot<Map<String, dynamic>>> getCollectionStream(String path) {
    return _db.collection(path).snapshots();
  }
}
