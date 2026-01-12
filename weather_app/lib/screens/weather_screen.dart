import 'package:flutter/material.dart';
import 'package:weather_app/services/weather_service.dart';
import '../models/weather.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  // Controller: Manages text input from the search field
  final TextEditingController _cityController = TextEditingController();

  // Future: Holds the asynchronous weather data fetch
  late Future<Weather> weatherFuture;

  // Flag: Track if this is the first load
  bool isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    // Load weather for London when app starts
    weatherFuture = WeatherService.getWeather('London');
  }

  // Function: Handle search button press
  void _searchWeather() {
    final String city = _cityController.text.trim();

    // Validate input: Don't allow empty searches
    if (city.isEmpty) {
      _showSnackBar('Please enter a city name', Colors.blue.shade700);
      return;
    }

    // Update the Future to fetch new weather data
    setState(() {
      weatherFuture = WeatherService.getWeather(city);
      isFirstLoad = false;
    });
  }

  // Helper: Display notification messages
  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up: Always dispose controllers to prevent memory leaks
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      // App bar at the top
      appBar: AppBar(
        title: const Text(
          'Weather Weather lang',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue.shade800,
      ),

      // Main content area
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // ===== SEARCH INPUT SECTION =====
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Text input field
                  Expanded(
                    child: TextField(
                      controller: _cityController,
                      decoration: InputDecoration(
                        hintText: 'Enter city name...',
                        hintStyle: TextStyle(color: Colors.blue.shade300),
                        prefixIcon: Icon(Icons.location_on, color: Colors.blue.shade700),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                      ),
                      // Allow pressing Enter to search
                      onSubmitted: (_) => _searchWeather(),
                    ),
                  ),

                  // Search button
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      onPressed: _searchWeather,
                      icon: const Icon(Icons.search),
                      color: Colors.white,
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // ===== WEATHER DISPLAY SECTION =====
            FutureBuilder<Weather>(
              future: weatherFuture,
              builder: (context, snapshot) {
                // STATE 1: Loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 50.0),
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.blue),
                    ),
                  );
                }

                // STATE 2: Error
                if (snapshot.hasError) {
                  return Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.cloud_off,
                            color: Colors.red.shade400,
                            size: 60,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            snapshot.error.toString().replaceFirst('Exception: ', ''),
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // STATE 3: Success
                if (snapshot.hasData) {
                  final weather = snapshot.data!;
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade700, Colors.blue.shade400],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.shade200,
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // City name
                        Text(
                          weather.city,
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Temperature
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${weather.temperature.round()}',
                              style: const TextStyle(
                                fontSize: 100,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1,
                              ),
                            ),
                            const Text(
                              '°C',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Weather description
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            weather.description.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Additional info (Humidity & Wind)
                        IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              WeatherInfoCard(
                                icon: Icons.water_drop_outlined,
                                label: 'HUMIDITY',
                                value: '${weather.humidity}%',
                              ),
                              VerticalDivider(color: Colors.white.withOpacity(0.3), thickness: 1),
                              WeatherInfoCard(
                                icon: Icons.air_rounded,
                                label: 'WIND SPEED',
                                value: '${weather.windSpeed.toStringAsFixed(1)} m/s',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // STATE 4: No data
                return const Center(
                  child: Text('No data available'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ===== REUSABLE WIDGET =====
class WeatherInfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const WeatherInfoCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 12),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
