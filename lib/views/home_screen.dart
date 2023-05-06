// ignore_for_file: public_member_api_docs

import 'package:bus_trackr/errors/failure.dart';
import 'package:bus_trackr/injection_container.dart';
import 'package:bus_trackr/models/bus_details.dart';
import 'package:bus_trackr/view_models/bus_tracker_view_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder<Either<Failure, BusDetails>>(
          stream: sl<BusTrackerViewModel>().stream,
          builder: (_, snapshot) {
            return Center(
              child: Text(
                '${snapshot.data ?? ' '}',
              ),
            );
          },
        ),
      );
}
