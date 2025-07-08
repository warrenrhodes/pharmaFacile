import 'package:firebase_core/firebase_core.dart';

import 'firebase_options_dev.dart' as firebase_options_dev;

FirebaseOptions _getOptions() {
  return firebase_options_dev.DefaultFirebaseOptions.currentPlatform;
}

/// Initializes the Firebase config based on the environment.
Future<void> initializeFirebaseApp() async {
  await Firebase.initializeApp(options: _getOptions());
}
