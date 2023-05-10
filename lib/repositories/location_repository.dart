// ignore_for_file: public_member_api_docs, lines_longer_than_80_chars

import 'dart:async';

import 'package:bus_trackr/errors/location_failure.dart';
import 'package:bus_trackr/services/location_service.dart';
import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';

class LocationRepository {
  const LocationRepository({
    required this.locationService,
  });

  final LocationService locationService;

  Stream<Either<LocationFailure, Position>> get location {
    late StreamController<Either<LocationFailure, Position>> streamController;
    StreamSubscription<Position>? streamSubscription;

    streamController = StreamController<Either<LocationFailure, Position>>(
      onListen: () async {
        // final lastPosition = await locationService.lastKnownPosition;
        //
        // if (lastPosition != null) {
        //   streamController.sink.add(
        //     Right(
        //       lastPosition,
        //     ),
        //   );
        // }

        final locationServiceEnabled =
            await locationService.locationServiceEnabled;

        if (!locationServiceEnabled) {
          streamController.sink.add(
            const Left(
              LocationServiceDisabledFailure(
                message: 'Turn on location service to proceed',
              ),
            ),
          );
        } else {
          final locationPermission = await locationService.locationPermission;

          switch (locationPermission) {
            case LocationPermission.denied:
              streamController.sink.add(
                const Left(
                  LocationPermissionDeniedFailure(
                    message: 'Grant location permission to proceed',
                  ),
                ),
              );
              break;
            case LocationPermission.deniedForever:
              streamController.sink.add(
                const Left(
                  LocationPermissionDeniedForeverFailure(
                    message:
                        'Enable location permission in settings to proceed',
                  ),
                ),
              );
              break;
            case LocationPermission.whileInUse:
            case LocationPermission.always:
              streamSubscription = _computeCurrentLocation(
                streamController.sink,
              );
              break;
            case LocationPermission.unableToDetermine:
              streamController.sink.add(
                const Left(
                  LocationPermissionUnableToDetermineFailure(
                    message:
                        'Could not determine location permission status. You will not be able to use this app',
                  ),
                ),
              );
              break;
          }
        }
      },
      onCancel: () async {
        await streamSubscription?.cancel();
        await streamController.sink.close();
        await streamController.close();
      },
    );

    return streamController.stream;
  }

  StreamSubscription<Position> _computeCurrentLocation(
    StreamSink<Either<LocationFailure, Position>> streamSink,
  ) =>
      locationService.currentPosition.listen(
        (position) {
          streamSink.add(
            Right(
              position,
            ),
          );
        },
      );
}
