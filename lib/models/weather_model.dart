class WeatherModel {
  final int dt;
  final int sunrise;
  final int sunset;
  final int temp;
  final int feelsLike;
  final int pressure;
  final int humidity;
  final double windSpeed;
  final int windDeg;
  final String description;
  final String icon;

  WeatherModel({
    this.dt,
    this.sunrise,
    this.sunset,
    this.temp,
    this.feelsLike,
    this.pressure,
    this.humidity,
    this.windSpeed,
    this.windDeg,
    this.description,
    this.icon,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      dt: json['current']['dt'] * 1000,
      sunrise: json['current']['sunrise'] * 1000,
      sunset: json['current']['sunset'] * 1000,
      temp: json['current']['temp'].round(),
      feelsLike: json['current']['feels_like'].round(),
      pressure: json['current']['pressure'],
      humidity: json['current']['humidity'],
      windSpeed: json['current']['wind_speed'],
      windDeg: json['current']['wind_deg'],
      description: json['current']['weather'][0]['description'],
      icon: json['current']['weather'][0]['icon'],
    );
  }
}
