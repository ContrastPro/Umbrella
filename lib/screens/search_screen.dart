import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:umbrella/global/colors.dart';
import 'package:umbrella/local_store/local_store.dart';
import 'package:umbrella/models/popular_cities.dart';
import 'package:umbrella/models/weather_model.dart';

class SearchScreen extends StatefulWidget {
  final darkMode;

  SearchScreen({Key key, @required this.darkMode}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool _darkMode;
  bool _isUpdate = false;
  double _lat;
  double _lon;
  String _name;

  @override
  void initState() {
    _darkMode = widget.darkMode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildAppBar() {
      return Container(
        color: _darkMode != true ? cl_background : cd_background,
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 50,
                  height: 50,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  decoration: BoxDecoration(
                      color: _darkMode != true ? cl_background : cd_background,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      boxShadow: [
                        setBoxShadowDark(_darkMode),
                        setBoxShadowLight(_darkMode),
                      ]),
                  child: Icon(Icons.arrow_back),
                ),
              ),
              Expanded(
                child: Text(
                  "Поиск",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: _darkMode != true ? tl_primary : td_primary,
                      fontSize: 22,
                      fontWeight: FontWeight.w300),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  if (_darkMode == true) {
                    setState(() => _darkMode = false);
                    saveTheme("light");
                  } else {
                    setState(() => _darkMode = true);
                    saveTheme("dark");
                  }
                },
                child: Container(
                  width: 50,
                  height: 50,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  decoration: BoxDecoration(
                    color: _darkMode != true ? cl_background : cd_background,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    boxShadow: [
                      setBoxShadowDark(_darkMode),
                      setBoxShadowLight(_darkMode),
                    ],
                  ),
                  child: Icon(
                    _darkMode != true ? Icons.brightness_3 : Icons.brightness_7,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    _buildListCities() {
      List<Widget> choices = List();

      cities.forEach((city) {
        choices.add(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ActionChip(
              backgroundColor:
                  _darkMode != true ? cl_lightShadow : cd_lightShadow,
              elevation: 0,
              pressElevation: 0,
              label: Text(
                city,
                style: TextStyle(
                  color: _darkMode != true ? tl_primary : td_primary,
                  fontWeight: FontWeight.w300,
                ),
              ),
              onPressed: () async {
                setState(() => _isUpdate = true);
                await _getWeather(city);
                saveCity(city);
                print("Название: $_name\nШирота: $_lat, Долгота: $_lon");
                await _getCurrentWeather(_lat, _lon);
                Navigator.pop(context);
              },
            ),
          ),
        );
      });
      return choices;
    }

    Widget _homeScreen() {
      return Container(
        height: 350,
        margin: const EdgeInsets.fromLTRB(16, 150, 16, 20),
        decoration: BoxDecoration(
            color: _darkMode != true ? cl_background : cd_background,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              setBoxShadowDark(_darkMode),
              setBoxShadowLight(_darkMode),
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 25, 16, 8),
              child: Text(
                'Популярные города',
                style: TextStyle(
                    color: _darkMode != true ? tl_primary : td_primary,
                    fontSize: 20,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Center(child: Wrap(children: _buildListCities())),
          ],
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _darkMode != true ? lightTheme : darkTheme,
      home: Scaffold(
        backgroundColor: _darkMode != true ? cl_background : cd_background,
        body: Stack(
          children: [
            _homeScreen(),
            _buildAppBar(),
            _isUpdate != true
                ? SizedBox()
                : Center(
                    child: Container(
                      color: _darkMode != true
                          ? cl_background.withOpacity(0.6)
                          : cd_background.withOpacity(0.6),
                      child: SpinKitDoubleBounce(
                        color:
                            _darkMode != true ? cd_background : cl_background,
                        size: 50.0,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> _getWeather(String city) async {
    var response = await http.get(
        // Encode the url
        Uri.encodeFull(
            "http://api.openweathermap.org/data/2.5/weather?q=$city&appid=800fa38035fea9e71554e7d7134e0190&units=metric&lang=ru"),
        // Only accept JSON response
        headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      setState(() {
        _lon = json.decode(response.body)['coord']['lon'];
        _lat = json.decode(response.body)['coord']['lat'];
        _name = json.decode(response.body)['name'];
      });
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load Current Forecast');
    }
  }

  Future<WeatherModel> _getCurrentWeather(double lat, double lon) async {
    var response = await http.get(
      // Encode the url
        Uri.encodeFull(
            "http://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&exclude=minutely&appid=800fa38035fea9e71554e7d7134e0190&units=metric&lang=ru"),
        // Only accept JSON response
        headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      saveCurrentWeather(response.body);
      return WeatherModel.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load Current Weather');
    }
  }
}
