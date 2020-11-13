import 'dart:convert';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:umbrella/global/fade_route.dart';
import 'package:umbrella/local_store/local_store.dart';
import 'package:umbrella/global/colors.dart';
import 'package:umbrella/models/weather_model.dart';
import 'package:umbrella/screens/detail_screen.dart';
import 'package:umbrella/screens/search_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isUpdate = false;
  bool _darkMode;
  List _listHourly;
  List _listDaily;
  double _lon = 139.69;
  double _lat = 35.69;
  String _name;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    this._setTheme();
    this._setCity();
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
                onTap: () async {
                  await Navigator.push(
                    context,
                    FadeRoute(
                      page: SearchScreen(darkMode: _darkMode),
                    ),
                  );
                  _getForecast();
                  _setCity();
                  _setTheme();
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
                  child: Icon(Icons.menu),
                ),
              ),
              Expanded(
                child: Text(
                  _name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: _darkMode != true ? tl_primary : td_primary,
                      fontSize: 22,
                      fontWeight: FontWeight.w300),
                ),
              ),
              SizedBox(width: 82, height: 82),
            ],
          ),
        ),
      );
    }

    Widget _buildCurrentWeather(
        double temperature, String description, String icon) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 250,
              height: 250,
              child: FlareActor(
                "assets/flare/weather_icons.flr",
                alignment: Alignment.center,
                fit: BoxFit.contain,
                animation: "${icon}d",
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "${temperature.round()}°",
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
              SizedBox(height: 40)
            ],
          ),
        ],
      );
    }

    return FutureBuilder<WeatherModel>(
      future: _getCurrentWeather(_lat, _lon),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("${snapshot.error}"));
        }

        if (!snapshot.hasData) {
          return Center(
            child: SpinKitDoubleBounce(
              color: _darkMode != true ? cd_background : cl_background,
              size: 50.0,
            ),
          );
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: _darkMode != true ? lightTheme : darkTheme,
          home: Scaffold(
            backgroundColor: _darkMode != true ? cl_background : cd_background,
            body: _isUpdate != true
                ? CustomScrollView(
                    slivers: <Widget>[
                      SliverAppBar(
                        backgroundColor:
                            _darkMode != true ? cl_background : cd_background,
                        expandedHeight:
                            MediaQuery.of(context).size.height * 0.75,
                        floating: false,
                        pinned: false,
                        flexibleSpace: FlexibleSpaceBar(
                          background: Stack(
                            children: [
                              Column(
                                children: [
                                  SizedBox(height: 100),
                                  Expanded(
                                    child: _buildCurrentWeather(
                                      snapshot.data.temp,
                                      snapshot.data.description,
                                      snapshot.data.icon.substring(
                                          0, snapshot.data.icon.length - 1),
                                    ),
                                  ),
                                ],
                              ),
                              _buildAppBar(),
                            ],
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate(
                          <Widget>[
                            DetailScreen(
                              darkMode: _darkMode,
                              windDeg: snapshot.data.windDeg,
                              windSpeed: snapshot.data.windSpeed,
                              feelsLike: snapshot.data.feelsLike,
                              humidity: snapshot.data.humidity,
                              pressure: snapshot.data.pressure,
                              listHourly: _listHourly,
                              listDaily: _listDaily,
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                : Center(
                    child: SpinKitDoubleBounce(
                      color: _darkMode != true ? cd_background : cl_background,
                      size: 50.0,
                    ),
                  ),
          ),
        );
      },
    );
  }

  _setTheme() async {
    String theme = await readTheme();
    if (theme != "Couldn't read file") {
      if (theme == "dark") {
        setState(() => _darkMode = true);
      } else {
        setState(() => _darkMode = false);
      }
    } else {
      setState(() => _darkMode = false);
      saveTheme("light");
    }
  }

  _getForecast() async {
    String forecast = await readCurrentWeather();
    setState(() {
      _listHourly = json.decode(forecast)['hourly'];
      _listDaily = json.decode(forecast)['daily'];
    });
  }

  _setCity() async {
    String city = await readCity();
    if (city != "Couldn't read file") {
      setState(() => _name = city);
    } else {
      setState(() => _name = "Лондон");
      saveCity("Лондон");
    }
  }

  Future<WeatherModel> _getCurrentWeather(double lat, double lon) async {
    String currentWeather = await readCurrentWeather();
    if (currentWeather != "Couldn't read file" && _isUpdate != true) {
      _getForecast();
      return WeatherModel.fromJson(json.decode(currentWeather));
    } else {
      var response = await http.get(
          // Encode the url
          Uri.encodeFull(
              "http://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&exclude=minutely&appid=800fa38035fea9e71554e7d7134e0190&units=metric&lang=ru"),
          // Only accept JSON response
          headers: {"Accept": "application/json"});

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response, then parse the JSON.
        saveCurrentWeather(response.body);
        setState(() {
          _listHourly = json.decode(response.body)['hourly'];
          _listDaily = json.decode(response.body)['daily'];
          _isUpdate = false;
        });
        return WeatherModel.fromJson(json.decode(response.body));
      } else {
        // If the server did not return a 200 OK response, then throw an exception.
        throw Exception('Failed to load Current Weather');
      }
    }
  }
}
