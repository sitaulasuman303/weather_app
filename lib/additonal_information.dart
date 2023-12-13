import 'dart:ui';
import 'package:flutter/material.dart';

class AdditonalInformation extends StatelessWidget {
  final IconData icon;
  final String climate;
  final String temperature;
  const AdditonalInformation(
      {super.key,
      required this.icon,
      required this.climate,
      required this.temperature});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                climate,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(temperature,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold))
            ],
          ),
        ),
      ],
    );
  }
}
