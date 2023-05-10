// ignore_for_file: public_member_api_docs

import 'package:bus_trackr/cubits/bus_details_cubit/bus_details_cubit.dart';
import 'package:bus_trackr/cubits/location_details_cubit/location_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MapboxMapController? mapboxMapController;

  @override
  void initState() {
    BlocProvider.of<LocationDetailsCubit>(context)
        .startListeningLocationDetails();
    BlocProvider.of<BusDetailsCubit>(context).startListeningBusDetails();
    super.initState();
  }

  @override
  void dispose() {
    mapboxMapController?.dispose();
    BlocProvider.of<LocationDetailsCubit>(context)
        .startListeningLocationDetails();
    BlocProvider.of<BusDetailsCubit>(context).stopListeningBusDetails();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BlocListener<LocationDetailsCubit, LocationDetailsState>(
        listener: (_, locationDetailsState) {
          if (locationDetailsState is GotLocationDetailsState) {
            mapboxMapController?.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: LatLng(
                    locationDetailsState.position.latitude,
                    locationDetailsState.position.longitude,
                  ),
                  zoom: 15,
                ),
              ),
            );
            mapboxMapController?.addCircle(
              CircleOptions(
                geometry: LatLng(
                  locationDetailsState.position.latitude,
                  locationDetailsState.position.longitude,
                ),
                draggable: false,
                circleColor: 'blue',
                circleRadius: 10,
              ),
            );
          }
        },
        child: Scaffold(
          body: BlocBuilder<LocationDetailsCubit, LocationDetailsState>(
            builder: (_, locationDetailsState) => Stack(
              children: [
                MapboxMap(
                  onMapCreated: (controller) {
                    mapboxMapController = controller;
                  },
                  styleString: MapboxStyles.SATELLITE,
                  accessToken: dotenv.env['MAPBOX_SECRET_TOKEN'],
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(
                      8.9397754,
                      7.31824,
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(
                      16,
                    ),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: const ButtonStyle(
                        shape: MaterialStatePropertyAll<OutlinedBorder>(
                          CircleBorder(),
                        ),
                        padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(
                          EdgeInsets.all(
                            16,
                          ),
                        ),
                        backgroundColor: MaterialStatePropertyAll<Color>(
                          Colors.red,
                        ),
                      ),
                      child: FaIcon(
                        FontAwesomeIcons.bell,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
