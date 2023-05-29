import 'package:climate_riverpod/weather_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrentWeatherScreen extends ConsumerWidget {
  const CurrentWeatherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherNotifier = ref.watch(weatherProvider);
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/clouds.jpeg'), fit: BoxFit.cover)),
        child: Column(
          children: [
            SizedBox(
              height: 200,
            ),
            Text('${weatherNotifier.tempInCel}º',
                style: TextStyle(color: Colors.white, fontSize: 50)),
            Text('${weatherNotifier.emoji} ${weatherNotifier.weather}',
                style: TextStyle(color: Colors.white, fontSize: 50)),
          ],
        ),
      ),
    );
  }
}
