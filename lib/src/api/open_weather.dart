import "dart:convert";

import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:json_annotation/json_annotation.dart";
import "package:http/http.dart" as http;

part 'open_weather.g.dart';

class Location {
  final double _lat;
  final double _lng;

  const Location({required double lat, required double lng})
    : _lat = lat,
      _lng = lng;

  double get lat => _lat;
  double get lng => _lng;
}

class OpenWeatherAPI {
  final _baseUrl = Uri.https("api.openweathermap.org", "");
  final _apiKey = dotenv.env["API_KEY"];

  Future<OpenWeatherAPIGetForecastsResponse> getForecasts(
    Location location,
  ) async {
    final url = Uri.https(_baseUrl.host, "data/3.0/onecall", {
      "lat": location.lat.toStringAsPrecision(5),
      "lon": location.lng.toStringAsPrecision(5),
      "appid": _apiKey,
      "exclude": ["minutely", "hourly", "alerts"].join(","),
      "units": "metric",
    });

    var response = await http.get(url);
    if (response.statusCode == 200) {
      return OpenWeatherAPIGetForecastsResponse.fromJson(
        json.decode(response.body),
      );
    }
    return Future.error("Could not reach the API");
  }
}

@JsonSerializable()
class OpenWeatherAPIGetForecastsResponse {
  final double lat;
  final double lon;

  final OpenWeatherAPIGetForecastsResponseCurrent current;
  final List<OpenWeatherAPIGetForecastsResponseDaily> daily;

  const OpenWeatherAPIGetForecastsResponse({
    required this.lat,
    required this.lon,
    required this.current,
    required this.daily,
  });

  factory OpenWeatherAPIGetForecastsResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$OpenWeatherAPIGetForecastsResponseFromJson(json);
}

@JsonSerializable()
class OpenWeatherAPIGetForecastsResponseCurrent {
  final double dt;
  final double temp;
  final List<OpenWeatherAPIGetForecastsResponseWeather> weather;

  const OpenWeatherAPIGetForecastsResponseCurrent({
    required this.dt,
    required this.temp,
    required this.weather,
  });

  factory OpenWeatherAPIGetForecastsResponseCurrent.fromJson(
    Map<String, dynamic> json,
  ) => _$OpenWeatherAPIGetForecastsResponseCurrentFromJson(json);
}

@JsonSerializable()
class OpenWeatherAPIGetForecastsResponseDaily {
  final double dt;
  final OpenWeatherAPIGetForecastsResponseTemps temp;
  final List<OpenWeatherAPIGetForecastsResponseWeather> weather;

  const OpenWeatherAPIGetForecastsResponseDaily({
    required this.dt,
    required this.temp,
    required this.weather,
  });

  factory OpenWeatherAPIGetForecastsResponseDaily.fromJson(
    Map<String, dynamic> json,
  ) => _$OpenWeatherAPIGetForecastsResponseDailyFromJson(json);
}

@JsonSerializable()
class OpenWeatherAPIGetForecastsResponseWeather {
  final int id;
  final String main;
  final String icon;

  const OpenWeatherAPIGetForecastsResponseWeather({
    required this.id,
    required this.main,
    required this.icon,
  });

  factory OpenWeatherAPIGetForecastsResponseWeather.fromJson(
    Map<String, dynamic> json,
  ) => _$OpenWeatherAPIGetForecastsResponseWeatherFromJson(json);
}

@JsonSerializable()
class OpenWeatherAPIGetForecastsResponseTemps {
  final double day;
  final double min;
  final double max;

  const OpenWeatherAPIGetForecastsResponseTemps({
    required this.day,
    required this.min,
    required this.max,
  });

  factory OpenWeatherAPIGetForecastsResponseTemps.fromJson(
    Map<String, dynamic> json,
  ) => _$OpenWeatherAPIGetForecastsResponseTempsFromJson(json);
}
