import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  /// Initialize local notifications
  Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings settings =
        InitializationSettings(android: androidSettings);
    await _notifications.initialize(settings);
  }

  /// Show a low stock notification
  Future<void> showLowStockNotification(
      String productName, int quantity) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'low_stock_channel',
      'Low Stock Alerts',
      channelDescription: 'Notifies when product stock is low',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails details =
        NotificationDetails(android: androidDetails);
    await _notifications.show(
      0,
      'Stock faible',
      'Le produit "$productName" est presque épuisé (reste $quantity)',
      details,
    );
  }
}
