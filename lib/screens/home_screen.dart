import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:umbrella/global/colors.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List data;

  @override
  void initState() {
    this.getJSONData();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    super.initState();
  }

  Future<String> getJSONData() async {
    var response = await http.get(
        // Encode the url
        Uri.encodeFull(
            "https://api.openweathermap.org/data/2.5/forecast?q=Odessa&appid=800fa38035fea9e71554e7d7134e0190&units=metric&lang=ru"),
        // Only accept JSON response
        headers: {"Accept": "application/json"});

    setState(() {
      // Get the JSON data
      data = json.decode(response.body)['list'];
    });

    return "Successfull";
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildAppBar() {
      return Container(
        color: c_background,
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 50,
                  height: 50,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  decoration: BoxDecoration(
                      color: c_background,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
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
                  child: Icon(Icons.menu),
                ),
              ),
              Expanded(
                child: Text(
                  "Одесса, UA",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: t_primary,
                      fontSize: 22,
                      fontWeight: FontWeight.w300),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 50,
                  height: 50,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  decoration: BoxDecoration(
                      color: c_background,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
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
                  child: Icon(Icons.search),
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget _buildCurrentWeather() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "10°",
            style: TextStyle(
                color: t_primary, fontSize: 100, fontWeight: FontWeight.w400),
          ),
          Text(
            "Облачно",
            style: TextStyle(
                color: t_primary, fontSize: 20, fontWeight: FontWeight.w300),
          ),
        ],
      );
    }

    Widget _itemForecast(dynamic item) {
      DateFormat dateFormat = DateFormat('HH:mm');
      int _temperature = item['main']['temp'].round();

      return Container(
        width: 130,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
                    color: t_primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w300),
              ),
              Text(
                "$_temperature°",
                style: TextStyle(
                    color: t_primary,
                    fontSize: 35,
                    fontWeight: FontWeight.w400),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item['weather'][0]['description'],
                      style: TextStyle(
                          color: t_primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                  Image.asset(
                    "assets/icons/${item['weather'][0]['icon']}.png",
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
      return Container(
        height: 210,
        child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            itemCount: 10,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return _itemForecast(data[index]);
            }),
      );
    }

    Widget _buildChart() {
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
    }

    Widget _homeScreen() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 100),
          Expanded(
            flex: 3,
            child: _buildCurrentWeather(),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                _buildForecastList(),
              ],
            ),
          )
        ],
      );
    }

    return Scaffold(
      backgroundColor: c_background,
      body: data != null
          ? Stack(
              children: [
                _homeScreen(),
                _buildAppBar(),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
