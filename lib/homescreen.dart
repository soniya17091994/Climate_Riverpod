import 'package:climate_riverpod/current_weather_screen.dart';
import 'package:climate_riverpod/weather_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref.read(weatherProvider).getCurrentWeather().then((value) {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const CurrentWeatherScreen()));
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: CircularProgressIndicator(
        color: Colors.orange,
      )),
    );
  }
}
