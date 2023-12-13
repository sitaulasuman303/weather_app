import 'package:flutter/material.dart';

class MyForecast extends StatelessWidget {
  final String time;
  final String temp;
  const MyForecast({super.key, required this.temp, required this.time});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Text(
              time,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Icon(
              Icons.cloud,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              temp,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
