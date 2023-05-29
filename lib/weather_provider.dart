import 'dart:convert';
import 'dart:developer';
import 'package:climate_riverpod/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

class WeatherProvider extends ChangeNotifier {
  Position? _position;
  bool _isLoading = false;
  double _longitude = 0.0;
  double _latitude = 0.0;
  String? _weather;
  double? _tempInKel;
  String? _tempInCel;
  String? _emoji;
  int? _weatherId;

  Position? get position => _position;
  bool get isLoading => _isLoading;
  String? get weather => _weather;
  double? get tempInKel => _tempInKel;
  String? get tempInCel => _tempInCel;
  String? get emoji => _emoji;
  int? get weatherId => _weatherId;

  void setLoader(bool loaderValue) {
    _isLoading = loaderValue;
    notifyListeners();
  }

  Future<void> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    setLoader(true);
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setLoader(false);
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setLoader(false);
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      setLoader(false);
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    _position = await Geolocator.getCurrentPosition();
    _latitude = _position!.latitude;
    _longitude = _position!.longitude;
    setLoader(false);
  }

  Future<void> getCurrentWeather() async {
    final weatherService = WeatherService();
    final response =
        await weatherService.getWeather(lat: _latitude, long: _longitude);
    log(response.body);
    final parsedData = jsonDecode(response.body);
    log(parsedData.toString());
    _weather = parsedData['weather'][0]['main'];
    _tempInKel = parsedData['main']['temp'];
    _tempInCel = (_tempInKel! - 273.15).floor().toString();
    _weatherId = parsedData['weather'][0]['id'];
    updateUi(parsedData);
  }

  void updateUi(parsedData) {
    if (weatherId! > 200 && weatherId! < 300) {
      _emoji = "🌩";
    } else if (weatherId! > 300 && weatherId! < 400) {
      _emoji = "⛈";
    } else if (weatherId! > 500 && weatherId! < 600) {
      _emoji = "⛄️";
    } else if (_weatherId! > 700 && _weatherId! < 800) {
      _emoji = "☁️";
    } else if (weatherId! >= 800) {
      _emoji = "🌥";
    }
  }
}

final weatherProvider = ChangeNotifierProvider((ref) => WeatherProvider());
