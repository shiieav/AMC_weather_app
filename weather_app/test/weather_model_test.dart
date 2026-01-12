import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/models/weather.dart'; // Adjust the import path based on your project structure

void main() {
  group('Weather.fromJson', () {
    test('should correctly parse a JSON object to a Weather model', () {
      // A realistic sample JSON response from OpenWeatherMap for Manila
      const jsonString = '''
      {
        "coord": {
          "lon": 120.9822,
          "lat": 14.6042
        },
        "weather": [
          {
            "id": 803,
            "main": "Clouds",
            "description": "broken clouds",
            "icon": "04d"
          }
        ],
        "base": "stations",
        "main": {
          "temp": 28.3,
          "feels_like": 31.97,
          "temp_min": 27.88,
          "temp_max": 28.3,
          "pressure": 1010,
          "humidity": 74
        },
        "visibility": 10000,
        "wind": {
          "speed": 2.57,
          "deg": 80
        },
        "clouds": {
          "all": 75
        },
        "dt": 1705040180,
        "sys": {
          "type": 1,
          "id": 8160,
          "country": "PH",
          "sunrise": 1705011627,
          "sunset": 1705052402
        },
        "timezone": 28800,
        "id": 1701668,
        "name": "Manila",
        "cod": 200
      }
      ''';

      // Decode the JSON string into a Map
      final Map<String, dynamic> jsonMap = json.decode(jsonString);

      // Use the fromJson factory to create a Weather object
      final weather = Weather.fromJson(jsonMap);

      // Assert that the properties of the Weather object match the JSON data
      expect(weather.city, 'Manila');
      expect(weather.temperature, 28.3);
      expect(weather.description, 'Clouds');
      expect(weather.humidity, 74);
      expect(weather.windSpeed, 2.57);
    });
  });
}
