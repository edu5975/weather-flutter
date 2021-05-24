import 'package:flutter/material.dart';
import 'package:flutter_weather_app/network/apiWeather.dart';
import 'package:flutter_weather_bg/flutter_weather_bg.dart';
import 'package:transformer_page_view/transformer_page_view.dart';
import 'package:weather_icons/weather_icons.dart';

import '../models/weather_locations.dart';
import '../widgets/buildin_transform.dart';
import '../widgets/single_weather.dart';
import '../widgets/slider_dot.dart';

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  int _currentPage = 0;
  WeatherType weatherType;

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  List<String> cities = ["Celaya"];

  @override
  Widget build(BuildContext context) {
    ApiWeather apiWeather = new ApiWeather();

    return FutureBuilder(
      future: apiWeather.getCities(cities),
      builder: (BuildContext context,
          AsyncSnapshot<List<WeatherLocation>> snapshot) {
        IconData icon;
        WeatherType weatherType;
        if (snapshot.data[_currentPage].weather[0].main == "Clear") {
          weatherType = WeatherType.sunny;
          icon = WeatherIcons.day_sunny;
        } else if (snapshot.data[_currentPage].weather[0].main == "Rain") {
          weatherType = WeatherType.heavyRainy;
          icon = WeatherIcons.rain;
        } else if (snapshot.data[_currentPage].weather[0].main == "Snow") {
          weatherType = WeatherType.middleSnow;
          icon = WeatherIcons.snow;
        } else if (snapshot.data[_currentPage].weather[0].main == "Clouds") {
          weatherType = WeatherType.cloudy;
          icon = WeatherIcons.cloud;
        } else if (snapshot.data[_currentPage].weather[0].main ==
            "Thunderstorm") {
          weatherType = WeatherType.thunder;
          icon = WeatherIcons.thunderstorm;
        } else if (snapshot.data[_currentPage].weather[0].main == "Clouds") {
          weatherType = WeatherType.cloudy;
          icon = WeatherIcons.cloud;
        } else if (snapshot.data[_currentPage].weather[0].main == "Drizzle") {
          weatherType = WeatherType.lightRainy;
          icon = WeatherIcons.raindrop;
        } else {
          weatherType = WeatherType.thunder;
          icon = WeatherIcons.thunderstorm;
        }

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: Text(''),
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                _displayTextInputDialog(context);
              },
              icon: Icon(
                Icons.search,
                size: 30,
                color: Colors.white,
              ),
            ),
            /*actions: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: GestureDetector(
                  onTap: () {
                    cities.removeAt(_currentPage);
                    setState(() {});
                  },
                  child: Icon(
                    Icons.delete,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ],*/
          ),
          body: Container(
            child: Stack(
              children: [
                WeatherBg(
                  weatherType: weatherType,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
                Container(
                  decoration: BoxDecoration(color: Colors.black38),
                ),
                Container(
                  margin: EdgeInsets.only(top: 140, left: 15),
                  child: Row(
                    children: [
                      for (int i = 0; i < cities.length; i++)
                        if (i == _currentPage)
                          SliderDot(true)
                        else
                          SliderDot(false)
                    ],
                  ),
                ),
                TransformerPageView(
                  scrollDirection: Axis.horizontal,
                  transformer: ScaleAndFadeTransformer(),
                  viewportFraction: 0.8,
                  onPageChanged: _onPageChanged,
                  itemCount: cities.length,
                  itemBuilder: (ctx, i) =>
                      SingleWeather(snapshot.data[i], i, icon),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  TextEditingController _textFieldController = TextEditingController();
  String valueText;
  String codeDialog;

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Search new City'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "New City"),
            ),
            actions: <Widget>[
              MaterialButton(
                color: Colors.blueGrey,
                textColor: Colors.white,
                child: Text('Cancel'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              MaterialButton(
                color: Colors.blue,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    codeDialog = valueText;
                    cities.add(codeDialog);
                    valueText = "";
                    codeDialog = "";
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }
}
