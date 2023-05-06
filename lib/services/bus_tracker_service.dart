// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:convert';

import 'package:bus_trackr/errors/custom_exception.dart';
import 'package:bus_trackr/models/bus_details.dart';
import 'package:bus_trackr/models/certificate.dart';
import 'package:bus_trackr/services/mqtt_service.dart';
import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';

class BusTrackerService {
  const BusTrackerService({
    required this.mqttService,
  });

  final MqttService mqttService;

  Stream<BusDetails> messageStream({
    required String topic,
    required int port,
    required int keepAlivePeriod,
    required String clientId,
    required Certificate certificate,
  }) {
    late StreamController<BusDetails> streamController;
    StreamSubscription<List<MqttReceivedMessage<MqttMessage>>>?
        mqttReceivedMessagesStreamSubscription;

    streamController = StreamController<BusDetails>(
      onListen: () async {
        await mqttService.establishSecurityContext(
          rootCertificateAuthorityAssetPath:
              certificate.rootCertificateAuthorityAssetPath,
          privateKeyAssetPath: certificate.privateKeyAssetPath,
          deviceCertificateAssetPath: certificate.deviceCertificateAssetPath,
        );
        mqttService.ensureAllOtherImportantStuffInitialized(
          enableLogging: kDebugMode,
          port: port,
          keepAlivePeriod: keepAlivePeriod,
          clientId: clientId,
          onConnectedToBroker: () => _onConnectedToBroker(
            topic,
          ),
          onSubscribedToTopic: (_) {
            mqttReceivedMessagesStreamSubscription = _onSubscribedToTopic(
              topic,
              streamController.sink,
            );
          },
          onSubscriptionToTopicFailed: (_) => _onSubscriptionToTopicFailed(
            streamController.sink,
          ),
          onDisconnectedFromBroker: () => _onDisconnectedFromBroker(
            streamController.sink,
          ),
        );

        try {
          final connectionStatus = await mqttService.connectToBroker();

          if (connectionStatus?.state != MqttConnectionState.connecting &&
              connectionStatus?.state != MqttConnectionState.connected) {
            streamController.sink.addError(
              const CouldNotConnectToBrokerException(
                message: 'Connection to broker failed',
              ),
            );
          }
        } catch (_) {
          streamController.sink.addError(
            const CouldNotConnectToBrokerException(
              message: 'Unable to connect to broker',
            ),
          );
        }
      },
      onCancel: () async {
        await mqttReceivedMessagesStreamSubscription?.cancel();
        await streamController.sink.close();
        await streamController.close();
        mqttService.disconnectFromBroker();
      },
    );
    return streamController.stream;
  }

  void _onConnectedToBroker(
    String topic,
  ) {
    mqttService.subscribeToTopic(
      topic: topic,
      qualityOfService: MqttQos.atMostOnce,
    );
  }

  StreamSubscription<List<MqttReceivedMessage<MqttMessage>>>?
      _onSubscribedToTopic(
    String topic,
    StreamSink<BusDetails> streamSink,
  ) {
    StreamSubscription<List<MqttReceivedMessage<MqttMessage>>>?
        mqttReceivedMessagesStreamSubscription;
    final messagesFromBroker = mqttService.messagesFromBroker;

    if (messagesFromBroker != null) {
      mqttReceivedMessagesStreamSubscription = messagesFromBroker.listen(
        (mqttReceivedMessages) {
          for (final mqttReceivedMessage in mqttReceivedMessages) {
            if (mqttReceivedMessage.topic == topic) {
              try {
                final publishedMessage =
                    mqttReceivedMessage.payload as MqttPublishMessage;
                final uint8Buffer = publishedMessage.payload.message;
                final uint8List = Uint8List.view(
                  uint8Buffer.buffer,
                );
                final utf8Decoded = utf8.decode(
                  uint8List,
                );
                final json = jsonDecode(utf8Decoded) as Map<String, dynamic>;
                streamSink.add(
                  BusDetails.fromJson(
                    json,
                  ),
                );
              } catch (_) {
                streamSink.addError(
                  const BadMessageFormatException(
                    message: 'Received message was badly formatted',
                  ),
                );
              }
            } else {
              streamSink.addError(
                const MessageTopicMismatchException(
                  message:
                      'Received message topic does not correspond to current topic',
                ),
              );
            }
          }
        },
      );
    } else {
      streamSink.addError(
        const NoMessagesFromBrokerException(
          message: 'No data',
        ),
      );
    }

    return mqttReceivedMessagesStreamSubscription;
  }

  void _onSubscriptionToTopicFailed(
    StreamSink<BusDetails> streamSink,
  ) {
    streamSink.addError(
      const TopicSubscriptionException(
        message: 'There was an issue subscribing to the appropriate topic',
      ),
    );
  }

  void _onDisconnectedFromBroker(
    StreamSink<BusDetails> streamSink,
  ) {
    streamSink.addError(
      const UnsolicitedDisconnectionException(
        message: 'Client unexpectedly disconnected',
      ),
    );
  }
}
