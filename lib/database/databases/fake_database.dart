import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../database.dart';
import '../document_filter.dart';
import '../document_orders.dart';

/// The purpose of this implementation is to fake the database, and should only
/// be used for testing purposes.
class DatabaseFakeImplementation implements Database {
  final _log = Logger('DatabaseFakeImplementation');
  final Map<dynamic, Map<dynamic, dynamic>> _testDb;

  /// Constructs of [DatabaseFakeImplementation].
  DatabaseFakeImplementation(Map<dynamic, Map<dynamic, dynamic>> database)
    : _testDb = database;
  final Map<String, String> _testStorage = {
    'imageRef1': 'assetsdefaultProfile1.png',
    'imageRef2': 'assetsdefaultProfile2.png',
  };

  final String _placeholderImagePath = 'assets/image/place_holder.png';
  StreamController<String>? _updateListener;

  @override
  Future<ImageProvider> getImage(
    String imageRef,
    List<String>? permissions,
  ) async {
    return Image.asset(_testStorage[imageRef] ?? _placeholderImagePath).image;
  }

  @override
  Future<String?> createRecord(
    String collectionPath,
    Map<String, dynamic> recordMap,
    List<String>? permissions,
  ) async {
    final collection = collectionPath
        .split('/')
        .fold<Map?>(
          _testDb,
          (previousValue, element) =>
              previousValue is Map ? previousValue[element] : null,
        );

    final recordId = (collection?.length ?? 0) + 1;
    final documentId = 'id_$recordId';
    unawaited(
      Future.value(collection?.putIfAbsent(documentId, () => recordMap)),
    );
    _updateListener?.add(collectionPath);

    return documentId;
  }

  @override
  Future<void> removeRecordsByPath(
    String collectionPath,
    List<String> documentsIds,
    List<String>? permissions,
  ) async {
    final collection = collectionPath
        .split('/')
        .fold<Map?>(
          _testDb,
          (previousValue, element) =>
              previousValue is Map ? previousValue[element] : null,
        );
    if (collection == null) {
      _log.warning(
        '>> Method removeRecordsById << '
        'Your collection <$collectionPath> is empty or do not exist',
      );

      return;
    }
    for (final documentId in documentsIds) {
      unawaited(Future.value(collection.remove(documentId)));
    }
    _updateListener?.add(collectionPath);
  }

  @override
  Future<void> removeRecordByValue(
    String collectionPath,
    List<DocumentQuery> docQueries,
    List<String>? permissions,
  ) async {
    final Set<String> keysToRemove = {};
    int counter = 0;
    final collection = collectionPath
        .split('/')
        .fold<Map?>(
          _testDb,
          (previousValue, element) =>
              previousValue is Map ? previousValue[element] : null,
        );
    if (collection == null) {
      _log.warning(
        '>> Method removeRecordByValue << '
        'Your collection <$collectionPath> is empty or do not exist',
      );

      return;
    }
    collection.forEach((key, map) {
      map as Map;
      counter = _applyDocumentQueries(docQueries, map, counter);
      // If counter count matches the length of docQueries then
      // there is a match.
      if (counter == docQueries.length) {
        unawaited(Future.value(keysToRemove.add(key)));
      }

      // Reset counter for next key match.
      counter = 0;
    });

    for (var keys in keysToRemove) {
      unawaited(Future.value(collection.remove(keys)));
    }
    _updateListener?.add(collectionPath);
  }

  int _applyDocumentQueries(
    List<DocumentQuery> docQueries,
    Map<dynamic, dynamic> map,
    int counter,
  ) {
    for (var docQuery in docQueries) {
      final dynamic valueData = _getNestedValue(map, docQuery.key);
      if (valueData == null) {
        continue;
      }
      switch (docQuery.condition) {
        case DocumentFieldCondition.isEqualTo:
          if (valueData == docQuery.value) {
            counter++;
          }
          break;
        case DocumentFieldCondition.isGreaterThan:
          {
            if (valueData.compareTo(docQuery.value) > 0) {
              counter++;
            }
          }
          break;
        case DocumentFieldCondition.isGreaterThanOrEqualTo:
          {
            if (valueData.compareTo(docQuery.value) >= 0) {
              counter++;
            }
          }
          break;
        case DocumentFieldCondition.isLessThan:
          {
            if (valueData.compareTo(docQuery.value) < 0) {
              counter++;
            }
          }
          break;
        case DocumentFieldCondition.isLessThanOrEqualTo:
          {
            if (valueData.compareTo(docQuery.value) <= 0) {
              counter++;
            }
          }
          break;
        case DocumentFieldCondition.isNotEqualTo:
          {
            if (valueData != docQuery.value) {
              counter++;
            }
          }
          break;
        case DocumentFieldCondition.whereIn:
          {
            if ((docQuery.value as List<dynamic>).contains(valueData)) {
              counter++;
            }
          }
          break;
        case DocumentFieldCondition.arrayContains:
          {
            if (valueData.contains(docQuery.value)) {
              counter++;
            }
          }
          break;
      }
    }

    return counter;
  }

