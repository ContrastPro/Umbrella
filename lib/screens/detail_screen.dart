import 'dart:convert';

import 'package:bezier_chart/bezier_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:umbrella/global/colors.dart';
import 'package:umbrella/local_store/local_store.dart';

class DetailScreen extends StatefulWidget {
  final bool darkMode;
  final String currentLocation;
  final int windDeg;
  final double windSpeed;
  final int feelsLike;
  final int humidity;
  final int pressure;

  DetailScreen(
      {Key key,
      @required this.darkMode,
      this.currentLocation,
      this.windDeg,
      this.feelsLike,
      this.humidity,
      this.pressure,
      this.windSpeed})
      : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  List _listHourly;
  List _listDaily;
  bool _darkMode;

  @override
  void initState() {
    _darkMode = widget.darkMode;
    this._getForecast();
    super.initState();
  }

  _getForecast() async {
    String forecast = await readCurrentWeather();
    setState(() => _listHourly = json.decode(forecast)['hourly']);
    setState(() => _listDaily = json.decode(forecast)['daily']);
  }

  DateTime _parseTime(listForecast) {
    return DateTime.fromMillisecondsSinceEpoch(listForecast['dt'] * 1000);
  }

  double _parseTemperature(listForecast) {
    return listForecast['temp'];
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
                  Navigator.pop(
                    context,
                    _darkMode,
                  );
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
              Text(
                widget.currentLocation,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _darkMode != true ? tl_primary : td_primary,
                  fontSize: 22,
                  fontWeight: FontWeight.w300,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() => _darkMode = !_darkMode);
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

    Widget _itemForecast(dynamic item) {
      DateFormat dateFormat = DateFormat('EEEE');
      int _temperatureDay = item['temp']['day'].round();
      int _temperatureNight = item['temp']['night'].round();
      String icon = item['weather'][0]['icon'];

      return Container(
        width: 135,
        margin: const EdgeInsets.fromLTRB(5, 8, 20, 8),
        child: Row(
          children: [
            Image.asset(
              "assets/weather/${icon.substring(0, icon.length - 1)}d.png",
              width: 50,
              height: 50,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dateFormat.format(
                      DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000),
                    ),
                    style: TextStyle(
                      color: _darkMode != true ? tl_primary : td_primary,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    item['weather'][0]['description'],
                    style: TextStyle(
                      color: _darkMode != true ? tl_primary : td_primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              "$_temperatureDay° / $_temperatureNight°",
              style: TextStyle(
                color: _darkMode != true ? tl_primary : td_primary,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      );
    }

    Widget _buildForecast() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Прогноз на 7 дней',
              style: TextStyle(
                color: _darkMode != true ? tl_primary : td_primary,
                fontSize: 18,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Container(
            height: 470,
            margin: const EdgeInsets.fromLTRB(16, 25, 16, 45),
            decoration: BoxDecoration(
                color: _darkMode != true ? cl_background : cd_background,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  setBoxShadowDark(_darkMode),
                  setBoxShadowLight(_darkMode),
                ]),
            child: Center(
              child: _listDaily != null
                  ? ListView.builder(
                      itemCount: 7,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return _itemForecast(_listDaily[index]);
                      },
                    )
                  : CircularProgressIndicator(),
            ),
          ),
        ],
      );
    }

    Widget _buildChart() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Температура сегодня',
              style: TextStyle(
                color: _darkMode != true ? tl_primary : td_primary,
                fontSize: 18,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Container(
            height: 200,
            margin: const EdgeInsets.fromLTRB(16, 25, 16, 45),
            padding: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                color: _darkMode != true ? cl_background : cd_background,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  setBoxShadowDark(_darkMode),
                  setBoxShadowLight(_darkMode),
                ]),
            child: BezierChart(
              bezierChartScale: BezierChartScale.HOURLY,
              fromDate: _parseTime(_listHourly[0]),
              toDate: _parseTime(_listHourly[0]).add(Duration(hours: 24)),
              selectedDate: _parseTime(_listHourly[0]),
              series: [
                BezierLine(
                  label: 'C°',
                  lineColor: _darkMode != true ? cd_background : cl_background,
                  data: [
                    DataPoint<DateTime>(
                        value: _parseTemperature(_listHourly[0]),
                        xAxis: _parseTime(_listHourly[0])),
                    DataPoint<DateTime>(
                        value: _parseTemperature(_listHourly[1]),
                        xAxis: _parseTime(_listHourly[1])),
                    DataPoint<DateTime>(
                        value: _parseTemperature(_listHourly[2]),
                        xAxis: _parseTime(_listHourly[2])),
                    DataPoint<DateTime>(
                        value: _parseTemperature(_listHourly[3]),
                        xAxis: _parseTime(_listHourly[3])),
                    DataPoint<DateTime>(
                        value: _parseTemperature(_listHourly[4]),
                        xAxis: _parseTime(_listHourly[4])),
                    DataPoint<DateTime>(
                        value: _parseTemperature(_listHourly[5]),
                        xAxis: _parseTime(_listHourly[5])),
                    DataPoint<DateTime>(
                        value: _parseTemperature(_listHourly[6]),
                        xAxis: _parseTime(_listHourly[6])),
                    DataPoint<DateTime>(
                        value: _parseTemperature(_listHourly[7]),
                        xAxis: _parseTime(_listHourly[7])),
                    DataPoint<DateTime>(
                        value: _parseTemperature(_listHourly[8]),
                        xAxis: _parseTime(_listHourly[8])),
                    DataPoint<DateTime>(
                        value: _parseTemperature(_listHourly[9]),
                        xAxis: _parseTime(_listHourly[9])),
                    DataPoint<DateTime>(
                        value: _parseTemperature(_listHourly[10]),
                        xAxis: _parseTime(_listHourly[10])),
                    DataPoint<DateTime>(
                        value: _parseTemperature(_listHourly[11]),
                        xAxis: _parseTime(_listHourly[11])),
                    DataPoint<DateTime>(
                        value: _parseTemperature(_listHourly[12]),
                        xAxis: _parseTime(_listHourly[12])),
                    DataPoint<DateTime>(
                        value: _parseTemperature(_listHourly[13]),
                        xAxis: _parseTime(_listHourly[13])),
                    DataPoint<DateTime>(
                        value: _parseTemperature(_listHourly[14]),
                        xAxis: _parseTime(_listHourly[14])),
                    DataPoint<DateTime>(
                        value: _parseTemperature(_listHourly[15]),
                        xAxis: _parseTime(_listHourly[15])),
                    DataPoint<DateTime>(
                        value: _parseTemperature(_listHourly[16]),
                        xAxis: _parseTime(_listHourly[16])),
                    DataPoint<DateTime>(
                        value: _parseTemperature(_listHourly[17]),
                        xAxis: _parseTime(_listHourly[17])),
                    DataPoint<DateTime>(
                        value: _parseTemperature(_listHourly[18]),
                        xAxis: _parseTime(_listHourly[18])),
                    DataPoint<DateTime>(
                        value: _parseTemperature(_listHourly[19]),
                        xAxis: _parseTime(_listHourly[19])),
                    DataPoint<DateTime>(
                        value: _parseTemperature(_listHourly[20]),
                        xAxis: _parseTime(_listHourly[20])),
                    DataPoint<DateTime>(
                        value: _parseTemperature(_listHourly[21]),
                        xAxis: _parseTime(_listHourly[21])),
                    DataPoint<DateTime>(
                        value: _parseTemperature(_listHourly[22]),
                        xAxis: _parseTime(_listHourly[22])),
                    DataPoint<DateTime>(
                        value: _parseTemperature(_listHourly[23]),
                        xAxis: _parseTime(_listHourly[23])),
                    DataPoint<DateTime>(
                        value: _parseTemperature(_listHourly[24]),
                        xAxis: _parseTime(_listHourly[24])),
                  ],
                ),
              ],
              config: BezierChartConfig(
                verticalIndicatorStrokeWidth: 3.0,
                showVerticalIndicator: true,
                verticalIndicatorFixedPosition: false,
                snap: false,
                bubbleIndicatorLabelStyle: TextStyle(fontSize: 10),
                verticalIndicatorColor:
                    _darkMode != true ? cd_background : cl_background,
                xAxisTextStyle: TextStyle(
                    color: _darkMode != true ? tl_primary : td_primary,
                    fontWeight: FontWeight.w300),
              ),
            ),
          ),
        ],
      );
    }

    Widget _detailItem(String title, String subtitle, String icon) {
      return Expanded(
        child: Container(
          height: 100,
          margin: const EdgeInsets.fromLTRB(16, 25, 16, 0),
          padding: EdgeInsets.fromLTRB(16, 5, 16, 5),
          decoration: BoxDecoration(
              color: _darkMode != true ? cl_background : cd_background,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                setBoxShadowDark(_darkMode),
                setBoxShadowLight(_darkMode),
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$title",
                    style: TextStyle(
                      color: _darkMode != true ? tl_primary : td_primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "$subtitle",
                    style: TextStyle(
                      color: _darkMode != true ? tl_primary : td_primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Image.asset(
                _darkMode != true
                    ? "assets/details/d_$icon.png"
                    : "assets/details/l_$icon.png",
                width: 25,
                height: 25,
              ),
            ],
          ),
        ),
      );
    }

    String _setDirection() {
      if (widget.windDeg == 0) return 'Север';
      if (widget.windDeg == 90) return 'Восток';
      if (widget.windDeg == 180) return 'Юг';
      if (widget.windDeg == 270) return 'Запад';

      if (widget.windDeg > 0 && widget.windDeg < 90) return 'Северо-восток';
      if (widget.windDeg > 90 && widget.windDeg < 180) return 'Юго-восток';
      if (widget.windDeg > 180 && widget.windDeg < 270) return 'Юго-запад';
      if (widget.windDeg > 270 && widget.windDeg < 360) return 'Северо-запад';
      return 'Неизвестно';
    }

    Widget _buildDetails() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Детали',
              style: TextStyle(
                color: _darkMode != true ? tl_primary : td_primary,
                fontSize: 18,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Row(
            children: [
              _detailItem(_setDirection(), "${widget.windSpeed} км/ч", "wind"),
              _detailItem("Ощущается", "${widget.feelsLike}°", "temperature"),
            ],
          ),
          Row(
            children: [
              _detailItem("Влажность", "${widget.humidity} %", "humidity"),
              _detailItem("Давление", "${widget.pressure} hPa", "pressure"),
            ],
          ),
          SizedBox(height: 20),
        ],
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _darkMode != true ? lightTheme : darkTheme,
      home: Scaffold(
        backgroundColor: _darkMode != true ? cl_background : cd_background,
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 120),
              child: ListView(
                children: [
                  _buildForecast(),
                  _listHourly != null
                      ? _buildChart()
                      : Center(child: CircularProgressIndicator()),
                  _buildDetails(),
                ],
              ),
            ),
            _buildAppBar(),
          ],
        ),
      ),
    );
  }
}
