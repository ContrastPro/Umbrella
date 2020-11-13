import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:umbrella/global/colors.dart';
import 'package:umbrella/local_store/db_last_search.dart';
import 'package:umbrella/local_store/local_store.dart';
import 'package:umbrella/models/last_search_model.dart';
import 'file:///D:/AndrioidStudio/pDart/umbrella/lib/global/popular_cities.dart';
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
  bool _isEmpty;
  String _searchQuery = "";

  @override
  void initState() {
    _darkMode = widget.darkMode;
    _checkEmpty();
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

    Widget _buildSearchField() {
      final border = OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(45.0)),
        borderSide: BorderSide(
          color: Colors.transparent,
        ),
      );

      return Theme(
        data: Theme.of(context).copyWith(
          cursorColor: _darkMode != true ? cd_background : cl_background,
          hintColor: Colors.transparent,
        ),
        child: TextFormField(
          style: TextStyle(
              color: _darkMode != true ? cd_background : cl_background),
          decoration: InputDecoration(
            suffix: SizedBox(width: 20),
            focusedBorder: border,
            border: border,
            prefixIcon: Icon(
              Icons.search,
              color: _darkMode != true ? cd_background : cl_background,
            ),
            filled: true,
            hintText: 'Например: Италия',
            hintStyle: TextStyle(
                color: _darkMode != true ? cd_background : cl_background,
                fontWeight: FontWeight.w300),
          ),
          onChanged: (String value) {
            setState(() => _searchQuery = value);
          },
          onEditingComplete: () async {
            await _getWeather(_searchQuery);
          },
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
                await _getWeather(city);
              },
            ),
          ),
        );
      });
      return choices;
    }

    Widget _buildPopularCity() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Популярные города',
              style: TextStyle(
                color: _darkMode != true ? tl_primary : td_primary,
                fontSize: 18,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Container(
            height: 310,
            margin: const EdgeInsets.fromLTRB(16, 25, 16, 45),
            decoration: BoxDecoration(
              color: _darkMode != true ? cl_background : cd_background,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                setBoxShadowDark(_darkMode),
                setBoxShadowLight(_darkMode),
              ],
            ),
            child: Center(child: Wrap(children: _buildListCities())),
          ),
        ],
      );
    }

    Widget _itemLastSearch(History item) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        width: 170,
        decoration: BoxDecoration(
          color: _darkMode != true ? cl_background : cd_background,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            setBoxShadowDark(_darkMode),
            setBoxShadowLight(_darkMode),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      item.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        color: _darkMode != true ? tl_primary : td_primary,
                      ),
                    ),
                  ),
                  SizedBox(width: 2),
                  GestureDetector(
                    onTap: () {
                      MastersDatabaseProvider.db.deleteItemWithId(item.id);
                      _checkEmpty();
                    },
                    child: Icon(
                      Icons.close,
                      color: _darkMode != true ? tl_primary : td_primary,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              child: Text(
                "${item.temp}°",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 45.0,
                  fontWeight: FontWeight.w300,
                  color: _darkMode != true ? tl_primary : td_primary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      item.description.toLowerCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w300,
                        color: _darkMode != true ? tl_primary : td_primary,
                      ),
                    ),
                  ),
                  Image.asset(
                    widget.darkMode != true
                        ? "assets/weather/${item.icon.substring(0, item.icon.length - 1)}n.png"
                        : "assets/weather/${item.icon.substring(0, item.icon.length - 1)}d.png",
                    width: 50,
                    height: 50,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget _buildLastSearch() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'История поиска',
              style: TextStyle(
                color: _darkMode != true ? tl_primary : td_primary,
                fontSize: 18,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Container(
            height: 220,
            margin: const EdgeInsets.only(top: 5, bottom: 45),
            child: _isEmpty != true
                ? FutureBuilder<List<History>>(
                    future: MastersDatabaseProvider.db.getAllHistory(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<History>> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            History item = snapshot.data[index];
                            return GestureDetector(
                              onTap: () async {
                                saveCity(item.name);
                                await _getCurrentWeather(item.lat, item.lon);
                                _close();
                              },
                              child: _itemLastSearch(item),
                            );
                          },
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  )
                : Center(
                    child: Text(
                      "Здесь пока ничего нет",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w400,
                        color: _darkMode != true ? tl_primary : td_primary,
                      ),
                    ),
                  ),
          ),
        ],
      );
    }

    Widget _homeScreen() {
      return ListView(
        children: [
          SizedBox(height: 120),
          Container(
            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 45),
            width: 100,
            height: 58,
            decoration: BoxDecoration(
              color: _darkMode != true ? cl_background : cd_background,
              borderRadius: BorderRadius.all(Radius.circular(95)),
              boxShadow: [
                setBoxShadowDark(_darkMode),
                setBoxShadowLight(_darkMode),
              ],
            ),
            child: _buildSearchField(),
          ),
          _searchQuery.isEmpty ? _buildPopularCity() : SizedBox(),
          _buildLastSearch(),
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
                          size: 50.0),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  _close() => Navigator.pop(context);

  _checkEmpty() async {
    List isEmpty = await MastersDatabaseProvider.db.getAllHistory();
    if (isEmpty.isEmpty) {
      setState(() => _isEmpty = true);
    } else {
      setState(() => _isEmpty = false);
    }
  }

  _loadCity(String body, String name, double lat, double lon) async {
    saveCity(name);
    print("Название: $name\nШирота: $lat, Долгота: $lon");
    await _getCurrentWeather(lat, lon);
    await _addToHistory(body, name, lat, lon);
    _close();
  }

  _addToHistory(String body, String name, double lat, double lon) async {
    await MastersDatabaseProvider.db.addItemToDatabaseHistory(
      History(
        lat: lat,
        lon: lon,
        name: name,
        temp: json.decode(body)['main']['temp'].round().toString(),
        description: json.decode(body)['weather'][0]['description'],
        icon: json.decode(body)['weather'][0]['icon'],
      ),
    );
  }

  Future<void> _getWeather(String city) async {
    setState(() => _isUpdate = true);
    var response = await http.get(
        // Encode the url
        Uri.encodeFull(
            "http://api.openweathermap.org/data/2.5/weather?q=$city&appid=800fa38035fea9e71554e7d7134e0190&units=metric&lang=ru"),
        // Only accept JSON response
        headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      _loadCity(
        response.body,
        "${json.decode(response.body)['name']}, ${json.decode(response.body)['sys']['country']}",
        json.decode(response.body)['coord']['lat'],
        json.decode(response.body)['coord']['lon'],
      );
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      setState(() {
        _isUpdate = false;
      });
    }
  }

  Future<WeatherModel> _getCurrentWeather(double lat, double lon) async {
    setState(() => _isUpdate = true);
    var response = await http.get(
        // Encode the url
        Uri.encodeFull(
            "http://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&exclude=minutely&appid=800fa38035fea9e71554e7d7134e0190&units=metric&lang=ru"),
        // Only accept JSON response
        headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      await saveCurrentWeather(response.body);
      return WeatherModel.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load Current Weather');
    }
  }
}
