import 'package:pharmacie_stock/models/sale_model.dart';

import '../models/product_model.dart';

final List<Product> initialProducts = [
  Product.fromJson({
    'id': '1',
    'name': 'Paracétamol 500mg',
    'sellingPrice': 500,
    'purchasePrice': 300,
    'stock': 25,
    'minStock': 10,
    'category': 'Antidouleur',
    'description': 'Comprimés pour douleurs et fièvre',
    'updatedAt': '2025-01-01',
    'createdAt': '2025-01-01',
  }),
  Product.fromJson({
    'id': '2',
    'name': 'Vitamine C 1000mg',
    'sellingPrice': 800,
    'purchasePrice': 500,
    'stock': 5,
    'minStock': 15,
    'category': 'Vitamines',
    'description': 'Comprimés effervescents',
    'createdAt': '2025-01-01',
    'updatedAt': '2025-01-01',
  }),
  Product.fromJson({
    'id': '3',
    'name': 'Antigrippal',
    'sellingPrice': 1200,
    'purchasePrice': 800,
    'stock': 3,
    'minStock': 8,
    'category': 'Rhume & Grippe',
    'description': 'Traitement symptomatique du rhume',
    'createdAt': '2025-01-01',
    'updatedAt': '2025-01-01',
  }),
  Product.fromJson({
    'id': '4',
    'name': 'Sirop contre la toux',
    'sellingPrice': 1500,
    'purchasePrice': 1000,
    'stock': 12,
    'minStock': 5,
    'category': 'Rhume & Grippe',
    'description': 'Sirop expectorant 125ml',
    'createdAt': '2025-01-01',
    'updatedAt': '2025-01-01',
  }),
  Product.fromJson({
    'id': '5',
    'name': 'Aspirine 500mg',
    'sellingPrice': 400,
    'purchasePrice': 250,
    'stock': 18,
    'minStock': 10,
    'category': 'Antidouleur',
    'description': 'Comprimés anti-inflammatoires',
    'createdAt': '2025-01-01',
    'updatedAt': '2025-01-01',
  }),
];

final List<Sale> initialSales = [
  Sale.fromJson({
    'id': '1',
    'salesItems': [
      {
        'productId': '1',
        'productName': 'Paracétamol 500mg',
        'quantity': 2,
        'unitPrice': 500,
        'total': 1000,
      },
    ],
    'totalPriceInUTC': 1000,
    'createdAt': '2025-01-07T10:30:00',
    'cashier': 'Pharmacien Principal',
    'updatedBy': '1',
  }),
];
