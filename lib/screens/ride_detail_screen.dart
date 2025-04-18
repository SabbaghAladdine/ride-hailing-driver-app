import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_driver_app/providers/selected_ride_provider.dart';

class RideDetailsScreen extends StatelessWidget {

  const RideDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedRideProvider = Provider.of<SelectedRideProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedRideProvider.ride!.rideId),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailCard(
              title: 'From',
              value: selectedRideProvider.ride!.pickup,
            ),
            const SizedBox(height: 16),
            _buildDetailCard(
              title: 'To',
              value: selectedRideProvider.ride!.destination,
            ),
            const SizedBox(height: 16),
            _buildDetailCard(
              title: 'Passenger',
              value: selectedRideProvider.ride!.passengerName,
            ),
            const SizedBox(height: 16),
            _buildDetailCard(
              title: 'Price',
              value: selectedRideProvider.ride!.price.toString(),
            ),
            const SizedBox(height: 16),
            _buildDetailCard(
              title: 'Time',
              value: selectedRideProvider.ride!.timestamp,
            ),
            const SizedBox(height: 16),
            _buildDetailCard(
              title: 'Status',
              value: selectedRideProvider.ride!.status,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  debugPrint("ride started");
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'START RIDE',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}