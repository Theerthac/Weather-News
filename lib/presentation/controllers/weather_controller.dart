import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:weatherandnewsaggregatorapp/data/model/weather_model.dart';

class WeatherController extends GetxController {
  var isLoading = false.obs;
  var weatherData = Rxn<WeatherModel>();
  var errorMessage = ''.obs;
  var currentCity = 'New York'.obs;
  
  var currentTemperature = 0.0.obs;
  var feelsLike = 0.0.obs;
  var humidity = 0.obs;
  var windSpeed = 0.0.obs;
  
  final String apiKey = '1f30f3e7d777c0a85b23abd3bd2cf90d';
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  
  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(milliseconds: 500), () {
      fetchWeatherByCurrentLocation();
    });
  }
  
  void _updateWeatherValues() {
    if (weatherData.value != null) {
      currentTemperature.value = weatherData.value!.main?.temp ?? 0.0;
      feelsLike.value = weatherData.value!.main?.feelsLike ?? 0.0;
      humidity.value = weatherData.value!.main?.humidity ?? 0;
      windSpeed.value = weatherData.value!.wind?.speed ?? 0.0;
    }
  }
  
  Future<void> fetchWeatherByCity(String cityName) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final url = '$baseUrl?q=$cityName&appid=$apiKey&units=metric';
      print('Fetching weather from: $url'); 
      
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(Duration(seconds: 10)); 
      
      print('Response status: ${response.statusCode}'); 
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        weatherData.value = WeatherModel.fromJson(jsonData);
        currentCity.value = weatherData.value?.name ?? cityName;
        _updateWeatherValues(); 
        print('Weather data updated successfully'); 
      } else {
        final errorData = json.decode(response.body);
        errorMessage.value = errorData['message'] ?? 'Failed to fetch weather data';
        print('API Error: ${errorMessage.value}'); 
      }
    } catch (e) {
      errorMessage.value = 'Network error: ${e.toString()}';
      print('Exception: ${e.toString()}'); 
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> fetchWeatherByCoordinates(double lat, double lon) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final url = '$baseUrl?lat=$lat&lon=$lon&appid=$apiKey&units=metric';
      print('Fetching weather by coordinates: $url'); 
      
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(Duration(seconds: 10));
      
      print('Response status: ${response.statusCode}'); 
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        weatherData.value = WeatherModel.fromJson(jsonData);
        currentCity.value = weatherData.value?.name ?? 'Unknown';
        _updateWeatherValues(); 
        print('Weather data updated successfully'); 
      } else {
        final errorData = json.decode(response.body);
        errorMessage.value = errorData['message'] ?? 'Failed to fetch weather data';
      }
    } catch (e) {
      errorMessage.value = 'Network error: ${e.toString()}';
      print('Exception: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> fetchWeatherByCurrentLocation() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar(
          'Location Services Disabled',
          'Please enable location services to get weather for your current location',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        
        bool opened = await Geolocator.openLocationSettings();
        if (!opened) {
          errorMessage.value = 'Location services are disabled. Using default location.';
          await fetchWeatherByCity('Kozhikode'); 
          return;
        }
        
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          errorMessage.value = 'Location services still disabled. Using default location.';
          await fetchWeatherByCity('Kozhikode');
          return;
        }
      }
      
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
          await fetchWeatherByCity('Kozhikode');
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
        

        errorMessage.value = 'Location permission permanently denied. Using default location.';
        await fetchWeatherByCity('Vellore');
        return;
      }
      
      Get.snackbar(
        'Getting Location',
        'Please wait while we get your current location...',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
      
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 20), 
      );
      
      print('Current position: ${position.latitude}, ${position.longitude}'); 
      
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
      print('Location error: ${e.toString()}'); 
      
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
      await fetchWeatherByCity('Vellore');
    }
  }
  
  Future<void> refreshWeather() async {
    if (currentCity.value.isNotEmpty) {
      await fetchWeatherByCity(currentCity.value);
    } else {
      await fetchWeatherByCurrentLocation();
    }
  }
  
  String getWeatherIconUrl(String iconCode) {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }
  
  String getTemperatureString() {
    if (weatherData.value?.main?.temp != null) {
      return '${weatherData.value!.main!.temp!.round()}°C';
    }
    return '--°C';
  }
  
  String getWeatherDescription() {
    if (weatherData.value?.weather?.isNotEmpty == true) {
      return weatherData.value!.weather!.first.description ?? 'No description';
    }
    return 'No description';
  }
  
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
  
  bool get hasWeatherData => weatherData.value != null;
  
  String get currentWeatherCondition {
    if (weatherData.value?.weather?.isNotEmpty == true) {
      return weatherData.value!.weather!.first.main?.toLowerCase() ?? 'clear';
    }
    return 'clear';
  }
  
  String get weatherConditionText {
    if (weatherData.value?.weather?.isNotEmpty == true) {
      return weatherData.value!.weather!.first.main ?? 'Clear';
    }
    return 'Clear';
  }
  
  String get weatherIconCode {
    if (weatherData.value?.weather?.isNotEmpty == true) {
      return weatherData.value!.weather!.first.icon ?? '01d';
    }
    return '01d';
  }
  
  double get pressure {
    return weatherData.value?.main?.pressure?.toDouble() ?? 0.0;
  }
  
  double get visibility {
    return weatherData.value?.visibility?.toDouble() ?? 0.0;
  }
  
  int get cloudiness {
    return weatherData.value?.clouds?.all ?? 0;
  }
  
  String get sunrise {
    if (weatherData.value?.sys?.sunrise != null) {
      final DateTime sunriseTime = DateTime.fromMillisecondsSinceEpoch(
        weatherData.value!.sys!.sunrise! * 1000
      );
      return '${sunriseTime.hour.toString().padLeft(2, '0')}:${sunriseTime.minute.toString().padLeft(2, '0')}';
    }
    return '--:--';
  }
  
  String get sunset {
    if (weatherData.value?.sys?.sunset != null) {
      final DateTime sunsetTime = DateTime.fromMillisecondsSinceEpoch(
        weatherData.value!.sys!.sunset! * 1000
      );
      return '${sunsetTime.hour.toString().padLeft(2, '0')}:${sunsetTime.minute.toString().padLeft(2, '0')}';
    }
    return '--:--';
  }
  
  String get windDirection {
    if (weatherData.value?.wind?.deg != null) {
      final degrees = weatherData.value!.wind!.deg!;
      const directions = ['N', 'NNE', 'NE', 'ENE', 'E', 'ESE', 'SE', 'SSE', 
                         'S', 'SSW', 'SW', 'WSW', 'W', 'WNW', 'NW', 'NNW'];
      final index = ((degrees + 11.25) / 22.5).floor() % 16;
      return directions[index];
    }
    return 'N';
  }
}