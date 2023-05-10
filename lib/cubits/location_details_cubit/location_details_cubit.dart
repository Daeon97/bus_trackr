// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bus_trackr/errors/location_failure.dart';
import 'package:bus_trackr/repositories/location_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

part 'location_details_state.dart';

class LocationDetailsCubit extends Cubit<LocationDetailsState> {
  LocationDetailsCubit({
    required this.locationRepository,
  }) : super(
          const LocationDetailsInitialState(),
        );

  final LocationRepository locationRepository;

  StreamSubscription<Either<LocationFailure, Position>>? _streamSubscription;

  void startListeningLocationDetails() {
    _gettingLocationDetails();

    if (_streamSubscription != null) {
      _streamSubscription!.cancel();
    }

    _streamSubscription = locationRepository.location.listen(
      (
        locationFailureOrPosition,
      ) {
        locationFailureOrPosition.fold(
          _failedToGetLocationDetails,
          _gotLocationDetails,
        );
      },
    );
  }

  void _gettingLocationDetails() => emit(
        const GettingLocationDetailsState(),
      );

  void _failedToGetLocationDetails(LocationFailure locationFailure) => emit(
        FailedToGetLocationDetailsState(
          locationFailure.message,
        ),
      );

  void _gotLocationDetails(Position position) => emit(
        GotLocationDetailsState(
          position,
        ),
      );

  void stopListeningLocationDetails() {
    _streamSubscription?.cancel();
  }
}
