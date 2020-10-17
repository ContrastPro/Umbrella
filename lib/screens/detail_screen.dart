import 'package:flutter/material.dart';
import 'package:umbrella/global/colors.dart';

class DetailScreen extends StatefulWidget {
  final bool darkMode;
  final String currentLocation;

  DetailScreen({Key key, @required this.darkMode, this.currentLocation})
      : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
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
                _buildChart(),
              ],
            ),
            _buildAppBar(),
          ],
        ),
      ),
    );
  }
}
