import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_ce/hive.dart';
import 'package:ride_driver_app/models/ride.dart';
import 'package:ride_driver_app/utils/apiIp.dart';

class RideProvider extends GetConnect with ChangeNotifier {
  List<Ride>? _rides = [];
  Box<Ride>? _rideBox;

  List<Ride>? get rides => _rides;

  Future<void> _ensureBoxOpen() async {
    _rideBox ??= await Hive.openBox<Ride>('rides');
  }

  Future<void> replaceRide(Ride newRide) async {
    await _ensureBoxOpen();
    if (_rides == null) return;
    final index = _rides!.indexWhere((ride) => ride.rideId == newRide.rideId);
    if (index != -1) {
      _rides![index] = newRide;
      await _rideBox!.putAt(index, newRide);
    }
    notifyListeners();
  }

  Future<void> addRide(Ride newRide) async {
    await _ensureBoxOpen();
    _rides?.add(newRide);
    _rides?.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    await _rideBox!.add(newRide);
    notifyListeners();
  }

  Future<void> loadRides() async {
    await _ensureBoxOpen();
    _rides = _rideBox!.values.toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    notifyListeners();
  }

  Future<void> getRides() async {
    await _ensureBoxOpen();
    try {
      final response = await get('http://${ApiIp.apiIp}/getAll');
      if (response.statusCode == 200) {
        final newRides = parsePosts(response.body)
          ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
        await _rideBox!.clear();
        _rides!.clear();
        for (final ride in newRides) {
          await _rideBox!.add(ride);
        }
        _rides!.addAll(newRides);
        notifyListeners();
      }else{
        debugPrint("Failed to retrieve rides");
      }
    } catch (e) {
      debugPrint('Error fetching rides: $e');
    }
  }

  List<Ride> parsePosts(String jsonString) {
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => Ride.fromJson(json)).toList();
  }

  @override
  void dispose() {
    _rideBox?.close();
    super.dispose();
  }
}