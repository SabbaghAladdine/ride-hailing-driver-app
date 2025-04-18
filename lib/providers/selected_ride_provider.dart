
import 'package:flutter/material.dart';
import 'package:ride_driver_app/models/ride.dart';


class SelectedRideProvider with ChangeNotifier {
  Ride? _ride ;

  Ride? get ride => _ride;
  void set(Ride ride) => _ride = ride;

  void replaceRide(Ride newRide) {
    if (_ride == null) return;
     ride?.rideId == newRide.rideId? _ride=newRide:debugPrint("Not the same ride");
    notifyListeners();
  }
}
