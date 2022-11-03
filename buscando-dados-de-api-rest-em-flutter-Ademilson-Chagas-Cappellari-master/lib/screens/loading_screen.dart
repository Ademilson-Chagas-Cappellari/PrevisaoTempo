// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:tempo_template/services/location.dart';
import 'package:tempo_template/services/networking.dart';
import 'package:tempo_template/screens/location_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert';

const apiKey = '916b38251154b435e6fb87bd3cdadad0';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final Location location = Location();
  double? latitude = 0;
  double? longitude = 0;

  void pushToLocationScreen(dynamic weatherData) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return LocationScreen(locationWeather: weatherData);
    }));
  }

  void getData() async {
    NetworkHelper networkHelper = NetworkHelper(
        'https://api.openweathermap.org/'
        'data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric');
    var weatherData = await networkHelper.getData();

    var response;
    if (response.statusCode == 200) {
      // se a requisição foi feita com sucesso
      var data = response.body;
      var jsonData = jsonDecode(data);
      var cityName = jsonData['name'];
      var temperature = jsonData['main']['temp'];
      var weatherCondition = jsonData['weather'][0]['id'];
      print(
          'cidade: $cityName, temperatura: $temperature, condição: $weatherCondition'); // imprima o resultado
    } else {
      print(response.statusCode); // senão, imprima o código de erro
    }
    pushToLocationScreen(weatherData);
  }

  Future<void> getLocation() async {
    await location.getCurrentPosition();
    latitude = location.getLatitude();
    longitude = location.getLongitude();
    //pushToLocationScreen(weatherData);
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SpinKitPouringHourGlass(
        color: Colors.white,
        size: 100.0,
      ),
    );
  }
}
