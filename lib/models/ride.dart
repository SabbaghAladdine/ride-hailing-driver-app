
import 'package:hive_ce/hive.dart';

part 'ride.g.dart';

@HiveType(typeId: 1)
class Ride extends HiveObject{
  @HiveField(0)
  final String rideId;

  @HiveField(1)
  final String pickup;

  @HiveField(2)
  final String destination;

  @HiveField(3)
  final String status;

  @HiveField(4)
  final String passengerName;

  @HiveField(5)
  final double price;

  @HiveField(6)
  final String timestamp;

  Ride({
    required this.rideId,
    required this.pickup,
    required this.destination,
    required this.status,
    required this.passengerName,
    required this.price,
    required this.timestamp,
  });

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      rideId: json['ride_id'],
      pickup: json['pickup'],
      destination: json['destination'],
      status: json['status'],
      passengerName: json['passenger_name'],
      price: json['price'].toDouble(),
      timestamp: json['timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ride_id': rideId,
      'pickup': pickup,
      'destination': destination,
      'status': status,
      'passenger_name': passengerName,
      'price': price,
      'timestamp': timestamp,
    };
  }
}