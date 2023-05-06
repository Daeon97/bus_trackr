// ignore_for_file: public_member_api_docs

import 'package:bus_trackr/views/home_screen.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        onGenerateRoute: _routes,
      );

  Route<String> _routes(RouteSettings settings) => MaterialPageRoute(
        builder: (_) {
          switch (settings.name) {
            case '/':
            default:
              return HomeScreen();
          }
        },
      );
}
