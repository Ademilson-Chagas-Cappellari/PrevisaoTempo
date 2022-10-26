import 'package:geolocator/geolocator.dart';

/// Determine a posição atual do dispositivo.
/// Quando os serviços de localização não estão habilitados ou permissões
/// forem negados, o `Future` retornará um erro.
// ignore: unused_element
Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Teste se os serviços de localização estão ativados.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Os serviços de localização não estão ativados, não continue
    // acessar a posição e solicitar aos usuários do
    // App para habilitar os serviços de localização.
    return Future.error('Os serviços de localização estão desativados');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      /*
      As permissões são negadas, da próxima vez você pode tentar solicitando permissões 
      novamente (isto também é onde o Android shouldShowRequestPermissionRational 
      e retornou verdadeiro. De acordo com as diretrizes do Android seu aplicativo
      deve mostrar uma interface do usuário explicativa agora.
      */
      return Future.error('As permissões de localização foram negadas');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // As permissões são negadas para sempre, manusiar adequadamente.
    return Future.error(
        'As permissões de localização foi negadas permanentemente, não podemos solicitar permissões.');
  }

  // Quando chegamos aqui, as permissões são concedidas e podemos
  // continue acessando a posição do dispositivo.
  return await Geolocator.getCurrentPosition();
}
