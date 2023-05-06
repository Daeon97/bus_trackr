// ignore_for_file: public_member_api_docs

import 'package:bus_trackr/errors/failure.dart';
import 'package:bus_trackr/models/bus_details.dart';
import 'package:bus_trackr/repositories/bus_tracker_repository.dart';
import 'package:dartz/dartz.dart';

class BusTrackerViewModel {
  BusTrackerViewModel({
    required this.busTrackerRepository,
  });

  final BusTrackerRepository busTrackerRepository;

  Stream<Either<Failure, BusDetails>> get stream =>
      busTrackerRepository.trackerStream;
}
