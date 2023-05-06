// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:bus_trackr/errors/custom_exception.dart';
import 'package:bus_trackr/errors/failure.dart';
import 'package:bus_trackr/models/bus_details.dart';
import 'package:bus_trackr/models/certificate.dart';
import 'package:bus_trackr/services/bus_tracker_service.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BusTrackerRepository {
  const BusTrackerRepository({
    required this.busTrackerService,
  });

  final BusTrackerService busTrackerService;

  Stream<Either<Failure, BusDetails>> get trackerStream {
    final topic = dotenv.env['TOPIC']!;
    const port = 8883;
    const keepAlivePeriod = 20;
    const clientId = 'bus_trackr';

    const certificatesPath = 'assets/certificates';

    const deviceCertificateAssetPath =
        '$certificatesPath/device_certificate.pem.crt';
    const privateKeyAssetPath = '$certificatesPath/private_key.pem.key';
    const rootCertificateAuthorityAssetPath =
        '$certificatesPath/root_certificate_authority.pem';

    const certificate = Certificate(
      rootCertificateAuthorityAssetPath: rootCertificateAuthorityAssetPath,
      privateKeyAssetPath: privateKeyAssetPath,
      deviceCertificateAssetPath: deviceCertificateAssetPath,
    );

    late StreamController<Either<Failure, BusDetails>> streamController;
    late StreamSubscription<BusDetails> streamSubscription;

    streamController = StreamController<Either<Failure, BusDetails>>(
      onListen: () {
        streamSubscription = busTrackerService
            .messageStream(
          topic: topic,
          port: port,
          keepAlivePeriod: keepAlivePeriod,
          clientId: clientId,
          certificate: certificate,
        )
            .listen(
          (busDetails) {
            streamController.sink.add(
              Right(
                busDetails,
              ),
            );
          },
          onError: (dynamic error) {
            streamController.sink.add(
              Left(
                _computeFailure(error),
              ),
            );
          },
        );
      },
      onCancel: () async {
        await streamSubscription.cancel();
        await streamController.sink.close();
        await streamController.close();
      },
    );
    return streamController.stream;
  }

  Failure _computeFailure(dynamic error) {
    late Failure failure;

    switch (error.runtimeType) {
      case NoMessagesFromBrokerException:
        failure = NoMessagesFromBrokerFailure(
          message: (error as NoMessagesFromBrokerException).message,
        );
        break;
      case TopicSubscriptionException:
        failure = TopicSubscriptionFailure(
          message: (error as TopicSubscriptionException).message,
        );
        break;
      case UnsolicitedDisconnectionException:
        failure = UnsolicitedDisconnectionFailure(
          message: (error as UnsolicitedDisconnectionException).message,
        );
        break;
      case CouldNotConnectToBrokerException:
        failure = CouldNotConnectToBrokerFailure(
          message: (error as CouldNotConnectToBrokerException).message,
        );
        break;
      case MessageTopicMismatchException:
        failure = MessageTopicMismatchFailure(
          message: (error as MessageTopicMismatchException).message,
        );
        break;
      case BadMessageFormatException:
        failure = BadMessageFormatFailure(
          message: (error as BadMessageFormatException).message,
        );
        break;
      default:
        failure = const UnknownFailure(
          message: 'An unknown error occurred',
        );
        break;
    }

    return failure;
  }
}
