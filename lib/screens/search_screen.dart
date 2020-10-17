import 'package:flutter/material.dart';
import 'package:umbrella/global/colors.dart';

class SearchScreen extends StatefulWidget {
  final bool darkMode;

  SearchScreen({Key key, @required this.darkMode}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<String> _cities = [
    "Дубай",
    "Шанхай",
    "Тайбэй",
    "Киев",
    "Лос-Анджелес",
    "Макао",
    "Нью-Йорк",
    "Канада",
    "Стамбул",
    "Токио",
    "Гонконг",
    "Бангкок",
    "Сингапур",
    "Рим",
    "Чикаго",
    "Анталия",
    "Майами",
    "Москва",
    "Сеул",
    "Париж",
    "Берлин",
    "Лондон",
  ];

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
                "Поиск",
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

    _buildListCities() {
      List<Widget> choices = List();

      _cities.forEach((city) {
        choices.add(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ActionChip(
              backgroundColor:
                  widget.darkMode != true ? cl_lightShadow : cd_lightShadow,
              elevation: 0,
              pressElevation: 0,
              label: Text(
                city,
                style: TextStyle(
                  color: widget.darkMode != true ? tl_primary : td_primary,
                  fontWeight: FontWeight.w300,
                ),
              ),
              onPressed: () {
                Navigator.pop(context, city);
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
            color: widget.darkMode != true ? cl_background : cd_background,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              setBoxShadowDark(widget.darkMode),
              setBoxShadowLight(widget.darkMode),
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 25, 16, 8),
              child: Text(
                'Популярные города',
                style: TextStyle(
                    color: widget.darkMode != true ? tl_primary : td_primary,
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
      theme: widget.darkMode != true ? lightTheme : darkTheme,
      home: Scaffold(
        backgroundColor:
            widget.darkMode != true ? cl_background : cd_background,
        body: Stack(
          children: [
            _homeScreen(),
            _buildAppBar(),
          ],
        ),
      ),
    );
  }
}
