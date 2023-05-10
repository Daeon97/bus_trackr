// ignore_for_file: public_member_api_docs

import 'package:bus_trackr/cubits/bus_details_cubit/bus_details_cubit.dart';
import 'package:bus_trackr/cubits/location_details_cubit/location_details_cubit.dart';
import 'package:bus_trackr/injection_container.dart';
import 'package:bus_trackr/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: _providers,
        child: MaterialApp(
          onGenerateRoute: _routes,
        ),
      );

  List<BlocProvider> get _providers => [
        BlocProvider<BusDetailsCubit>(
          create: (_) => sl<BusDetailsCubit>(),
        ),
        BlocProvider<LocationDetailsCubit>(
          create: (_) => sl<LocationDetailsCubit>(),
        ),
      ];

  Route<String> _routes(RouteSettings settings) => MaterialPageRoute(
        builder: (_) {
          switch (settings.name) {
            case '/':
            default:
              return const HomeScreen();
          }
        },
      );
}
