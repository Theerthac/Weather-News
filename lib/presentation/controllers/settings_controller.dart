import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {

  var temperatureUnit = 'Celsius'.obs;
  

  final List<String> availableCategories = [
    'business',
    'crime', 
    'domestic',
    'education',
    'entertainment',
    'environment',
    'food',
    'health',
    'lifestyle',
    'other',
    'politics',
    'science',
    'sports',
    'technology',
    'top',
    'tourism',
    'world'
  ];
  
  // Selected categories (max 5)
  var selectedCategories = <String>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }
  
  // Load settings from SharedPreferences
  Future<void> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load temperature unit
      temperatureUnit.value = prefs.getString('temperature_unit') ?? 'Celsius';
      
      // Load selected categories
      List<String>? savedCategories = prefs.getStringList('selected_categories');
      if (savedCategories != null && savedCategories.isNotEmpty) {
        selectedCategories.value = savedCategories;
      } else {
        // Default categories if none selected
        selectedCategories.value = ['technology', 'science', 'health'];
      }
      
      print('Loaded settings - Unit: ${temperatureUnit.value}, Categories: ${selectedCategories.length}');
    } catch (e) {
      print('Error loading settings: $e');
      // Set defaults on error
      temperatureUnit.value = 'Celsius';
      selectedCategories.value = ['technology', 'science', 'health'];
    }
  }
  
  // Save settings to SharedPreferences
  Future<void> saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Save temperature unit
      await prefs.setString('temperature_unit', temperatureUnit.value);
      
      // Save selected categories
      await prefs.setStringList('selected_categories', selectedCategories.toList());
      
      print('Settings saved successfully');
      
      // Show success message
      Get.snackbar(
        'Settings Saved',
        'Your preferences have been updated successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.primaryColor,
        colorText: Get.theme.colorScheme.onPrimary,
        duration: Duration(seconds: 2),
      );
      
    } catch (e) {
      print('Error saving settings: $e');
      Get.snackbar(
        'Error',
        'Failed to save settings. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }
  
  // Toggle temperature unit
  void toggleTemperatureUnit() {
    temperatureUnit.value = temperatureUnit.value == 'Celsius' ? 'Fahrenheit' : 'Celsius';
    saveSettings();
  }
  
  // Set temperature unit
  void setTemperatureUnit(String unit) {
    if (unit == 'Celsius' || unit == 'Fahrenheit') {
      temperatureUnit.value = unit;
      saveSettings();
    }
  }
  
  // Toggle category selection
  void toggleCategory(String category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      if (selectedCategories.length < 5) {
        selectedCategories.add(category);
      } else {
        Get.snackbar(
          'Maximum Limit Reached',
          'You can select maximum 5 categories',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Get.theme.colorScheme.secondary,
          colorText: Get.theme.colorScheme.onSecondary,
        );
        return;
      }
    }
    saveSettings();
  }
  
  // Check if category is selected
  bool isCategorySelected(String category) {
    return selectedCategories.contains(category);
  }
  
  // Get remaining category slots
  int get remainingCategorySlots => 5 - selectedCategories.length;
  
  // Check if can add more categories
  bool get canAddMoreCategories => selectedCategories.length < 5;
  
  // Reset to default settings
  Future<void> resetToDefaults() async {
    temperatureUnit.value = 'Celsius';
    selectedCategories.value = ['technology', 'science', 'health'];
    await saveSettings();
    
    Get.snackbar(
      'Settings Reset',
      'Settings have been reset to default values',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Get.theme.primaryColor,
      colorText: Get.theme.colorScheme.onPrimary,
    );
  }
  
  // Get category display name (capitalize first letter)
  String getCategoryDisplayName(String category) {
    return category[0].toUpperCase() + category.substring(1);
  }
  
  // Get category icon
  String getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'business':
        return '💼';
      case 'crime':
        return '🚨';
      case 'domestic':
        return '🏠';
      case 'education':
        return '📚';
      case 'entertainment':
        return '🎬';
      case 'environment':
        return '🌱';
      case 'food':
        return '🍽️';
      case 'health':
        return '🏥';
      case 'lifestyle':
        return '🌟';
      case 'other':
        return '📰';
      case 'politics':
        return '🏛️';
      case 'science':
        return '🔬';
      case 'sports':
        return '⚽';
      case 'technology':
        return '💻';
      case 'top':
        return '🔝';
      case 'tourism':
        return '✈️';
      case 'world':
        return '🌍';
      default:
        return '📄';
    }
  }
  
  // Convert temperature based on selected unit
  String convertTemperature(double celsius) {
    if (temperatureUnit.value == 'Fahrenheit') {
      double fahrenheit = (celsius * 9 / 5) + 32;
      return '${fahrenheit.round()}°F';
    } else {
      return '${celsius.round()}°C';
    }
  }
  
  // Get temperature unit symbol
  String get temperatureSymbol => temperatureUnit.value == 'Celsius' ? '°C' : '°F';
}