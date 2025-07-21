import '../database/database.dart';
import '../database/document_filter.dart';
import '../models/product.dart';

class ProductRepository {
  final Database _database;

  ProductRepository(this._database);

  static const String _collectionPath = 'pharmacy_db/products';

  Future<Product?> getProduct(String productId) async {
    final record = await _database.getRecordByDocumentPath(
      '$_collectionPath/$productId',
      [],
    );
    if (record != null) {
      return Product.fromJson(record.cast<String, dynamic>());
    }
    return null;
  }

  Future<List<Product>> getProducts({List<DocumentQuery>? filters}) async {
    final collection = await _database.getCollection(
      _collectionPath,
      filters: filters ?? [],
    );

    return collection?.values
            .map((json) => Product.fromJson(json.cast<String, dynamic>()))
            .toList() ??
        [];
  }

  Future<String> createProduct(Product product) async {
    final productJson = product.toJson();
    productJson.remove('id');

    final productId = await _database.createRecord(
      _collectionPath,
      productJson,
      [],
    );

    return productId ?? product.id;
  }

  Future<bool> updateProduct(Product product) async {
    final productJson = product.toJson();
    // Remove fields that shouldn't be updated
    productJson.remove('createdAtInUtc');

    return await _database.setRecord(
      documentPath: '$_collectionPath/${product.id}',
      recordMap: productJson,
      merge: true,
    );
  }

  Future<bool> deleteProduct(String productId) async {
    await _database.removeRecordsByPath(_collectionPath, [productId], []);
    return true;
  }

  Future<Product?> getProductByBarcode(String barcode) async {
    final products = await getProducts(
      filters: [
        DocumentQuery('barcode', barcode, DocumentFieldCondition.isEqualTo),
      ],
    );
    return products.isNotEmpty ? products.first : null;
  }

  Future<List<Product>> getExpiringSoon({
    required DateTime thresholdDate,
  }) async {
    return getProducts(
      filters: [
        DocumentQuery(
          'expiryDate',
          thresholdDate.toIso8601String(),
          DocumentFieldCondition.isLessThanOrEqualTo,
        ),
      ],
    );
  }

  Future<List<Product>> getLowStockProducts() async {
    return getProducts(
      filters: [
        DocumentQuery(
          'quantity',
          'reorderThreshold',
          DocumentFieldCondition.isLessThanOrEqualTo,
        ),
      ],
    );
  }

  Stream<Product?> watchProduct(String productId) {
    return _database
        .watchRecordByDocumentPath('$_collectionPath/$productId', [])
        .map(
          (record) => record != null
              ? Product.fromJson(record.cast<String, dynamic>())
              : null,
        );
  }

  Stream<List<Product>> watchProducts({List<DocumentQuery>? filters}) {
    return _database
        .watchCollection(_collectionPath, filters: filters ?? [])
        .map(
          (collection) =>
              collection?.values
                  .map((json) => Product.fromJson(json.cast<String, dynamic>()))
                  .toList() ??
              [],
        );
  }

  // Pharmacy-specific product methods
  Future<List<Product>> getProductsByCategory(String categoryId) async {
    return getProducts(
      filters: [
        DocumentQuery(
          'categoryId',
          categoryId,
          DocumentFieldCondition.isEqualTo,
        ),
      ],
    );
  }

  Future<List<Product>> getProductsBySupplier(String supplierId) async {
    return getProducts(
      filters: [
        DocumentQuery(
          'supplierId',
          supplierId,
          DocumentFieldCondition.isEqualTo,
        ),
      ],
    );
  }

  Future<bool> updateStock(String productId, int quantityChange) async {
    final product = await getProduct(productId);
    if (product == null) return false;

    final newQuantity = product.quantity + quantityChange;
    if (newQuantity < 0) return false; // Prevent negative stock

    return updateProduct(
      product.copyWith(
        quantity: newQuantity,
        updatedAtInUtc: DateTime.now().toUtc(),
      ),
    );
  }
}
