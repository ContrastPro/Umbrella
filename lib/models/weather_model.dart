class WeatherModel {
  final String name;
  final String country;
  final int temperature;
  final String description;
  final String icon;
  final String speed;
  final String humidity;
  final int feelsLike;
  final String pressure;
  final int sunrise;
  final int sunset;

  WeatherModel({
    this.name,
    this.country,
    this.temperature,
    this.description,
    this.icon,
    this.speed,
    this.humidity,
    this.feelsLike,
    this.pressure,
    this.sunrise,
    this.sunset,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      name: json['name'],
      country: json['sys']['country'],
      temperature: json['main']['temp'].round(),
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
      speed: json['wind']['speed'].toString(),
      humidity: json['main']['humidity'].toString(),
      feelsLike: json['main']['feels_like'].round(),
      pressure: json['main']['pressure'].toString(),
      sunrise: json['sys']['sunrise'] * 1000,
      sunset: json['sys']['sunset'] * 1000,
    );
  }
}
