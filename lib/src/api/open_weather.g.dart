// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpenWeatherAPIGetForecastsResponse _$OpenWeatherAPIGetForecastsResponseFromJson(
  Map<String, dynamic> json,
) => OpenWeatherAPIGetForecastsResponse(
  lat: (json['lat'] as num).toDouble(),
  lon: (json['lon'] as num).toDouble(),
  current: OpenWeatherAPIGetForecastsResponseCurrent.fromJson(
    json['current'] as Map<String, dynamic>,
  ),
  daily: (json['daily'] as List<dynamic>)
      .map(
        (e) => OpenWeatherAPIGetForecastsResponseDaily.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
);

Map<String, dynamic> _$OpenWeatherAPIGetForecastsResponseToJson(
  OpenWeatherAPIGetForecastsResponse instance,
) => <String, dynamic>{
  'lat': instance.lat,
  'lon': instance.lon,
  'current': instance.current,
  'daily': instance.daily,
};

OpenWeatherAPIGetForecastsResponseCurrent
_$OpenWeatherAPIGetForecastsResponseCurrentFromJson(
  Map<String, dynamic> json,
) => OpenWeatherAPIGetForecastsResponseCurrent(
  dt: (json['dt'] as num).toDouble(),
  temp: (json['temp'] as num).toDouble(),
  weather: (json['weather'] as List<dynamic>)
      .map(
        (e) => OpenWeatherAPIGetForecastsResponseWeather.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
);

Map<String, dynamic> _$OpenWeatherAPIGetForecastsResponseCurrentToJson(
  OpenWeatherAPIGetForecastsResponseCurrent instance,
) => <String, dynamic>{
  'dt': instance.dt,
  'temp': instance.temp,
  'weather': instance.weather,
};

OpenWeatherAPIGetForecastsResponseDaily
_$OpenWeatherAPIGetForecastsResponseDailyFromJson(Map<String, dynamic> json) =>
    OpenWeatherAPIGetForecastsResponseDaily(
      dt: (json['dt'] as num).toDouble(),
      temp: OpenWeatherAPIGetForecastsResponseTemps.fromJson(
        json['temp'] as Map<String, dynamic>,
      ),
      weather: (json['weather'] as List<dynamic>)
          .map(
            (e) => OpenWeatherAPIGetForecastsResponseWeather.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    );

Map<String, dynamic> _$OpenWeatherAPIGetForecastsResponseDailyToJson(
  OpenWeatherAPIGetForecastsResponseDaily instance,
) => <String, dynamic>{
  'dt': instance.dt,
  'temp': instance.temp,
  'weather': instance.weather,
};

OpenWeatherAPIGetForecastsResponseWeather
_$OpenWeatherAPIGetForecastsResponseWeatherFromJson(
  Map<String, dynamic> json,
) => OpenWeatherAPIGetForecastsResponseWeather(
  id: (json['id'] as num).toInt(),
  main: json['main'] as String,
  icon: json['icon'] as String,
);

Map<String, dynamic> _$OpenWeatherAPIGetForecastsResponseWeatherToJson(
  OpenWeatherAPIGetForecastsResponseWeather instance,
) => <String, dynamic>{
  'id': instance.id,
  'main': instance.main,
  'icon': instance.icon,
};

OpenWeatherAPIGetForecastsResponseTemps
_$OpenWeatherAPIGetForecastsResponseTempsFromJson(Map<String, dynamic> json) =>
    OpenWeatherAPIGetForecastsResponseTemps(
      day: (json['day'] as num).toDouble(),
      min: (json['min'] as num).toDouble(),
      max: (json['max'] as num).toDouble(),
    );

Map<String, dynamic> _$OpenWeatherAPIGetForecastsResponseTempsToJson(
  OpenWeatherAPIGetForecastsResponseTemps instance,
) => <String, dynamic>{
  'day': instance.day,
  'min': instance.min,
  'max': instance.max,
};
