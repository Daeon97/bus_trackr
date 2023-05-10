// ignore_for_file: public_member_api_docs

part of 'bus_details_cubit.dart';

abstract class BusDetailsState extends Equatable {
  const BusDetailsState();

  @override
  List<Object> get props => [];
}

class BusDetailsInitialState extends BusDetailsState {
  const BusDetailsInitialState();

  @override
  List<Object> get props => [];
}

class LoadingBusDetailsState extends BusDetailsState {
  const LoadingBusDetailsState();

  @override
  List<Object> get props => [];
}

class LoadedBusDetailsState extends BusDetailsState {
  const LoadedBusDetailsState(
    this.busDetails,
  );

  final BusDetails busDetails;

  @override
  List<Object> get props => [
        busDetails,
      ];
}

class FailedToLoadBusDetailsState extends BusDetailsState {
  const FailedToLoadBusDetailsState(
    this.errorMessage,
  );

  final String errorMessage;

  @override
  List<Object> get props => [
        errorMessage,
      ];
}
