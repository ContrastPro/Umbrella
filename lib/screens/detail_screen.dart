import 'dart:convert';

import 'package:bezier_chart/bezier_chart.dart';
import 'package:flutter/material.dart';
import 'package:umbrella/global/colors.dart';
import 'package:umbrella/local_store/local_store.dart';

class DetailScreen extends StatefulWidget {
  final bool darkMode;
  final String currentLocation;

  DetailScreen({Key key, @required this.darkMode, this.currentLocation})
      : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  List _listForecast;

  @override
  void initState() {
    this._getForecast();
    super.initState();
  }

  _getForecast() async {
    String forecast = await readForecast();
    setState(() => _listForecast = json.decode(forecast)['list']);
  }

  DateTime _parseTime(listForecast){
    return DateTime.fromMillisecondsSinceEpoch(listForecast['dt'] * 1000);
  }

  double _parseTemperature(listForecast){
    return listForecast['main']['temp'];
  }



  @override
  Widget build(BuildContext context) {
    Widget _buildAppBar() {
      return Container(
        color: widget.darkMode != true ? cl_background : cd_background,
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
                      color: widget.darkMode != true
                          ? cl_background
                          : cd_background,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      boxShadow: [
                        setBoxShadowDark(widget.darkMode),
                        setBoxShadowLight(widget.darkMode),
                      ]),
                  child: Icon(Icons.arrow_back),
                ),
              ),
              Text(
                widget.currentLocation,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: widget.darkMode != true ? tl_primary : td_primary,
                    fontSize: 22,
                    fontWeight: FontWeight.w300),
              ),
              SizedBox(
                width: 82,
                height: 82,
              )
            ],
          ),
        ),
      );
    }

    Widget _buildChart() {
      return Container(
        height: 280,
        margin: const EdgeInsets.fromLTRB(16, 10, 16, 20),
        decoration: BoxDecoration(
            color: widget.darkMode != true ? cl_background : cd_background,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              setBoxShadowDark(widget.darkMode),
              setBoxShadowLight(widget.darkMode),
            ]),
        child: Center(
          child: BezierChart(
            bezierChartScale: BezierChartScale.HOURLY,
            fromDate: DateTime.now(),
            toDate: DateTime.now().add(Duration(hours: 24)),
            selectedDate: DateTime.now(),
            series: [
              BezierLine(
                lineColor: widget.darkMode != true ? cd_background : cl_background,
                data: [
                  DataPoint<DateTime>(value: _parseTemperature(_listForecast[0]), xAxis: _parseTime(_listForecast[0])),
                  DataPoint<DateTime>(value: _parseTemperature(_listForecast[1]), xAxis: _parseTime(_listForecast[1])),
                  DataPoint<DateTime>(value: _parseTemperature(_listForecast[2]), xAxis: _parseTime(_listForecast[2])),
                  DataPoint<DateTime>(value: _parseTemperature(_listForecast[3]), xAxis: _parseTime(_listForecast[3])),
                  DataPoint<DateTime>(value: _parseTemperature(_listForecast[4]), xAxis: _parseTime(_listForecast[4])),
                  DataPoint<DateTime>(value: _parseTemperature(_listForecast[5]), xAxis: _parseTime(_listForecast[5])),
                  DataPoint<DateTime>(value: _parseTemperature(_listForecast[6]), xAxis: _parseTime(_listForecast[6])),
                  DataPoint<DateTime>(value: _parseTemperature(_listForecast[7]), xAxis: _parseTime(_listForecast[7])),
                ],
              ),
            ],
            config: BezierChartConfig(
              verticalIndicatorStrokeWidth: 3.0,
              showVerticalIndicator: false,
              verticalIndicatorFixedPosition: false,
              snap: false,
            ),
          ),
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: widget.darkMode != true ? lightTheme : darkTheme,
      home: Scaffold(
        backgroundColor:
            widget.darkMode != true ? cl_background : cd_background,
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 120),
                _listForecast != null
                    ? _buildChart()
                    : Center(child: CircularProgressIndicator()),
              ],
            ),
            _buildAppBar(),
          ],
        ),
      ),
    );
  }
}
