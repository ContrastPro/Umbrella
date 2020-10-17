import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<String> readCurrentWeather() async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/current_weather.txt');
    String currentWeather = await file.readAsString();
    print("Read current weather from file \n$currentWeather");
    return currentWeather;
  } catch (e) {
    print("Couldn't read current weather from file");
    return "Couldn't read file";
  }
}

saveCurrentWeather(String currentWeather) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/current_weather.txt');
  await file.writeAsString(currentWeather);
  print('Saved current weather\n$currentWeather');
}

Future<String> readForecast() async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/forecast.txt');
    String currentWeather = await file.readAsString();
    print("Read forecast from file \n$currentWeather");
    return currentWeather;
  } catch (e) {
    print("Couldn't read forecast from file");
    return "Couldn't read file";
  }
}

saveForecast(String currentWeather) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/forecast.txt');
  await file.writeAsString(currentWeather);
  print('Saved forecast\n$currentWeather');
}
