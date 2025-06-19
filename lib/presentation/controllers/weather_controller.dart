import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:weatherandnewsaggregatorapp/data/model/weather_model.dart';

// class WeatherController extends GetxController {
//   // Observable variables
//   var isLoading = false.obs;
//   var weatherData = Rxn<WeatherModel>();
//   var errorMessage = ''.obs;
//   var currentCity = 'New York'.obs;
  
//   // Use your actual API key here
//   final String apiKey = '1f30f3e7d777c0a85b23abd3bd2cf90d';
//   final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  
//   @override
//   void onInit() {
//     super.onInit();
//     // Add a slight delay to prevent immediate API call on app start
//     Future.delayed(Duration(milliseconds: 500), () {
//       fetchWeatherByCity(currentCity.value);
//     });
//   }
  
//   // Fetch weather by city name
//   Future<void> fetchWeatherByCity(String cityName) async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';
      
//       final url = '$baseUrl?q=$cityName&appid=$apiKey&units=metric';
//       print('Fetching weather from: $url'); // Debug log
      
//       final response = await http.get(
//         Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//       ).timeout(Duration(seconds: 10)); // Add timeout
      
//       print('Response status: ${response.statusCode}'); // Debug log
//       print('Response body: ${response.body}'); // Debug log
      
//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body);
//         weatherData.value = WeatherModel.fromJson(jsonData);
//         currentCity.value = weatherData.value?.name ?? cityName;
//         print('Weather data updated successfully'); // Debug log
//       } else {
//         final errorData = json.decode(response.body);
//         errorMessage.value = errorData['message'] ?? 'Failed to fetch weather data';
//         print('API Error: ${errorMessage.value}'); // Debug log
//       }
//     } catch (e) {
//       errorMessage.value = 'Network error: ${e.toString()}';
//       print('Exception: ${e.toString()}'); // Debug log
//     } finally {
//       isLoading.value = false;
//     }
//   }
  
//   // Fetch weather by coordinates
//   Future<void> fetchWeatherByCoordinates(double lat, double lon) async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';
      
//       final url = '$baseUrl?lat=$lat&lon=$lon&appid=$apiKey&units=metric';
//       print('Fetching weather by coordinates: $url'); // Debug log
      
//       final response = await http.get(
//         Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//       ).timeout(Duration(seconds: 10));
      
//       print('Response status: ${response.statusCode}'); // Debug log
      
//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body);
//         weatherData.value = WeatherModel.fromJson(jsonData);
//         currentCity.value = weatherData.value?.name ?? 'Unknown';
//         print('Weather data updated successfully'); // Debug log
//       } else {
//         final errorData = json.decode(response.body);
//         errorMessage.value = errorData['message'] ?? 'Failed to fetch weather data';
//       }
//     } catch (e) {
//       errorMessage.value = 'Network error: ${e.toString()}';
//       print('Exception: ${e.toString()}'); // Debug log
//     } finally {
//       isLoading.value = false;
//     }
//   }
  
//   // Get current location and fetch weather
//   Future<void> fetchWeatherByCurrentLocation() async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';
      
//       // Check if location services are enabled
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         errorMessage.value = 'Location services are disabled';
//         isLoading.value = false;
//         return;
//       }
      
//       // Check location permission
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           errorMessage.value = 'Location permission denied';
//           isLoading.value = false;
//           return;
//         }
//       }
      
//       if (permission == LocationPermission.deniedForever) {
//         errorMessage.value = 'Location permission permanently denied';
//         isLoading.value = false;
//         return;
//       }
      
//       // Get current position
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//         timeLimit: Duration(seconds: 10),
//       );
      
//       print('Current position: ${position.latitude}, ${position.longitude}'); // Debug log
      
//       // Fetch weather using coordinates
//       await fetchWeatherByCoordinates(position.latitude, position.longitude);
      
//     } catch (e) {
//       errorMessage.value = 'Error getting location: ${e.toString()}';
//       print('Location error: ${e.toString()}'); // Debug log
//       isLoading.value = false;
//     }
//   }
  
//   // Refresh weather data
//   Future<void> refreshWeather() async {
//     if (currentCity.value.isNotEmpty) {
//       await fetchWeatherByCity(currentCity.value);
//     }
//   }
  
//   // Get weather icon URL
//   String getWeatherIconUrl(String iconCode) {
//     return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
//   }
  
