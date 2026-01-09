import 'package:flutter/material.dart';
import 'package:hexacom_user/features/Community/Widgets/page_horizontal_margin.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hexacom_user/helper/temperature_converter_helper.dart';

import '../../../common/widgets/custom_app_bar_widget.dart';

class WeatherForecastScreen extends StatefulWidget {
  const WeatherForecastScreen({super.key});

  @override
  State<WeatherForecastScreen> createState() => _WeatherForecastScreenState();
}

class _WeatherForecastScreenState extends State<WeatherForecastScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic>? weatherData;
  bool isLoading = true;
  String errorMessage = '';
  Position? currentPosition;
  double latitude = 52.52;
  double longitude = 13.41;
  InAppWebViewController? _webViewController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _getCurrentLocation();
    _initializeWebView();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _initializeWebView() {
    // InAppWebView initialization is handled in the widget itself
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            errorMessage = 'Location permissions are denied';
          });
          fetchWeatherData();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          errorMessage = 'Location permissions are permanently denied';
        });
        fetchWeatherData();
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        currentPosition = position;
        latitude = position.latitude;
        longitude = position.longitude;
      });

      _loadWindyMap();

      await fetchWeatherData();
    } catch (e) {
      print('Location error: ${e.toString()}');
      fetchWeatherData();
      _loadWindyMap();
    }
  }

  void _loadWindyMap() {
    final windyUrl = 'https://embed.windy.com/embed2.html'
        '?lat=$latitude'
        '&lon=$longitude'
        '&detailLat=$latitude'
        '&detailLon=$longitude'
        '&width=650'
        '&height=450'
        '&zoom=8'
        '&level=surface'
        '&overlay=wind'
        '&product=ecmwf'
        '&menu='
        '&message='
        '&marker='
        '&calendar=now'
        '&pressure='
        '&type=map'
        '&location=coordinates'
        '&detail='
        '&metricWind=default'
        '&metricTemp=fahrenheit'
        '&radarRange=-1';

    _webViewController?.loadUrl(
      urlRequest: URLRequest(url: WebUri(windyUrl)),
    );
  }

  Future<void> fetchWeatherData() async {
    try {
      // Use the Open-Meteo API with the correct parameters
      final response = await http.get(Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&hourly=temperature_2m,relative_humidity_2m,wind_speed_10m,wind_gusts_10m&current=temperature_2m,relative_humidity_2m,wind_speed_10m,wind_direction_10m&daily=temperature_2m_max,temperature_2m_min&timezone=auto&temperature_unit=fahrenheit'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('API Response: $data'); // Debug output

        setState(() {
          weatherData = data;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load weather data: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error: ${e.toString()}';
      });
    }
  }

  String formatDateTime(String isoTime, String format) {
    final dateTime = DateTime.parse(isoTime);
    return DateFormat(format).format(dateTime);
  }

  // Get weather icon based on temperature and time of day
  IconData getWeatherIcon(double temp, String time) {
    final hour = DateTime.parse(time).hour;
    final isNight = hour < 6 || hour > 18;

    if (temp > 25) return isNight ? Icons.nightlight_round : Icons.wb_sunny;
    if (temp > 15) return isNight ? Icons.nightlight : Icons.wb_cloudy;
    if (temp > 5) return Icons.cloud;
    return Icons.ac_unit; // Cold/snow
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomAppBarWidget(title: 'Weather Forecast'),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).primaryColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey.shade600,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Windy'),
              ],
              padding: const EdgeInsets.all(4),
              splashBorderRadius: BorderRadius.circular(10),
              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.black.withOpacity(0.1);
                  }
                  return null;
                },
              ),
            ),
          ),

          // TabBarView
          Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildWindyTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : weatherData == null
            ? Center(
                child: Text(errorMessage.isNotEmpty
                    ? errorMessage
                    : 'No weather data available'))
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    // Main weather display
                    PageHorizontalMargin(
                      horizontal: 16,
                      widget: Container(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          children: [
                            _getCurrentWeatherWidget(),
                            Text(
                              TemperatureConverterHelper.formatTemperatureF(
                                  weatherData!['current']['temperature_2m']),
                              style: const TextStyle(
                                fontSize: 70,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Elevation
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.terrain, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  'Elevation: ${weatherData!['elevation']?.toStringAsFixed(0) ?? '0'}m',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  ' (${((weatherData!['elevation'] ?? 0) * 3.28084).toStringAsFixed(0)} ft)',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            // Weather conditions row
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Wind direction
                                  Column(
                                    children: [
                                      Transform.rotate(
                                        angle: (weatherData!['current']
                                                    ['wind_direction_10m'] ??
                                                0) *
                                            3.14159 /
                                            180,
                                        child: const Icon(Icons.navigation),
                                      ),
                                      Text(
                                        '${weatherData!['current']['wind_direction_10m']?.round() ?? '0'}°',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),

                                  // Humidity
                                  Column(
                                    children: [
                                      const Icon(Icons.water_drop),
                                      Text(
                                        weatherData!['current']
                                                    ['relative_humidity_2m'] !=
                                                null
                                            ? '${weatherData!['current']['relative_humidity_2m'].round()}%'
                                            : '65%',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),

                                  // Wind speed
                                  Column(
                                    children: [
                                      const Icon(Icons.air),
                                      Text(
                                        '${weatherData!['current']['wind_speed_10m']?.round() ?? '0'} km/h',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Hourly forecast
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Today',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                formatDateTime(
                                    weatherData!['current']['time'], 'MMM d'),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: SizedBox(
                              height: 140,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 5, // Show next 5 hours
                                itemBuilder: (context, index) {
                                  // Find the current hour index in the hourly data
                                  final currentDateTime = DateTime.parse(
                                      weatherData!['current']['time']);
                                  final List<String> timeList =
                                      List<String>.from(
                                          weatherData!['hourly']['time']);

                                  // Find the nearest hour index in the hourly data
                                  int currentHourIndex = 0;
                                  for (int i = 0; i < timeList.length; i++) {
                                    final hourlyTime =
                                        DateTime.parse(timeList[i]);
                                    if (hourlyTime.isAfter(currentDateTime) ||
                                        hourlyTime.hour ==
                                            currentDateTime.hour) {
                                      currentHourIndex = i;
                                      break;
                                    }
                                  }

                                  // Get the index for this forecast item
                                  final forecastIndex =
                                      currentHourIndex + index;
                                  if (forecastIndex >= timeList.length) {
                                    return const SizedBox
                                        .shrink(); // Skip if we're out of bounds
                                  }

                                  // Get forecast data
                                  final forecastTime = timeList[forecastIndex];
                                  final forecastHour =
                                      DateTime.parse(forecastTime).hour;
                                  final formattedHour = DateFormat('h a')
                                      .format(DateTime.parse(forecastTime));

                                  final forecastTemp = weatherData!['hourly']
                                      ['temperature_2m'][forecastIndex];
                                  final forecastIcon = getWeatherIcon(
                                      forecastTemp, forecastTime);

                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    width: 70,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          index == 0 ? 'Now' : formattedHour,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(height: 12),
                                        Icon(
                                          forecastIcon,
                                          size: 28,
                                          color: Colors.blue.shade600,
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          TemperatureConverterHelper
                                              .formatTemperatureF(forecastTemp),
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Summary section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Summary',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 30),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Calculate min/max temperature from hourly data for today
                                _buildMinMaxTemperatureWidget(),

                                // Elevation reused in summary
                                Column(
                                  children: [
                                    const Icon(Icons.terrain),
                                    const Text('Elevation',
                                        style: TextStyle(fontSize: 16)),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${weatherData!['elevation']?.toStringAsFixed(0) ?? '0'}m',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),

                                // Wind conditions
                                Column(
                                  children: [
                                    const Icon(Icons.air),
                                    // Wind status description based on Beaufort scale
                                    Text(
                                        _getWindDescription(
                                            weatherData!['current']
                                                    ['wind_speed_10m'] ??
                                                0),
                                        style: const TextStyle(fontSize: 16)),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${weatherData!['current']['wind_speed_10m']?.round() ?? '0'} km/h',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              );
  }

  Widget _buildWindyTab() {
    return Column(
      children: [
        // Optional: Add some controls or info here
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.map, color: Colors.blue),
              const SizedBox(width: 8),
              const Text(
                'Live Weather Map',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  _loadWindyMap();
                },
              ),
            ],
          ),
        ),

        // InAppWebView for Windy
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 5,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: InAppWebView(
                initialUrlRequest: URLRequest(
                  url: WebUri('https://embed.windy.com/embed2.html'
                      '?lat=$latitude'
                      '&lon=$longitude'
                      '&detailLat=$latitude'
                      '&detailLon=$longitude'
                      '&width=650'
                      '&height=450'
                      '&zoom=8'
                      '&level=surface'
                      '&overlay=wind'
                      '&product=ecmwf'
                      '&menu='
                      '&message='
                      '&marker=true'
                      '&calendar=now'
                      '&pressure=true'
                      '&type=map'
                      '&location=coordinates'
                      '&detail='
                      '&metricWind=default'
                      '&metricTemp=fahrenheit'
                      '&radarRange=-1'),
                ),
                initialSettings: InAppWebViewSettings(
                  javaScriptEnabled: true,
                  supportZoom: true,
                  builtInZoomControls: false,
                  displayZoomControls: false,
                  allowsInlineMediaPlayback: true,
                  mediaPlaybackRequiresUserGesture: false,
                ),
                onWebViewCreated: (controller) {
                  _webViewController = controller;
                },
                onLoadStart: (controller, url) {
                  // Optional: Show loading indicator
                },
                onLoadStop: (controller, url) async {
                  // Optional: Hide loading indicator
                },
                onReceivedError: (controller, request, error) {
                  print('WebView error: ${error.description}');
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // Custom widget for displaying current weather condition
  Widget _getCurrentWeatherWidget() {
    final currentTemp = weatherData!['current']['temperature_2m'] ?? 20;
    final currentTime = weatherData!['current']['time'];
    final hour = DateTime.parse(currentTime).hour;
    final isNight = hour < 6 || hour > 18;

    // Decide which widget to show based on temperature
    if (currentTemp > 20) {
      return isNight ? _MoonWidget() : SunnyCloudWidget();
    } else if (currentTemp > 10) {
      return _CloudyWidget();
    } else {
      return _ColdWeatherWidget();
    }
  }

  // Get a description of wind conditions based on the Beaufort scale
  String _getWindDescription(double windSpeed) {
    if (windSpeed < 1) return 'Calm';
    if (windSpeed < 6) return 'Light';
    if (windSpeed < 12) return 'Gentle';
    if (windSpeed < 20) return 'Moderate';
    if (windSpeed < 29) return 'Fresh';
    if (windSpeed < 39) return 'Strong';
    if (windSpeed < 50) return 'Gale';
    if (windSpeed < 62) return 'Storm';
    return 'Hurricane';
  }

  // Widget to display min/max temperature
  Widget _buildMinMaxTemperatureWidget() {
    // Extract today's hours from the hourly data
    final List<String> timeList =
        List<String>.from(weatherData!['hourly']['time']);
    final List<double> tempList =
        List<double>.from(weatherData!['hourly']['temperature_2m']);

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Filter data for today only
    List<double> todayTemps = [];
    for (int i = 0; i < timeList.length; i++) {
      final hourlyTime = DateTime.parse(timeList[i]);
      if (hourlyTime.year == today.year &&
          hourlyTime.month == today.month &&
          hourlyTime.day == today.day) {
        todayTemps.add(tempList[i]);
      }
    }

    // Calculate min/max
    double minTemp =
        todayTemps.isNotEmpty ? todayTemps.reduce((a, b) => a < b ? a : b) : 0;
    double maxTemp =
        todayTemps.isNotEmpty ? todayTemps.reduce((a, b) => a > b ? a : b) : 0;

    return Column(
      children: [
        const Icon(Icons.thermostat),
        const Text('Min/Max', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 4),
        Text(
          '${TemperatureConverterHelper.formatTemperatureFValue(minTemp)}°F/${TemperatureConverterHelper.formatTemperatureFValue(maxTemp)}°F',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// Custom widget for the Sun and Cloud icon
class SunnyCloudWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      width: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [Colors.orange, Colors.yellow.shade200],
                center: Alignment.center,
                radius: 0.6,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 10,
                )
              ],
            ),
          ),

          // Cloud (positioned below the sun)
          Positioned(
            bottom: 30,
            child: Container(
              width: 120,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 5,
                    spreadRadius: 2,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom widget for cloudy weather
class _CloudyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      width: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Main cloud
          Container(
            width: 120,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 5,
                  spreadRadius: 2,
                )
              ],
            ),
          ),

          // Second cloud slightly offset
          Positioned(
            top: 50,
            left: 40,
            child: Container(
              width: 100,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 4,
                    spreadRadius: 1,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom widget for night time
class _MoonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      width: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Moon
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.shade100.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 10,
                )
              ],
            ),
          ),

          // Shadow to create crescent
          Positioned(
            top: 0,
            right: 40,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Stars
          Positioned(
            top: 30,
            right: 20,
            child: Icon(Icons.star, size: 12, color: Colors.yellow.shade100),
          ),
          Positioned(
            top: 60,
            left: 30,
            child: Icon(Icons.star, size: 14, color: Colors.yellow.shade100),
          ),
          Positioned(
            bottom: 40,
            right: 50,
            child: Icon(Icons.star, size: 10, color: Colors.yellow.shade100),
          ),
        ],
      ),
    );
  }
}

// Custom widget for cold/snowy weather
class _ColdWeatherWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      width: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Cloud
          Container(
            width: 120,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 5,
                  spreadRadius: 2,
                )
              ],
            ),
          ),

          // Snowflakes
          Positioned(
            bottom: 40,
            left: 50,
            child: Icon(Icons.ac_unit, size: 20, color: Colors.blue.shade100),
          ),
          Positioned(
            bottom: 30,
            right: 60,
            child: Icon(Icons.ac_unit, size: 16, color: Colors.blue.shade100),
          ),
          Positioned(
            bottom: 50,
            right: 40,
            child: Icon(Icons.ac_unit, size: 18, color: Colors.blue.shade100),
          ),
        ],
      ),
    );
  }
}
