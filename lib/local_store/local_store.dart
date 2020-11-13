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

Future<String> readTheme() async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/theme.txt');
    String currentTheme = await file.readAsString();
    print("Set theme \"$currentTheme\". Read theme from file");
    return currentTheme;
  } catch (e) {
    print("Couldn't read theme from file");
    return "Couldn't read file";
  }
}

saveTheme(String currentTheme) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/theme.txt');
  await file.writeAsString(currentTheme);
  print('Saved theme \"$currentTheme\".');
}

Future<String> readCity() async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/city.txt');
    String currentCity = await file.readAsString();
    print("Current city is: \"$currentCity\". Read theme from file");
    return currentCity;
  } catch (e) {
    print("Couldn't read city from file");
    return "Couldn't read file";
  }
}

saveCity(String currentCity) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/city.txt');
  await file.writeAsString(currentCity);
  print('Saved city: \"$currentCity\".');
}
