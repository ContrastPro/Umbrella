import 'dart:convert';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:umbrella/global/theme.dart';
import 'package:umbrella/local_store/local_store.dart';
import 'package:umbrella/global/colors.dart';
import 'package:umbrella/models/weather_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _listForecast;
  String _location = "Одесса";
  String _language = "ru";
  bool _isUpdate = false;
  bool _darkMode = false;

  @override
  void initState() {
    this.getForecast(_location, _language);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildAppBar(String name, String country) {
      return Container(
        color: _darkMode != true ? cl_background : cd_background,
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _darkMode = !_darkMode;
                  });
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
                        BoxShadow(
                            color: _darkMode != true
                                ? cl_darkShadow
                                : cd_darkShadow,
                            offset: Offset(4.0, 4.0),
                            blurRadius: 15.0,
                            spreadRadius: 1.0),
                        BoxShadow(
                            color: _darkMode != true
                                ? cl_lightShadow
                                : cd_lightShadow,
                            offset: Offset(-4.0, -4.0),
                            blurRadius: 15.0,
                            spreadRadius: 1.0),
                      ]),
                  child: Icon(Icons.menu),
                ),
              ),
              Expanded(
                child: Text(
                  "$name, $country",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: _darkMode != true ? tl_primary : td_primary,
                      fontSize: 22,
                      fontWeight: FontWeight.w300),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() => _isUpdate = true);
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
                        BoxShadow(
                            color: _darkMode != true
                                ? cl_darkShadow
                                : cd_darkShadow,
                            offset: Offset(4.0, 4.0),
                            blurRadius: 15.0,
                            spreadRadius: 1.0),
                        BoxShadow(
                            color: _darkMode != true
                                ? cl_lightShadow
                                : cd_lightShadow,
                            offset: Offset(-4.0, -4.0),
                            blurRadius: 15.0,
                            spreadRadius: 1.0),
                      ]),
                  child: Icon(Icons.search),
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget _buildCurrentWeather(
        int temperature, String description, String icon) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 280,
              height: 280,
              child: FlareActor(
                "assets/flare/weather_icons.flr",
                alignment: Alignment.center,
                fit: BoxFit.contain,
                /*animation: "50d",*/
                animation: "${icon}d",
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "$temperature°",
                style: TextStyle(
                    color: _darkMode != true ? tl_primary : td_primary,
                    fontSize: 80,
                    fontWeight: FontWeight.w400),
              ),
              Text(
                "$description",
                style: TextStyle(
                    color: _darkMode != true ? tl_primary : td_primary,
                    fontSize: 18,
                    fontWeight: FontWeight.w300),
              ),
              SizedBox(height: 20)
            ],
          ),
        ],
      );
    }

    Widget _itemForecast(dynamic item) {
      DateFormat dateFormat = DateFormat('HH:mm');
      int _temperature = item['main']['temp'].round();
      String icon = item['weather'][0]['icon'];

      return Container(
        width: 135,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: BoxDecoration(
            color: _darkMode != true ? cl_background : cd_background,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                  color: _darkMode != true ? cl_darkShadow : cd_darkShadow,
                  offset: Offset(4.0, 4.0),
                  blurRadius: 15.0,
                  spreadRadius: 1.0),
              BoxShadow(
                  color: _darkMode != true ? cl_lightShadow : cd_lightShadow,
                  offset: Offset(-4.0, -4.0),
                  blurRadius: 15.0,
                  spreadRadius: 1.0),
            ]),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 5, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dateFormat.format(
                  DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000),
                ),
                style: TextStyle(
                    color: _darkMode != true ? tl_primary : td_primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w300),
              ),
              Text(
                "$_temperature°",
                style: TextStyle(
                    color: _darkMode != true ? tl_primary : td_primary,
                    fontSize: 35,
                    fontWeight: FontWeight.w400),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item['weather'][0]['description'],
                      style: TextStyle(
                          color: _darkMode != true ? tl_primary : td_primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                  Image.asset(
                    "assets/icons/${icon.substring(0, icon.length - 1)}d.png",
                    width: 45,
                    height: 45,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    Widget _buildForecastList() {
      return _listForecast != null
          ? Container(
              height: 210,
              child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  itemCount: _listForecast.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return _itemForecast(_listForecast[index]);
                  }),
            )
          : Center(child: CircularProgressIndicator());
    }

    /*Widget _buildChart() {
      return Container(
        height: 280,
        margin: const EdgeInsets.fromLTRB(16, 10, 16, 20),
        decoration: BoxDecoration(
            color: c_background,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                  color: c_darkShadow,
                  offset: Offset(4.0, 4.0),
                  blurRadius: 15.0,
                  spreadRadius: 1.0),
              BoxShadow(
                  color: c_lightShadow,
                  offset: Offset(-4.0, -4.0),
                  blurRadius: 15.0,
                  spreadRadius: 1.0),
            ]),
      );
    }*/

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Umbrella',
      theme: _darkMode != true ? lightTheme : darkTheme,
      home: Scaffold(
        backgroundColor: _darkMode != true ? cl_background : cd_background,
        body: FutureBuilder<WeatherModel>(
          future: getCurrentWeather(_location, _language),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text("${snapshot.error}"));
            }

            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            return Stack(
              children: [
                Column(
                  children: [
                    SizedBox(height: 100),
                    Expanded(
                      child: _buildCurrentWeather(
                          snapshot.data.temperature,
                          snapshot.data.description,
                          snapshot.data.icon
                              .substring(0, snapshot.data.icon.length - 1)),
                    ),
                    Column(
                      children: [
                        _buildForecastList(),
                      ],
                    )
                  ],
                ),
                _buildAppBar(snapshot.data.name, snapshot.data.country),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<WeatherModel> getCurrentWeather(
      String location, String language) async {
    String currentWeather = await readCurrentWeather();
    if (currentWeather != "Couldn't read file" && _isUpdate != true) {
      return WeatherModel.fromJson(json.decode(currentWeather));
    } else {
      var response = await http.get(
          // Encode the url
          Uri.encodeFull(
              "https://api.openweathermap.org/data/2.5/weather?q=$location&appid=800fa38035fea9e71554e7d7134e0190&units=metric&lang=$language"),
          // Only accept JSON response
          headers: {"Accept": "application/json"});

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response, then parse the JSON.
        saveCurrentWeather(response.body);
        setState(() => _isUpdate = false);
        return WeatherModel.fromJson(json.decode(response.body));
      } else {
        // If the server did not return a 200 OK response, then throw an exception.
        throw Exception('Failed to load Current Weather');
      }
    }
  }

  Future<void> getForecast(String location, String language) async {
    String forecast = await readForecast();

    if (forecast != "Couldn't read file" && _isUpdate != true) {
      setState(() => _listForecast = json.decode(forecast)['list']);
    } else {
      var response = await http.get(
          // Encode the url
          Uri.encodeFull(
              "https://api.openweathermap.org/data/2.5/forecast?q=$location&appid=800fa38035fea9e71554e7d7134e0190&units=metric&lang=$language"),
          // Only accept JSON response
          headers: {"Accept": "application/json"});

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response, then parse the JSON.
        saveForecast(response.body);
        setState(() {
          _listForecast = json.decode(response.body)['list'];
          _isUpdate = false;
        });
      } else {
        // If the server did not return a 200 OK response, then throw an exception.
        throw Exception('Failed to load Current Forecast');
      }
    }
  }
}
