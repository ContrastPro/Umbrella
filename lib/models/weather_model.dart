class WeatherModel {
  final int dt;
  final int sunrise;
  final int sunset;
  final double temp;
  final double feelsLike;
  final String pressure;
  final String humidity;
  final String windSpeed;
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
      temp: json['current']['temp'].toDouble(),
      feelsLike: json['current']['feels_like'].toDouble(),
      pressure: json['current']['pressure'].toString(),
      humidity: json['current']['humidity'].toString(),
      windSpeed: json['current']['wind_speed'].toString(),
      windDeg: json['current']['wind_deg'],
      description: json['current']['weather'][0]['description'],
      icon: json['current']['weather'][0]['icon'],
    );
  }
}
