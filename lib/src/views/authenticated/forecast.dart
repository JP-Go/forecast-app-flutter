import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weather/src/api/open_weather.dart';
import 'package:weather/src/views/public/login.dart';

enum TemperatureFeeling { hot, mild, cold }

class ForecastView extends StatefulWidget {
  const ForecastView({super.key});

  @override
  State<ForecastView> createState() {
    return Forecast();
  }
}

class Forecast extends State<ForecastView> {
  final OpenWeatherAPI _api = OpenWeatherAPI();
  int indexSelected = 0;
  DateTime selectedDate = DateTime.now();

  late final Future<OpenWeatherAPIGetForecastsResponse> _data = _getPosition()
      .then((pos) async {
        final location = Location(lat: pos.latitude, lng: pos.longitude);
        final forecast = await _api.getForecasts(location);
        return forecast;
      });

  Future<Position> _getPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Location services disabled");
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location services not authorized");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location services not authorized");
    }
    return await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.low),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    void backToLogin() {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginView()),
      );
    }

    void closeDialog() {
      Navigator.pop(context, "close");
    }

    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<OpenWeatherAPIGetForecastsResponse>(
          future: _data,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data!;
              OpenWeatherAPIGetForecastsResponseDaily selectedForecast =
                  data.daily[indexSelected];
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Weekly forecast cards
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: data.daily.length,
                        itemBuilder: (context, index) {
                          var dayForecast = data.daily[index];
                          var date = DateTime.fromMillisecondsSinceEpoch(
                            dayForecast.dt.toInt() * 1000,
                            isUtc: true,
                          );

                          return Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: _WeekDayCard(
                              date: date,
                              minTemp: dayForecast.temp.min.toInt(),
                              maxTemp: dayForecast.temp.max.toInt(),
                              forecastClass: TemperatureFeeling.hot,
                              isToday: index == 0,
                              isSelected: indexSelected == index,
                              onTap: () {
                                setState(() {
                                  indexSelected = index;
                                  selectedForecast = data.daily[indexSelected];
                                  DateTime.fromMillisecondsSinceEpoch(
                                    selectedForecast.dt.toInt() * 1000,
                                    isUtc: true,
                                  );
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 48),
                    // Current weather section
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Lat: ${data.lat.toStringAsPrecision(2)}, Lon: ${data.lon.toStringAsPrecision(2)}',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${indexSelected == 0 ? data.current.temp.toInt() : selectedForecast.temp.day}°',
                            style: theme.textTheme.displayLarge?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            DateFormat('EEEE, MMMM d').format(selectedDate),
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colorScheme.onSurface.withAlpha(179),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _TemperatureLabel(
                                label: 'Min',
                                temperature: selectedForecast.temp.min.toInt(),
                                color: colorScheme.primary,
                              ),
                              const SizedBox(width: 32),
                              _TemperatureLabel(
                                label: 'Max',
                                temperature: selectedForecast.temp.max.toInt(),
                                color: colorScheme.primary,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FloatingActionButton.small(
                          onPressed: () => showDialog<String>(
                            context: context,
                            builder: (context) => AlertDialog.adaptive(
                              title: const Text("Tem certeza que quer sair?"),
                              actions: [
                                TextButton(
                                  onPressed: backToLogin,
                                  child: const Text("Sim"),
                                ),
                                TextButton(
                                  onPressed: closeDialog,
                                  child: const Text("Não"),
                                ),
                              ],
                            ),
                          ),
                          child: Icon(Icons.exit_to_app_sharp),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
        //
      ),
    );
  }
}

class _ForecastIcon extends StatelessWidget {
  final TemperatureFeeling _temperatureFeeling;
  const _ForecastIcon({required TemperatureFeeling forecastClass})
    : _temperatureFeeling = forecastClass;

  @override
  Widget build(BuildContext context) {
    IconData icon = _temperatureFeeling == TemperatureFeeling.hot
        ? Icons.sunny
        : _temperatureFeeling == TemperatureFeeling.mild
        ? Icons.cloud
        : Icons.incomplete_circle_sharp;
    return Icon(icon);
  }
}

class _TemperatureLabel extends StatelessWidget {
  final String _label;
  final int _temperature;
  final Color _color;

  const _TemperatureLabel({
    required String label,
    required int temperature,
    required Color color,
  }) : _color = color,
       _temperature = temperature,
       _label = label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          _label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withAlpha(179),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$_temperature°',
          style: theme.textTheme.titleLarge?.copyWith(
            color: _color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _WeekDayCard extends StatelessWidget {
  final DateTime date;
  final int minTemp;
  final int maxTemp;
  final bool isToday;
  final bool isSelected;
  final VoidCallback onTap;
  final TemperatureFeeling forecastClass;

  const _WeekDayCard({
    required this.date,
    required this.minTemp,
    required this.maxTemp,
    required this.onTap,
    required this.forecastClass,
    this.isToday = false,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = ColorScheme.of(context);
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primaryContainer
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outline.withAlpha(32)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isToday ? 'Today' : DateFormat('EEE').format(date),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isToday
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            _ForecastIcon(forecastClass: forecastClass),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: Text(
                    '$minTemp°',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: isToday
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    '$maxTemp°',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: isToday
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
