import 'dart:async';
import 'dart:convert';
import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:ride_driver_app/providers/selected_ride_provider.dart';
import 'package:ride_driver_app/screens/ride_detail_screen.dart';
import 'package:ride_driver_app/utils/apiIp.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import '../models/ride.dart';
import '../providers/ride_provider.dart';

class SocketService {
  StompClient? _stompClient;
  bool isConnected = false;
  BuildContext? _context;
  Timer? _timer;
  bool _shouldReconnect = false;

  void initialize(BuildContext context) {
    _context = context;
    _configureBackgroundFetch();
  }

  Future<void> _configureBackgroundFetch() async {
    await BackgroundFetch.configure(
      BackgroundFetchConfig(
        minimumFetchInterval: 1,
        stopOnTerminate: false,
        enableHeadless: true,
        requiredNetworkType: NetworkType.ANY,
      ),
      _onBackgroundFetch,
    );
    BackgroundFetch.registerHeadlessTask(_backgroundFetchHeadlessTask);
  }

  void connectSocket() {
    if (!isConnected) {
      _stompClient = StompClient(
        config: StompConfig(
          url: 'ws://${ApiIp.apiIp}/ws',
          onConnect: _onStompConnected,
          onWebSocketError: (err) {
            debugPrint("STOMP error: $err");
            _handleDisconnect();
          },
          onDisconnect: (_) {
            debugPrint("STOMP disconnected");
            _handleDisconnect();
          },
          onStompError: (frame) {
            debugPrint("STOMP error: ${frame.body}");
            _handleDisconnect();
          },
          beforeConnect: () async {
            debugPrint('Connecting to WebSocket...');
            startTimer();
            await Future.delayed(const Duration(milliseconds: 500));
          },
        ),
      );
      _stompClient!.activate();
    }
  }

  void _onStompConnected(StompFrame frame) {
    isConnected = true;
    _shouldReconnect = false;
    debugPrint('Connected to STOMP');

    _stompClient!.subscribe(
      destination: '/topic/ride',
      callback: (frame) => _handleIncomingMessage(frame),
    );
  }

  void _handleIncomingMessage(StompFrame frame) async {
    if (frame.body == null || _context == null) return;

    final data = json.decode(frame.body!);
    final ride = Ride.fromJson(data);
    final rideProvider = Provider.of<RideProvider>(_context!, listen: false);
    final selectedRideProvider = Provider.of<SelectedRideProvider>(_context!, listen: false);

    if (rideProvider.rides!.any((r) => r.rideId == ride.rideId)) {
      rideProvider.replaceRide(ride);
    } else {
      rideProvider.addRide(ride);
      selectedRideProvider.set(ride);
      Get.to(() => const RideDetailsScreen());
    }
    selectedRideProvider.replaceRide(ride);
  }

  void _handleDisconnect() {
    isConnected = false;
    _shouldReconnect = true;
    Timer(const Duration(seconds: 5), () {
      if (_shouldReconnect) connectSocket();
    });
  }

  Future<void> _onBackgroundFetch(String taskId) async {
    debugPrint('triggered');
    if (!isConnected && _context != null) {
      _context!.read<RideProvider>().getRides();
      if (_shouldReconnect) connectSocket();
    }
    BackgroundFetch.finish(taskId);
  }

  static Future<void> _backgroundFetchHeadlessTask(String taskId) async {
    debugPrint('headless task started');
    BackgroundFetch.finish(taskId);
  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (_context != null) {
        _context!.read<RideProvider>().getRides();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  void dispose() {
    stopTimer();
    _stompClient?.deactivate();
    BackgroundFetch.stop();
  }

  void disconnectSocket() {
    _shouldReconnect = false;
    _stompClient?.deactivate();
    isConnected = false;
  }
}