//   // Get temperature in Celsius
//   String getTemperatureString() {
//     if (weatherData.value?.main?.temp != null) {
//       return '${weatherData.value!.main!.temp!.round()}°C';
//     }
//     return '--°C'; // Better fallback
//   }
  
//   // Get weather description
//   String getWeatherDescription() {
//     if (weatherData.value?.weather?.isNotEmpty == true) {
//       return weatherData.value!.weather!.first.description ?? 'No description';
//     }
//     return 'No description';
//   }
  
//   // Get weather icon based on weather condition
//   IconData getWeatherIcon() {
//     if (weatherData.value?.weather?.isNotEmpty == true) {
//       final weatherMain = weatherData.value!.weather!.first.main?.toLowerCase();
//       switch (weatherMain) {
//         case 'clear':
//           return Icons.wb_sunny;
//         case 'clouds':
//           return Icons.cloud;
//         case 'rain':
//           return Icons.water_drop;
//         case 'drizzle':
//           return Icons.grain;
//         case 'snow':
//           return Icons.ac_unit;
//         case 'thunderstorm':
//           return Icons.flash_on;
//         case 'mist':
//         case 'fog':
//           return Icons.blur_on;
//         default:
//           return Icons.wb_sunny;
//       }
//     }
//     return Icons.wb_sunny;
//   }
  
//   // Helper method to check if weather data is available
//   bool get hasWeatherData => weatherData.value != null;
  
//   // Get current weather condition for UI styling
//   String get currentWeatherCondition {
//     if (weatherData.value?.weather?.isNotEmpty == true) {
//       return weatherData.value!.weather!.first.main?.toLowerCase() ?? 'clear';
//     }
//     return 'clear';
//   }
// }


class WeatherController extends GetxController {
  // Observable variables
  var isLoading = false.obs;
  var weatherData = Rxn<WeatherModel>();
  var errorMessage = ''.obs;
  var currentCity = 'New York'.obs;
  
  // Use your actual API key here
  final String apiKey = '1f30f3e7d777c0a85b23abd3bd2cf90d';
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  
  @override
  void onInit() {
    super.onInit();
    // Automatically fetch current location weather on app start
    Future.delayed(Duration(milliseconds: 500), () {
      fetchWeatherByCurrentLocation();
    });
  }
  
  // Fetch weather by city name
  Future<void> fetchWeatherByCity(String cityName) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final url = '$baseUrl?q=$cityName&appid=$apiKey&units=metric';
      print('Fetching weather from: $url'); // Debug log
      
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(Duration(seconds: 10)); // Add timeout
      
