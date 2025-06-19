import 'package:flutter/material.dart';
import 'package:weatherandnewsaggregatorapp/data/colors/colors.dart';
import 'package:weatherandnewsaggregatorapp/data/components/custom_apptext.dart';

// class WeatherdetailScreen extends StatelessWidget {
//   const WeatherdetailScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: background,
//       appBar: AppBar(
//         backgroundColor: background,
//         centerTitle: true,
//         title: AppText(
//           'Current Weather',
//           color: textPrimary,
//           size: 22,
//           weight: FontWeight.w700,
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 15),
//         child: Column(
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.2),
//                     spreadRadius: 2,
//                     blurRadius: 3,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   children: [
//                     SizedBox(height: 30),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         AppText(
//                           'New York',
//                           color: const Color.fromRGBO(33, 33, 33, 1),
//                           size: 18,
//                           weight: FontWeight.w600,
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 10),
//                     AppText(
//                       'Sunny',
//                       color: textPrimary,
//                       size: 14,
//                       weight: FontWeight.w600,
//                     ),
//                     const SizedBox(height: 20),
//                     Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         Icon(Icons.wb_sunny, color: sunYellow, size: 95),
//                         Positioned(
//                           left: 0,
//                           bottom: 5,

//                           top: 12,
//                           child: Icon(
//                             Icons.cloud,
//                             color: Colors.blue[200],
//                             size: 60,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     AppText(
//                       '27°C',
//                       size: 60,
//                       weight: FontWeight.w400,
//                       color: textPrimary,
//                     ),
//                     SizedBox(height: 20),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 12),
//                       child: Divider(),
//                     ),
//                     SizedBox(height: 20),
//                     Row(
//                       children: [
//                         AppText(
//                           'Humidity',
//                           color: textPrimary,
//                           size: 16,
//                           weight: FontWeight.w600,
//                         ),
//                         Spacer(),
//                         AppText(
//                           '60%',
//                           color: textPrimary,
//                           size: 16,
//                           weight: FontWeight.w600,
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 10),
//                     Row(
//                       children: [
//                         AppText(
//                           'Wind',
//                           color: textPrimary,
//                           size: 16,
//                           weight: FontWeight.w600,
//                         ),
//                         Spacer(),
//                         AppText(
//                           '60%',
//                           color: textPrimary,
//                           size: 16,
//                           weight: FontWeight.w600,
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 10),
//                     Row(
//                       children: [
//                         AppText(
//                           'Pressure',
//                           color: textPrimary,
//                           size: 16,
//                           weight: FontWeight.w600,
//                         ),
//                         Spacer(),
//                         AppText(
//                           '60%',
//                           color: textPrimary,
//                           size: 16,
//                           weight: FontWeight.w600,
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 30),
//                   ],
//                 ),
//               ),
//             ),

//             // Container(
//             //   decoration: BoxDecoration(
//             //     color: Colors.white,
//             //     borderRadius: BorderRadius.circular(20),
//             //     boxShadow: [
//             //       BoxShadow(
//             //         color: Colors.grey.withOpacity(0.2),
//             //         spreadRadius: 2,
//             //         blurRadius: 3,
//             //         offset: const Offset(0, 2),
//             //       ),
//             //     ],
//             //   ),
//             //   child: Padding(
//             //     padding: const EdgeInsets.all(20),
//             //     child: Column(
//             //       children: [

//             //       ],
//             //     ),
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weatherandnewsaggregatorapp/data/colors/colors.dart';
import 'package:weatherandnewsaggregatorapp/data/components/custom_apptext.dart';
import 'package:weatherandnewsaggregatorapp/presentation/controllers/weather_controller.dart';

