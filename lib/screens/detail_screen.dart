import 'package:bezier_chart/bezier_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:umbrella/global/colors.dart';

class DetailScreen extends StatefulWidget {
  final bool darkMode;
  final int windDeg;
  final String windSpeed;
  final double feelsLike;
  final String humidity;
  final String pressure;
  final List listHourly;
  final List listDaily;

  DetailScreen({
    Key key,
    @required this.darkMode,
    this.windDeg,
    this.feelsLike,
    this.humidity,
    this.pressure,
    this.windSpeed,
    this.listHourly,
    this.listDaily,
  }) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  DateTime _parseTime(listForecast) {
    return DateTime.fromMillisecondsSinceEpoch(listForecast['dt'] * 1000);
  }

  double _parseTemperature(listForecast) {
    return listForecast['temp'].toDouble();
  }

  @override
  Widget build(BuildContext context) {
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
              widget.darkMode != true
                  ? "assets/weather/${icon.substring(0, icon.length - 1)}n.png"
                  : "assets/weather/${icon.substring(0, icon.length - 1)}d.png",
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
                      color: widget.darkMode != true ? tl_primary : td_primary,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    item['weather'][0]['description'],
                    style: TextStyle(
                      color: widget.darkMode != true ? tl_primary : td_primary,
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
                color: widget.darkMode != true ? tl_primary : td_primary,
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
              'Прогноз на неделю',
              style: TextStyle(
                color: widget.darkMode != true ? tl_primary : td_primary,
                fontSize: 18,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Container(
            height: 540,
            margin: const EdgeInsets.fromLTRB(16, 25, 16, 45),
            decoration: BoxDecoration(
                color: widget.darkMode != true ? cl_background : cd_background,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  setBoxShadowDark(widget.darkMode),
                  setBoxShadowLight(widget.darkMode),
                ]),
            child: Center(
              child: widget.listDaily != null
                  ? ListView.builder(
                      itemCount: 8,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return _itemForecast(widget.listDaily[index]);
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
                color: widget.darkMode != true ? tl_primary : td_primary,
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
                color: widget.darkMode != true ? cl_background : cd_background,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  setBoxShadowDark(widget.darkMode),
                  setBoxShadowLight(widget.darkMode),
                ]),
            child: BezierChart(
              bezierChartScale: BezierChartScale.HOURLY,
              fromDate: _parseTime(widget.listHourly[0]),
              toDate: _parseTime(widget.listHourly[0]).add(Duration(hours: 24)),
              selectedDate: _parseTime(widget.listHourly[0]),
              series: [
                BezierLine(
                  label: 'C°',
                  lineColor:
                      widget.darkMode != true ? cd_background : cl_background,
                  data: [
                    DataPoint<DateTime>(
                        value: _parseTemperature(widget.listHourly[0]),
                        xAxis: _parseTime(widget.listHourly[0])),
                    DataPoint<DateTime>(
                        value: _parseTemperature(widget.listHourly[1]),
                        xAxis: _parseTime(widget.listHourly[1])),
                    DataPoint<DateTime>(
                        value: _parseTemperature(widget.listHourly[2]),
                        xAxis: _parseTime(widget.listHourly[2])),
                    DataPoint<DateTime>(
                        value: _parseTemperature(widget.listHourly[3]),
                        xAxis: _parseTime(widget.listHourly[3])),
                    DataPoint<DateTime>(
                        value: _parseTemperature(widget.listHourly[4]),
                        xAxis: _parseTime(widget.listHourly[4])),
                    DataPoint<DateTime>(
                        value: _parseTemperature(widget.listHourly[5]),
                        xAxis: _parseTime(widget.listHourly[5])),
                    DataPoint<DateTime>(
                        value: _parseTemperature(widget.listHourly[6]),
                        xAxis: _parseTime(widget.listHourly[6])),
                    DataPoint<DateTime>(
                        value: _parseTemperature(widget.listHourly[7]),
                        xAxis: _parseTime(widget.listHourly[7])),
                    DataPoint<DateTime>(
                        value: _parseTemperature(widget.listHourly[8]),
                        xAxis: _parseTime(widget.listHourly[8])),
                    DataPoint<DateTime>(
                        value: _parseTemperature(widget.listHourly[9]),
                        xAxis: _parseTime(widget.listHourly[9])),
                    DataPoint<DateTime>(
                        value: _parseTemperature(widget.listHourly[10]),
                        xAxis: _parseTime(widget.listHourly[10])),
                    DataPoint<DateTime>(
                        value: _parseTemperature(widget.listHourly[11]),
                        xAxis: _parseTime(widget.listHourly[11])),
                    DataPoint<DateTime>(
                        value: _parseTemperature(widget.listHourly[12]),
                        xAxis: _parseTime(widget.listHourly[12])),
                    DataPoint<DateTime>(
                        value: _parseTemperature(widget.listHourly[13]),
                        xAxis: _parseTime(widget.listHourly[13])),
                    DataPoint<DateTime>(
                        value: _parseTemperature(widget.listHourly[14]),
                        xAxis: _parseTime(widget.listHourly[14])),
                    DataPoint<DateTime>(
                        value: _parseTemperature(widget.listHourly[15]),
                        xAxis: _parseTime(widget.listHourly[15])),
                    DataPoint<DateTime>(
                        value: _parseTemperature(widget.listHourly[16]),
                        xAxis: _parseTime(widget.listHourly[16])),
                    DataPoint<DateTime>(
                        value: _parseTemperature(widget.listHourly[17]),
                        xAxis: _parseTime(widget.listHourly[17])),
                    DataPoint<DateTime>(
                        value: _parseTemperature(widget.listHourly[18]),
                        xAxis: _parseTime(widget.listHourly[18])),
                    DataPoint<DateTime>(
                        value: _parseTemperature(widget.listHourly[19]),
                        xAxis: _parseTime(widget.listHourly[19])),
                    DataPoint<DateTime>(
                        value: _parseTemperature(widget.listHourly[20]),
                        xAxis: _parseTime(widget.listHourly[20])),
                    DataPoint<DateTime>(
                        value: _parseTemperature(widget.listHourly[21]),
                        xAxis: _parseTime(widget.listHourly[21])),
                    DataPoint<DateTime>(
                        value: _parseTemperature(widget.listHourly[22]),
                        xAxis: _parseTime(widget.listHourly[22])),
                    DataPoint<DateTime>(
                        value: _parseTemperature(widget.listHourly[23]),
                        xAxis: _parseTime(widget.listHourly[23])),
                    DataPoint<DateTime>(
                        value: _parseTemperature(widget.listHourly[24]),
                        xAxis: _parseTime(widget.listHourly[24])),
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
                    widget.darkMode != true ? cd_background : cl_background,
                xAxisTextStyle: TextStyle(
                    color: widget.darkMode != true ? tl_primary : td_primary,
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
              color: widget.darkMode != true ? cl_background : cd_background,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                setBoxShadowDark(widget.darkMode),
                setBoxShadowLight(widget.darkMode),
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
                      color: widget.darkMode != true ? tl_primary : td_primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "$subtitle",
                    style: TextStyle(
                      color: widget.darkMode != true ? tl_primary : td_primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Image.asset(
                widget.darkMode != true
                    ? "assets/details/d_$icon.png"
                    : "assets/details/l_$icon.png",
                width: 22,
                height: 22,
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
                color: widget.darkMode != true ? tl_primary : td_primary,
                fontSize: 18,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Row(
            children: [
              _detailItem(_setDirection(), "${widget.windSpeed} км/ч", "wind"),
              _detailItem(
                  "Ощущается", "${widget.feelsLike.round()}°", "temperature"),
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

    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        _buildForecast(),
        widget.listHourly != null
            ? _buildChart()
            : Center(child: CircularProgressIndicator()),
        _buildDetails(),
      ],
    );
  }
}