  @override
  Stream<Map<String, Map>?> watchCollection(
    String collectionPath, {
    List<DocumentQuery> filters = const [],
    DocumentOrderBy? orderBy,
    int? limit,
    List<String>? permissions,
  }) async* {
    yield await getCollection(
      collectionPath,
      filters: filters,
      orderBy: orderBy,
      limit: limit,
    );
    _updateListener ??= StreamController<String>.broadcast(
      onCancel: () {
        final updateListener = _updateListener;
        if (updateListener != null) {
          unawaited(updateListener.close());
          _updateListener = null;
        }
      },
    );
    final updateListener = _updateListener;
    if (updateListener != null) {
      await for (final String path in updateListener.stream) {
        if (path == collectionPath) {
          yield await getCollection(
            collectionPath,
            orderBy: orderBy,
            limit: limit,
          );
        }
      }
    } else {
      yield null;
    }
  }

  @override
  Future<Map<String, Map<dynamic, dynamic>>?> getCollection(
    String collectionPath, {
    List<DocumentQuery> filters = const [],
    DocumentOrderBy? orderBy,
    int? limit,
    List<String>? permissions,
  }) async {
    final Map<dynamic, dynamic>? originalCol = collectionPath
        .split('/')
        .fold<Map?>(
          _testDb,
          (previousValue, element) =>
              previousValue is Map ? previousValue[element] : null,
        );

    // Create a deep clone of the retrieved data.
    final Map<dynamic, dynamic>? col = originalCol == null
        ? null
        : jsonDecode(jsonEncode(originalCol));

    if (col == null) return null;

    // Filter documents
    final Map<String, Map<dynamic, dynamic>> filteredDocs = {};
    col.forEach((k, val) {
      final Map map = val;
      for (var docQuery in filters) {
        final DocumentFieldCondition condition = docQuery.condition;
        final dynamic valueData = _getNestedValue(map, docQuery.key);
        if (valueData == null) {
          return;
        }
        if ((condition == DocumentFieldCondition.isEqualTo &&
                valueData != docQuery.value) ||
            (condition == DocumentFieldCondition.isGreaterThan &&
                valueData.compareTo(docQuery.value) <= 0) ||
            (condition == DocumentFieldCondition.isGreaterThanOrEqualTo &&
                valueData.compareTo(docQuery.value) < 0) ||
            (condition == DocumentFieldCondition.isLessThan &&
                valueData.compareTo(docQuery.value) >= 0) ||
            (condition == DocumentFieldCondition.isLessThanOrEqualTo &&
                valueData.compareTo(docQuery.value) > 0) ||
            (condition == DocumentFieldCondition.isNotEqualTo &&
                valueData == docQuery.value) ||
            (condition == DocumentFieldCondition.whereIn &&
                !(docQuery.value as List<dynamic>).contains(valueData)) ||
            (condition == DocumentFieldCondition.arrayContains &&
                !(valueData).contains(docQuery.value))) {
          return;
        }
      }
      filteredDocs[k] = val;
    });

    // Sort keys according to orderBy if provided
    List<String> sortedKeys = filteredDocs.keys.toList();
    if (orderBy != null) {
      final orderFlip = orderBy.descending ? -1 : 1;
      sortedKeys.sort((k1, k2) {
        final fieldValue1 = filteredDocs[k1]?[orderBy.field];
        final fieldValue2 = filteredDocs[k2]?[orderBy.field];
        if (fieldValue1 == fieldValue2) {
          return 0;
        }
        if (fieldValue1 == null) {
          return -1 * orderFlip;
        }
        if (fieldValue2 == null) {
          return 1 * orderFlip;
        }
        return fieldValue1.compareTo(fieldValue2) * orderFlip;
      });

      final startAt = orderBy.startAtDocumentPath;
      final startAfter = orderBy.startAfterDocumentPath;

      int startIndex = 0;
      if (startAt != null) {
        startIndex = sortedKeys.indexOf(startAt);
        if (startIndex == -1) startIndex = 0;
      } else if (startAfter != null) {
        startIndex = sortedKeys.indexOf(startAfter) + 1;
        if (startIndex == 0) startIndex = 0;
      }

      if (startIndex > 0) {
        sortedKeys = sortedKeys.sublist(startIndex);
      }
    }

    if (limit != null && limit > 0 && sortedKeys.length > limit) {
      sortedKeys = sortedKeys.sublist(0, limit);
    }

    final result = SplayTreeMap<String, Map<dynamic, dynamic>>((a, b) {
      return sortedKeys.indexOf(a).compareTo(sortedKeys.indexOf(b));
    });
    for (final k in sortedKeys) {
      result[k] = filteredDocs[k]!;
    }

    return result;
  }

