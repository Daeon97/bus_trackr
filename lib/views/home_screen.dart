// ignore_for_file: public_member_api_docs

import 'package:bus_trackr/cubits/bus_details_cubit/bus_details_cubit.dart';
import 'package:bus_trackr/cubits/location_details_cubit/location_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MapboxMapController? _mapboxMapController;
  late final ValueNotifier<bool?> _animateToUserLocation;

  @override
  void initState() {
    _animateToUserLocation = ValueNotifier<bool?>(
      null,
    );
    BlocProvider.of<LocationDetailsCubit>(context)
        .startListeningLocationDetails();
    BlocProvider.of<BusDetailsCubit>(context).startListeningBusDetails();
    super.initState();
  }

  @override
  void dispose() {
    _mapboxMapController?.dispose();
    _animateToUserLocation.dispose();
    BlocProvider.of<LocationDetailsCubit>(context)
        .startListeningLocationDetails();
    BlocProvider.of<BusDetailsCubit>(context).stopListeningBusDetails();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<bool?>(
        valueListenable: _animateToUserLocation,
        builder: (_, animateToUserLocationValue, __) =>
            BlocListener<LocationDetailsCubit, LocationDetailsState>(
          listener: (_, locationDetailsState) {
            if (locationDetailsState is GotLocationDetailsState) {
              _animateToUserLocation.value = true;

              if (animateToUserLocationValue != null &&
                  animateToUserLocationValue) {
                _mapboxMapController?.animateCamera(
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
              }
              _mapboxMapController?.addCircle(
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
          child: BlocListener<BusDetailsCubit, BusDetailsState>(
            listener: (_, busDetailsState) {
              if (busDetailsState is LoadedBusDetailsState) {
                if (animateToUserLocationValue != null &&
                    !animateToUserLocationValue) {
                  _mapboxMapController?.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: LatLng(
                          busDetailsState.busDetails.latitude.toDouble(),
                          busDetailsState.busDetails.longitude.toDouble(),
                        ),
                        zoom: 15,
                      ),
                    ),
                  );
                  _mapboxMapController?.addCircle(
                    CircleOptions(
                      geometry: LatLng(
                        busDetailsState.busDetails.latitude.toDouble(),
                        busDetailsState.busDetails.longitude.toDouble(),
                      ),
                      draggable: false,
                      circleColor: 'red',
                      circleRadius: 10,
                    ),
                  );
                }
              }
            },
            child: Scaffold(
              body: BlocBuilder<LocationDetailsCubit, LocationDetailsState>(
                builder: (_, locationDetailsState) => Stack(
                  children: [
                    MapboxMap(
                      onMapCreated: (controller) {
                        _mapboxMapController = controller;
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
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            BlocBuilder<BusDetailsCubit, BusDetailsState>(
                              builder: (_, busDetailsState) => ElevatedButton(
                                onPressed: busDetailsState
                                        is LoadedBusDetailsState
                                    ? () => _animateToUserLocation.value = false
                                    : null,
                                style: ButtonStyle(
                                  shape: const MaterialStatePropertyAll<
                                      OutlinedBorder>(
                                    CircleBorder(),
                                  ),
                                  padding: const MaterialStatePropertyAll<
                                      EdgeInsetsGeometry>(
                                    EdgeInsets.all(
                                      16,
                                    ),
                                  ),
                                  backgroundColor:
                                      MaterialStatePropertyAll<Color>(
                                    busDetailsState is LoadedBusDetailsState
                                        ? Colors.blue
                                        : Colors.grey,
                                  ),
                                ),
                                child: FaIcon(
                                  animateToUserLocationValue != null &&
                                          !animateToUserLocationValue
                                      ? FontAwesomeIcons.person
                                      : FontAwesomeIcons.bus,
                                  size: 32,
                                  color:
                                      busDetailsState is LoadedBusDetailsState
                                          ? Colors.white
                                          : Colors.white.withOpacity(
                                              0.5,
                                            ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 32,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                showTopSnackBar(
                                  Overlay.of(context),
                                  const CustomSnackBar.info(
                                    message:
                                        'An SOS notification has been sent to the appropriate authorities',
                                  ),
                                );
                              },
                              style: const ButtonStyle(
                                shape: MaterialStatePropertyAll<OutlinedBorder>(
                                  CircleBorder(),
                                ),
                                padding: MaterialStatePropertyAll<
                                    EdgeInsetsGeometry>(
                                  EdgeInsets.all(
                                    16,
                                  ),
                                ),
                                backgroundColor:
                                    MaterialStatePropertyAll<Color>(
                                  Colors.red,
                                ),
                              ),
                              child: const FaIcon(
                                FontAwesomeIcons.bell,
                                size: 32,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.topEnd,
                      child: BlocBuilder<BusDetailsCubit, BusDetailsState>(
                        builder: (_, busDetailsState) => Container(
                          padding: const EdgeInsets.all(
                            16,
                          ),
                          margin: const EdgeInsets.only(
                            top: 32,
                            left: 16,
                            right: 16,
                          ),
                          decoration: BoxDecoration(
                            color: busDetailsState is LoadedBusDetailsState
                                ? Colors.white
                                : Colors.white.withOpacity(
                                    0.5,
                                  ),
                            borderRadius: BorderRadius.circular(
                              16,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.bus,
                                size: 16,
                                color: busDetailsState is LoadedBusDetailsState
                                    ? Colors.blue
                                    : Colors.blue.withOpacity(
                                        0.5,
                                      ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              if (busDetailsState is LoadedBusDetailsState)
                                RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                    children: [
                                      const TextSpan(
                                        text: 'Price: ₦500',
                                      ),
                                      const TextSpan(
                                        text: '\n',
                                      ),
                                      TextSpan(
                                          text:
                                              'Plate Number: ${busDetailsState.busDetails.plateNumber}'),
                                      const TextSpan(
                                        text: '\n',
                                      ),
                                      TextSpan(
                                          text:
                                              'Card Access: ${busDetailsState.busDetails.cardAccess}'),
                                      const TextSpan(
                                        text: '\n',
                                      ),
                                      TextSpan(
                                          text:
                                              'Seats Occupied: ${busDetailsState.busDetails.occupiedSeat}'),
                                      const TextSpan(
                                        text: '\n',
                                      ),
                                      TextSpan(
                                          text:
                                              'Seats Available: ${busDetailsState.busDetails.availableSeat}'),
                                      const TextSpan(
                                        text: '\n',
                                      ),
                                      TextSpan(
                                          text:
                                              'Current Coordinates: ${busDetailsState.busDetails.latitude} lat, ${busDetailsState.busDetails.longitude} lng'),
                                    ],
                                  ),
                                )
                              else
                                Text(
                                  'No available bus at this time',
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(
                                      0.5,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
