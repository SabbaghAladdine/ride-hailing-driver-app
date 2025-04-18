import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:ride_driver_app/providers/login_provider.dart';
import 'package:ride_driver_app/providers/ride_provider.dart';
import 'package:ride_driver_app/screens/login_screen.dart';
import 'package:ride_driver_app/services/socket_service.dart';
import 'package:ride_driver_app/widgets/ride_card.dart';

class RideListScreen extends StatefulWidget {
  const RideListScreen({super.key});

  @override
  State<RideListScreen> createState() => _RideListScreenState();
}

class _RideListScreenState extends State<RideListScreen> {
  final SocketService socketService = SocketService() ;
  @override
  void initState() {
    super.initState();
    final rideProvider = Provider.of<RideProvider>(context, listen: false);
    rideProvider.loadRides();
    socketService.connectSocket();
    socketService.initialize(context);
  }

  @override
  Widget build(BuildContext context) {
    final ridesProvider = Provider.of<RideProvider>(context, listen: true);
    final rides = ridesProvider.rides;
    return Scaffold(
      appBar: AppBar(
        title: Text("Rides"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: GestureDetector(
              onTap: () => {
                socketService.disconnectSocket(),
                context.read<LoginProvider>().logout(),
                Get.offAll(()=>const LoginScreen())
              },
              child: const Icon(Icons.logout, size: 30),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        child:
            rides == null
                ? const Center(child: CircularProgressIndicator())
                : rides.isEmpty
                ? ListView(
                  children: const [
                    SizedBox(height: 150),
                    Center(
                      child: Text(
                        'It seems there are no rides.\nTry pulling down to refresh.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                )
                : ListView.builder(
                itemCount: rides.length,
                itemBuilder: (context,index){
                  return RideCard(ride: rides[index]);
            }),
        onRefresh: () async => await ridesProvider.getRides(),
      ),
    );
  }
}