class WeatherdetailScreen extends StatelessWidget {
  const WeatherdetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the existing weather controller instance
    final WeatherController weatherController = Get.find<WeatherController>();

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        centerTitle: true,
        title: AppText(
          'Weather Details',
          color: textPrimary,
          size: 22,
          weight: FontWeight.w700,
        ),

      
      ),
      body: Obx(() {
        if (weatherController.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: sunYellow),
                const SizedBox(height: 16),
                AppText(
                  'Loading weather details...',
                  color: textSecondary,
                  size: 14,
                ),
              ],
            ),
          );
        }

        if (weatherController.errorMessage.value.isNotEmpty &&
            !weatherController.hasWeatherData) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                AppText(
                  'Error loading weather data',
                  color: textPrimary,
                  size: 18,
                  weight: FontWeight.w600,
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: AppText(
                    weatherController.errorMessage.value,
                    color: textSecondary,
                    size: 14,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => weatherController.refreshWeather(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: sunYellow,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Retry'),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Main weather card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),

                      // City name
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_on,
                            color: textSecondary,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          AppText(
                            weatherController.currentCity.value,
                            color: textPrimary,
                            size: 20,
                            weight: FontWeight.w600,
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Weather description
                      AppText(
                        weatherController.getWeatherDescription().toUpperCase(),
                        color: textSecondary,
                        size: 14,
                        weight: FontWeight.w500,
                      ),

                      const SizedBox(height: 20),

                      // Weather icon
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            weatherController.getWeatherIcon(),
                            color: sunYellow,
                            size: 100,
                          ),
                          if (weatherController.currentWeatherCondition ==
                              'clouds')
                            Positioned(
                              left: 0,
                              bottom: 5,
                              top: 12,
                              child: Icon(
                                Icons.cloud,
                                color: Colors.blue[200],
                                size: 70,
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Temperature
                      AppText(
                        weatherController.getTemperatureString(),
                        size: 64,
                        weight: FontWeight.w300,
                        color: textPrimary,
                      ),

                      // Feels like temperature
                      if (weatherController
                              .weatherData
                              .value
                              ?.main
                              ?.feelsLike !=
                          null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: AppText(
                            'Feels like ${weatherController.weatherData.value!.main!.feelsLike!.round()}°C',
                            color: textSecondary,
                            size: 14,
                          ),
                        ),

                      const SizedBox(height: 24),

                      // Divider
                      Divider(color: Colors.grey[300]),

                      const SizedBox(height: 24),

                      // Weather details
                      _buildWeatherDetailRow(
                        'Humidity',
                        '${weatherController.weatherData.value?.main?.humidity ?? '--'}%',
                        Icons.water_drop,
                      ),

                      const SizedBox(height: 16),

                      _buildWeatherDetailRow(
                        'Wind Speed',
                        '${weatherController.weatherData.value?.wind?.speed?.toStringAsFixed(1) ?? '--'} m/s',
                        Icons.air,
                      ),

                      const SizedBox(height: 16),

                      _buildWeatherDetailRow(
                        'Pressure',
                        '${weatherController.weatherData.value?.main?.pressure ?? '--'} hPa',
                        Icons.compress,
                      ),

                      const SizedBox(height: 16),

                      _buildWeatherDetailRow(
                        'Visibility',
                        '${weatherController.weatherData.value?.visibility != null ? (weatherController.weatherData.value!.visibility! / 1000).toStringAsFixed(1) : '--'} km',
                        Icons.visibility,
                      ),

                      const SizedBox(height: 16),

                      // Min/Max temperature row
                      if (weatherController.weatherData.value?.main?.tempMin !=
                              null &&
                          weatherController.weatherData.value?.main?.tempMax !=
                              null)
                        Row(
                          children: [
                            Expanded(
                              child: _buildTemperatureCard(
                                'Min Temp',
                                '${weatherController.weatherData.value!.main!.tempMin!.round()}°C',
                                Icons.thermostat,
                                Colors.blue[100]!,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildTemperatureCard(
                                'Max Temp',
                                '${weatherController.weatherData.value!.main!.tempMax!.round()}°C',
                                Icons.thermostat,
                                Colors.red[100]!,
                              ),
                            ),
                          ],
                        ),

                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Additional info card
              if (weatherController.weatherData.value?.clouds != null ||
                  weatherController.weatherData.value?.sys != null)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          'Additional Information',
                          color: textPrimary,
                          size: 18,
                          weight: FontWeight.w600,
                        ),

                        const SizedBox(height: 16),

                        if (weatherController.weatherData.value?.clouds?.all !=
                            null)
                          _buildWeatherDetailRow(
                            'Cloudiness',
                            '${weatherController.weatherData.value!.clouds!.all}%',
                            Icons.cloud,
                          ),

                        if (weatherController.weatherData.value?.sys?.country !=
                            null)
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: _buildWeatherDetailRow(
                              'Country',
                              weatherController
                                  .weatherData
                                  .value!
                                  .sys!
                                  .country!,
                              Icons.flag,
                            ),
                          ),

                        if (weatherController.weatherData.value?.wind?.deg !=
                            null)
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: _buildWeatherDetailRow(
                              'Wind Direction',
                              '${weatherController.weatherData.value!.wind!.deg}°',
                              Icons.navigation,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 30),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildWeatherDetailRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: sunYellow, size: 20),
        const SizedBox(width: 12),
        AppText(label, color: textPrimary, size: 16, weight: FontWeight.w500),
        const Spacer(),
        AppText(value, color: textPrimary, size: 16, weight: FontWeight.w600),
      ],
    );
  }

  Widget _buildTemperatureCard(
    String label,
    String value,
    IconData icon,
    Color backgroundColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: textPrimary, size: 24),
          const SizedBox(height: 8),
          AppText(label, color: textPrimary, size: 12, weight: FontWeight.w500),
          const SizedBox(height: 4),
          AppText(value, color: textPrimary, size: 16, weight: FontWeight.w600),
        ],
      ),
    );
  }
}
