import 'package:bus_trackr/app.dart';
import 'package:bus_trackr/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  _initializeImportantResources().then(
    (_) => runApp(
      const App(),
    ),
  );
}

Future<void> _initializeImportantResources() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  initDependencyInjection();
}
