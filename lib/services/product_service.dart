// import 'package:pharmacie_stock/utils/fake.dart';

// import '../models/product.dart';
// import 'firestore_service.dart';

// class ProductService {
//   final FirestoreService _firestore = FirestoreService();
//   final String _collection = 'products';

//   /// Add a new product
//   Future<void> addProduct(Product product) async {
//     await _firestore.setDocument(
//       '$_collection/${product.id}',
//       product.toJson(),
//     );
//   }

//   /// Update an existing product
//   Future<void> updateProduct(Product product) async {
//     await _firestore.updateDocument(
//       '$_collection/${product.id}',
//       product.toJson(),
//     );
//   }

//   /// Delete a product by ID
//   Future<void> deleteProduct(String productId) async {
//     await _firestore.deleteDocument('$_collection/$productId');
//   }

//   /// Get a stream of all products
//   Stream<List<Product>> getProductsStream() {
//     return Stream.value(initialProducts);
//     // _firestore
//     //     .getCollectionStream(_collection)
//     //     .map(
//     //       (snapshot) =>
//     //           snapshot.docs.map((doc) => Product.fromJson(doc.data())).toList(),
//     //     );
//   }

//   /// Get a product by ID
//   Future<Product?> getProductById(String productId) async {
//     final doc = await _firestore.getDocument('$_collection/$productId');
//     if (doc.exists) {
//       return Product.fromJson(doc.data()!);
//     }
//     return null;
//   }

//   /// Update product quantity (e.g., after a sale)
//   Future<void> updateProductQuantity(
//     String productId,
//     int quantityChange,
//   ) async {
//     final product = await getProductById(productId);
//     if (product != null) {
//       final newQuantity = product.stock + quantityChange;
//       await updateProduct(product.copyWith(stock: newQuantity));
//     }
//   }
// }