  @override
  Future<Map<dynamic, dynamic>?> getRecordByDocumentPath(
    String path,
    List<String>? permissions,
  ) async {
    final pathSegments = path.split('/')
      ..removeWhere((element) => element.isEmpty);
    const minimumValidPathSegmentLength = 2;
    if (pathSegments.length < minimumValidPathSegmentLength ||
        pathSegments.length % minimumValidPathSegmentLength != 0) {
      _log.warning(' Invalid path `$path`');

      return null;
    }
    final Map<dynamic, dynamic>? document = pathSegments.fold<Map?>(
      _testDb,
      (previousValue, element) =>
          previousValue is Map ? previousValue[element] : null,
    );

    // Create a deep clone of the retrieved data.
    return jsonDecode(jsonEncode(document)) as Map<dynamic, dynamic>?;
  }

  @override
  Future<bool> setRecord({
    required String documentPath,
    required Map<String, dynamic> recordMap,
    bool merge = true,
    List<String>? permissions,
  }) async {
    final pathSegments = documentPath.split('/')
      ..removeWhere((element) => element.isEmpty);
    const minimumValidPathSegmentLength = 2;
    if (pathSegments.length < minimumValidPathSegmentLength ||
        pathSegments.length % minimumValidPathSegmentLength != 0) {
      _log.severe(
        'Invalid path to record `$documentPath`',
        null,
        StackTrace.current,
      );

      return false;
    }
    final Map<dynamic, dynamic> documentRef = pathSegments.fold<Map>(_testDb, (
      previousValue,
      element,
    ) {
      return previousValue[element] ??= {};
    });
    documentRef.addAll(_deepmerge(target: documentRef, source: recordMap));
    _updateListener?.add(documentPath);
    unawaited(Future.sync(pathSegments.removeLast));
    _updateListener?.add(pathSegments.join('/'));

    return true;
  }

  @override
  Future<bool> setFile(
    Uint8List fileData,
    String recordPath,
    List<String>? permissions,
  ) async {
    _testStorage[recordPath] = XFile.fromData(fileData).path;

    return true;
  }

  @override
  Future<bool> deleteFile(String recordPath, List<String>? permissions) async {
    _testStorage.remove(recordPath);

    return true;
  }

  dynamic _deepmerge({required dynamic target, required dynamic source}) {
    if (target is Map && source is Map) {
      final result = <String, dynamic>{...source};
      for (final key in target.keys) {
        result[key] = _deepmerge(target: target[key], source: result[key]);
      }
      return result;
    } else {
      return source ?? target;
    }
  }

  dynamic _getNestedValue(dynamic obj, String path) {
    final keys = path.split('.');
    dynamic current = obj;

    for (int i = 0; i < keys.length; i++) {
      final key = keys[i];
      final isLastKey = (i == keys.length - 1);

      if (current == null) {
        return null;
      }

      if (current is Map && current.containsKey(key)) {
        current = current[key];
      } else if (isLastKey && current is List) {
        return current;
      } else {
        return null;
      }
    }
    return current;
  }

  @override
  Stream<Map<dynamic, dynamic>?> watchRecordByDocumentPath(
    String path,
    List<String>? permissions,
  ) async* {
    yield await getRecordByDocumentPath(path, permissions);
    _updateListener ??= StreamController<String>.broadcast(
      onCancel: () {
        final updateListener = _updateListener;
        if (updateListener != null) {
          unawaited(updateListener.close());
          _updateListener = null;
        }
      },
    );
    final updateListener = _updateListener;
    if (updateListener != null) {
      yield await getRecordByDocumentPath(path, permissions);
    } else {
      yield null;
    }
  }
}
