import 'package:hive_ce/hive.dart';
import 'package:ride_driver_app/models/app_user.dart';
import 'package:ride_driver_app/models/ride.dart';

part 'hive_adapters.g.dart';

@GenerateAdapters([AdapterSpec<User>(), AdapterSpec<Ride>()])
// Annotations must be on some element
// ignore: unused_element
void _() {}
