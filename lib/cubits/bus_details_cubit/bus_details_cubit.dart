// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bus_trackr/errors/broker_failure.dart';
import 'package:bus_trackr/models/bus_details.dart';
import 'package:bus_trackr/repositories/bus_tracker_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

part 'bus_details_state.dart';

class BusDetailsCubit extends Cubit<BusDetailsState> {
  BusDetailsCubit({
    required this.busTrackerRepository,
  }) : super(
          const BusDetailsInitialState(),
        );

  final BusTrackerRepository busTrackerRepository;

  StreamSubscription<Either<BrokerFailure, BusDetails>>?
      _streamSubscription;

  void startListeningBusDetails() {
    _loadingBusDetails();

    if (_streamSubscription != null) {
      _streamSubscription!.cancel();
    }

    _streamSubscription = busTrackerRepository.trackerStream.listen(
      (
        brokerFailureOrBusDetails,
      ) {
        brokerFailureOrBusDetails.fold(
          _failedToLoadBusDetails,
          _loadedBusDetails,
        );
      },
    );
  }

  void _loadingBusDetails() => emit(
        const LoadingBusDetailsState(),
      );

  void _failedToLoadBusDetails(BrokerFailure brokerFailure) => emit(
        FailedToLoadBusDetailsState(
          brokerFailure.message,
        ),
      );

  void _loadedBusDetails(BusDetails busDetails) => emit(
        LoadedBusDetailsState(
          busDetails,
        ),
      );

  void stopListeningBusDetails() {
    _streamSubscription?.cancel();
  }
}
