import 'dart:async';
import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:pharmacie_stock/config/app_write_config.dart';
import 'package:pharmacie_stock/database/document_filter.dart';
import 'package:pharmacie_stock/database/document_orders.dart';

import '../database.dart';

class AppWriterDatabaseImplementation implements Database {
  final Client client;
  final Databases databases;
  final Storage storage;
  final String databaseId;

  AppWriterDatabaseImplementation()
    : client = AppWriteConfig.client,
      databases = AppWriteConfig.databases,
      databaseId = AppWriteConfig.databaseID,
      storage = AppWriteConfig.storage;

  @override
  Future<String?> createRecord(
    String collectionPath,
    Map<String, dynamic> recordMap,
    List<String>? permissions,
  ) async {
    try {
      // For offline-first: Save to local DB first
      // final localId = _localBox.add(recordMap);

      // For online operation

      final document = await databases.createDocument(
        databaseId: databaseId,
        collectionId: '6876d231003858b7a51b',
        documentId: ID.unique(),
        data: recordMap,
        permissions: permissions,
      );

      return document.$id;
    } on AppwriteException catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  @override
  Future<bool> deleteFile(String recordPath, List<String>? permissions) async {
    try {
      await storage.deleteFile(bucketId: 'pharmacyFiles', fileId: recordPath);
      return true;
    } on AppwriteException catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  @override
  Future<Map<String, Map>?> getCollection(
    String collectionPath, {
    List<DocumentQuery> filters = const [],
    DocumentOrderBy? orderBy,
    List<String>? permissions,
    int? limit,
  }) async {
    try {
      // Convert filters to Appwrite format
      final queryFilters = filters.map((f) {
        switch (f.condition) {
          case DocumentFieldCondition.isEqualTo:
            return Query.equal(f.key, [f.value]);
          case DocumentFieldCondition.isGreaterThan:
            return Query.greaterThan(f.key, f.value);
          case DocumentFieldCondition.isGreaterThanOrEqualTo:
            return Query.greaterThanEqual(f.key, f.value);
          case DocumentFieldCondition.isLessThan:
            return Query.lessThan(f.key, f.value);
          case DocumentFieldCondition.isLessThanOrEqualTo:
            return Query.lessThanEqual(f.key, f.value);
          case DocumentFieldCondition.isNotEqualTo:
            return Query.notEqual(f.key, [f.value]);
          case DocumentFieldCondition.whereIn:
            return Query.equal(f.key, f.value is List ? f.value : [f.value]);
          case DocumentFieldCondition.arrayContains:
            return Query.search(f.key, f.value);
        }
      }).toList();

      // Handle ordering
      if (orderBy != null) {
        queryFilters.add(
          orderBy.descending
              ? Query.orderDesc(orderBy.field)
              : Query.orderAsc(orderBy.field),
        );
      }

      // Handle limit
      if (limit != null && limit > 0) {
        queryFilters.add(Query.limit(limit));
      }

      final documents = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: collectionPath,
        queries: queryFilters,
      );

      return {for (var doc in documents.documents) doc.$id: doc.data};
    } on AppwriteException catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  @override
  Future<ImageProvider<Object>?> getImage(
    String imageRef,
    List<String>? permissions,
  ) async {
    try {
      final url = await storage.getFileDownload(
        bucketId: 'pharmacyFiles',
        fileId: imageRef,
      );
      return NetworkImage(url.toString());
    } on AppwriteException catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  @override
  Future<Map?> getRecordByDocumentPath(
    String path,
    List<String>? permissions,
  ) async {
    try {
      final parts = path.split('/');
      final collectionId = parts[0];
      final documentId = parts[1];

      final document = await databases.getDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: documentId,
      );

      return document.data;
    } on AppwriteException catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  @override
  Future<void> removeRecordByValue(
    String collectionPath,
    List<DocumentQuery> documentQueries,
    List<String>? permissions,
  ) async {
    try {
      final collection = await getCollection(
        collectionPath,
        filters: documentQueries,
      );
      if (collection != null) {
        await removeRecordsByPath(
          collectionPath,
          collection.keys.toList(),
          permissions,
        );
      }
    } on AppwriteException catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Future<void> removeRecordsByPath(
    String collectionPath,
    List<String> documentsIds,
    List<String>? permissions,
  ) async {
    try {
      final parts = collectionPath.split('/');
      final collectionId = parts[0];

      for (var id in documentsIds) {
        await databases.deleteDocument(
          databaseId: databaseId,
          collectionId: collectionId,
          documentId: id,
        );
      }
    } on AppwriteException catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Future<bool> setFile(
    Uint8List fileData,
    String recordPath,
    List<String>? permissions,
  ) async {
    try {
      await storage.createFile(
        bucketId: 'pharmacyFiles',
        fileId: ID.unique(),
        file: InputFile.fromBytes(bytes: fileData, filename: recordPath),
        permissions: permissions,
      );
      return true;
    } on AppwriteException catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  @override
  Future<bool> setRecord({
    required String documentPath,
    required Map<String, dynamic> recordMap,
    bool merge = true,
    List<String>? permissions,
  }) async {
    try {
      final parts = documentPath.split('/');
      final collectionId = parts[0];
      final documentId = parts[1];

      if (merge) {
        await databases.updateDocument(
          databaseId: databaseId,
          collectionId: collectionId,
          documentId: documentId,
          data: recordMap,
          permissions: permissions,
        );
      } else {
        await databases.createDocument(
          databaseId: databaseId,
          collectionId: collectionId,
          documentId: documentId,
          data: recordMap,
          permissions: permissions,
        );
      }
      return true;
    } on AppwriteException catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  @override
  Stream<Map<String, Map>?> watchCollection(
    String collectionPath, {
    List<DocumentQuery> filters = const [],
    int? limit,
    DocumentOrderBy? orderBy,
    List<String>? permissions,
  }) {
    // Appwrite doesn't support realtime streams directly
    // This is a simulated implementation with periodic polling

    final controller = StreamController<Map<String, Map>?>();

    // Initial data
    getCollection(
      collectionPath,
      filters: filters,
      limit: limit,
      orderBy: orderBy,
    ).then((data) => controller.add(data));

    // Periodic updates (every 10 seconds)
    final timer = Timer.periodic(const Duration(seconds: 10), (_) async {
      final data = await getCollection(
        collectionPath,
        filters: filters,
        limit: limit,
        orderBy: orderBy,
      );
      controller.add(data);
    });

    controller.onCancel = () => timer.cancel();

    return controller.stream;
  }

  @override
  Stream<Map?> watchRecordByDocumentPath(
    String path,
    List<String>? permissions,
  ) {
    final controller = StreamController<Map?>();

    getRecordByDocumentPath(
      path,
      permissions,
    ).then((data) => controller.add(data));

    final timer = Timer.periodic(const Duration(seconds: 10), (_) async {
      final data = await getRecordByDocumentPath(path, permissions);
      controller.add(data);
    });

    controller.onCancel = () => timer.cancel();

    return controller.stream;
  }
}
