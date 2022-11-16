// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tempo_template/screens/location_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../services/location.dart';
import '../services/weather.dart';

const apiKey = '916b38251154b435e6fb87bd3cdadad0';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late double latitude;
  late double longitude;
  var location = Location();

  void getData() async {
    var url = Uri.parse(
        'https://samples.openweathermap.org/data/2.5/weather?lat=35&lon=139&appid=b6907d289e10d714a6e88b30761fae22');
    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      // se a requisição foi feita com sucesso
      var data = response.body;
      if (kDebugMode) {
        print(data); // imprima o resultado
      }
    } else {
      if (kDebugMode) {
        print(response.statusCode); // senão, imprima o código de erro
      }
    }

    var weatherData = await WeatherModel().getLocationWeather();
    pushToLocationScreen(weatherData);
  }

  void pushToLocationScreen(dynamic weatherData) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return LocationScreen(locationWeatherData: weatherData);
    }));
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getLocation() async {
    await location.getCurrentLocation();

    // agora podemos pedir a localização atual!
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    if (kDebugMode) {
      print(position);
    }
    //await location.getCurrentLocation();
    //latitude = location.latitude;
    //longitude = location.longitude;
    //getData();
    //print(latitude);
    //print(longitude);
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SpinKitDoubleBounce(
        color: Colors.white,
        size: 100.0,
      ),
    );
  }

  checkLocationPermission() {}
}
