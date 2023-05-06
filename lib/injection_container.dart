// ignore_for_file: public_member_api_docs

import 'dart:io';

import 'package:bus_trackr/repositories/bus_tracker_repository.dart';
import 'package:bus_trackr/services/bus_tracker_service.dart';
import 'package:bus_trackr/services/mqtt_service.dart';
import 'package:bus_trackr/view_models/bus_tracker_view_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

final sl = GetIt.I;

void initDependencyInjection() {
  sl

    // View models
    ..registerLazySingleton<BusTrackerViewModel>(
      () => BusTrackerViewModel(
        busTrackerRepository: sl(),
      ),
    )

    // Repositories
    ..registerLazySingleton<BusTrackerRepository>(
      () => BusTrackerRepository(
        busTrackerService: sl(),
      ),
    )

    // Services
    ..registerLazySingleton<BusTrackerService>(
      () => BusTrackerService(
        mqttService: sl(),
      ),
    )
    ..registerLazySingleton<MqttService>(
      () => MqttService(
        securityContext: sl(),
        mqttServerClient: sl(),
      ),
    )

    // External
    ..registerLazySingleton<SecurityContext>(
      () => SecurityContext.defaultContext,
    )
    ..registerLazySingleton<MqttServerClient>(
      () => MqttServerClient(
        sl.get(
          instanceName: 'server',
        ),
        sl.get(
          instanceName: 'clientIdentifier',
        ),
      ),
    )

    // Primitives
    ..registerLazySingleton<String>(
      () => dotenv.env['IOT_CORE_SERVER_END_POINT']!,
      instanceName: 'server',
    )
    ..registerLazySingleton<String>(
      () => 'bus_trackr',
      instanceName: 'clientIdentifier',
    );
}