      print('Response status: ${response.statusCode}'); // Debug log
      print('Response body: ${response.body}'); // Debug log
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        weatherData.value = WeatherModel.fromJson(jsonData);
        currentCity.value = weatherData.value?.name ?? cityName;
        print('Weather data updated successfully'); // Debug log
      } else {
        final errorData = json.decode(response.body);
        errorMessage.value = errorData['message'] ?? 'Failed to fetch weather data';
        print('API Error: ${errorMessage.value}'); // Debug log
      }
    } catch (e) {
      errorMessage.value = 'Network error: ${e.toString()}';
      print('Exception: ${e.toString()}'); // Debug log
    } finally {
      isLoading.value = false;
    }
  }
  
  // Fetch weather by coordinates
  Future<void> fetchWeatherByCoordinates(double lat, double lon) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final url = '$baseUrl?lat=$lat&lon=$lon&appid=$apiKey&units=metric';
      print('Fetching weather by coordinates: $url'); // Debug log
      
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(Duration(seconds: 10));
      
      print('Response status: ${response.statusCode}'); // Debug log
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        weatherData.value = WeatherModel.fromJson(jsonData);
        currentCity.value = weatherData.value?.name ?? 'Unknown';
        print('Weather data updated successfully'); // Debug log
      } else {
        final errorData = json.decode(response.body);
        errorMessage.value = errorData['message'] ?? 'Failed to fetch weather data';
      }
    } catch (e) {
      errorMessage.value = 'Network error: ${e.toString()}';
      print('Exception: ${e.toString()}'); // Debug log
    } finally {
      isLoading.value = false;
    }
  }
  
  // Get current location and fetch weather
  Future<void> fetchWeatherByCurrentLocation() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Show dialog to enable location services
        Get.snackbar(
          'Location Services Disabled',
          'Please enable location services to get weather for your current location',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        
        // Try to open location settings
        bool opened = await Geolocator.openLocationSettings();
        if (!opened) {
          errorMessage.value = 'Location services are disabled. Using default location.';
          await fetchWeatherByCity('Vellore'); // Your location
          return;
        }
        
        // Check again after settings
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          errorMessage.value = 'Location services still disabled. Using default location.';
          await fetchWeatherByCity('Vellore');
          return;
        }
      }
      
      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar(
            'Location Permission Denied',
            'Please grant location permission to get weather for your current location',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          errorMessage.value = 'Location permission denied. Using default location.';
          await fetchWeatherByCity('Vellore');
          return;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          'Location Permission Required',
          'Please enable location permission in app settings',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 5),
        );
        
        // Try to open app settings
        bool opened = await Geolocator.openAppSettings();
        errorMessage.value = 'Location permission permanently denied. Using default location.';
        await fetchWeatherByCity('Vellore');
        return;
      }
      
      // Show loading message
      Get.snackbar(
        'Getting Location',
        'Please wait while we get your current location...',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
      
      // Get current position with better settings
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 20), // Increased timeout
      );
      
      print('Current position: ${position.latitude}, ${position.longitude}'); // Debug log
      
      // Get address from coordinates for verification
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, 
          position.longitude
        );
        if (placemarks.isNotEmpty) {
          String locationInfo = '${placemarks.first.locality}, ${placemarks.first.administrativeArea}';
          print('Detected location: $locationInfo');
        }
      } catch (e) {
        print('Geocoding error: $e');
      }
      
      // Fetch weather using coordinates
      await fetchWeatherByCoordinates(position.latitude, position.longitude);
      
      if (weatherData.value != null) {
        Get.snackbar(
          'Location Found',
          'Weather updated for your current location: ${currentCity.value}',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );
      }
      
    } catch (e) {
      print('Location error: ${e.toString()}'); // Debug log
      
      String errorMsg = 'Error getting location: ${e.toString()}';
      if (e.toString().contains('timeout')) {
        errorMsg = 'Location request timed out. Please try again or check your GPS signal.';
      } else if (e.toString().contains('network')) {
        errorMsg = 'Network error while getting location. Please check your internet connection.';
      }
      
      Get.snackbar(
        'Location Error',
        errorMsg,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
      
      errorMessage.value = '$errorMsg Using default location.';
      isLoading.value = false;
      // Fallback to your location
      await fetchWeatherByCity('Vellore');
    }
  }
  
  // Refresh weather data
  Future<void> refreshWeather() async {
    if (currentCity.value.isNotEmpty) {
      await fetchWeatherByCity(currentCity.value);
    } else {
      await fetchWeatherByCurrentLocation();
    }
  }
  
  // Get weather icon URL
  String getWeatherIconUrl(String iconCode) {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }
  
  // Get temperature in Celsius
  String getTemperatureString() {
    if (weatherData.value?.main?.temp != null) {
      return '${weatherData.value!.main!.temp!.round()}°C';
    }
    return '--°C'; // Better fallback
  }
  
  // Get weather description
  String getWeatherDescription() {
    if (weatherData.value?.weather?.isNotEmpty == true) {
      return weatherData.value!.weather!.first.description ?? 'No description';
    }
    return 'No description';
  }
  
  // Get weather icon based on weather condition
  IconData getWeatherIcon() {
    if (weatherData.value?.weather?.isNotEmpty == true) {
      final weatherMain = weatherData.value!.weather!.first.main?.toLowerCase();
      switch (weatherMain) {
        case 'clear':
          return Icons.wb_sunny;
        case 'clouds':
          return Icons.cloud;
        case 'rain':
          return Icons.water_drop;
        case 'drizzle':
          return Icons.grain;
        case 'snow':
          return Icons.ac_unit;
        case 'thunderstorm':
          return Icons.flash_on;
        case 'mist':
        case 'fog':
          return Icons.blur_on;
        default:
          return Icons.wb_sunny;
      }
    }
    return Icons.wb_sunny;
  }
  
  // Helper method to check if weather data is available
  bool get hasWeatherData => weatherData.value != null;
  
  // Get current weather condition for UI styling
  String get currentWeatherCondition {
    if (weatherData.value?.weather?.isNotEmpty == true) {
      return weatherData.value!.weather!.first.main?.toLowerCase() ?? 'clear';
    }
    return 'clear';
  }
  
}