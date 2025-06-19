// import 'package:flutter/material.dart';
// import 'package:weatherandnewsaggregatorapp/data/colors/colors.dart';
// import 'package:weatherandnewsaggregatorapp/data/components/custom_apptext.dart';
// import 'package:weatherandnewsaggregatorapp/presentation/pages/home_screen/components/weatherdetail_screen.dart';
// import 'package:weatherandnewsaggregatorapp/presentation/pages/settings_screen/settings_screen.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: background,
//       appBar: AppBar(
//         backgroundColor: background,
//         centerTitle: true,
//         title: AppText(
//           'Weather and News',
//           color: textPrimary,
//           size: 22,
//           weight: FontWeight.w700,
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 20),
//             InkWell(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const WeatherdetailScreen(),
//                   ),
//                 );
//               },
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       Icon(Icons.wb_sunny, color: sunYellow, size: 55),
//                       Positioned(
//                         left: 0,
//                         bottom: 5,

//                         top: 12,
//                         child: Icon(
//                           Icons.cloud,
//                           color: Colors.blue[200],
//                           size: 40,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(width: 8),
//                   AppText(
//                     '27°C',
//                     size: 50,
//                     weight: FontWeight.w400,
//                     color: textPrimary,
//                   ),
//                 ],
//               ),
//             ),

//             // Row(
//             //   children: [
//             const SizedBox(height: 3),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 AppText(
//                   'New York',
//                   size: 16,
//                   weight: FontWeight.w600,
//                   color: textPrimary,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: Image.network(
//                     'https://picsum.photos/seed/news/60/60',
//                     width: double.infinity,
//                     height: 180,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 2),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: AppText(
//                 'Head lines..............',
//                 color: textPrimary,
//                 size: 18,
//                 weight: FontWeight.w600,
//               ),
//             ),

//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: AppText(
//                 'Short description of the article...',
//                 size: 15,
//                 color: textSecondary,
//               ),
//             ),
//             // 🗞️ News List
//             ListView.builder(
//               physics: const NeverScrollableScrollPhysics(),
//               shrinkWrap: true,
//               itemCount: 5,
//               itemBuilder:
//                   (context, index) => Card(
//                     margin: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 6,
//                     ),
//                     elevation: 1,
//                     child: ListTile(
//                       leading: Container(
//                         width: 60,
//                         height: 60,
//                         color: Colors.grey[300],
//                       ),
//                       title: AppText(
//                         'News Headline $index',
//                         size: 16,
//                         weight: FontWeight.w500,
//                       ),
//                       subtitle: AppText(
//                         'Short description of the article...',
//                         size: 14,
//                         color: textSecondary,
//                       ),
//                       onTap: () {
//                         // Navigate to News Detail
//                       },
//                     ),
//                   ),
//             ),
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
import 'package:weatherandnewsaggregatorapp/presentation/pages/home_screen/components/weatherdetail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize weather controller
    final WeatherController weatherController = Get.put(WeatherController());

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        centerTitle: true,
        elevation: 0,
        title: AppText(
          'Weather and News',
          color: textPrimary,
          size: 22,
          weight: FontWeight.w700,
        ),
        actions: [
          // Only location button, no refresh button
          Obx(
            () => IconButton(
              icon:
                  weatherController.isLoading.value
                      ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: textPrimary,
                        ),
                      )
                      : Icon(Icons.my_location, color: textPrimary),
              onPressed:
                  weatherController.isLoading.value
                      ? null
                      : () {
                        // Show confirmation dialog
                        Get.dialog(
                          AlertDialog(
                            title: Text('Get Current Location'),
                            content: Text(
                              'Do you want to get weather for your current location?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Get.back(),
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.back();
                                  weatherController
                                      .fetchWeatherByCurrentLocation();
                                },
                                child: Text('Yes'),
                              ),
                            ],
                          ),
                        );
                      },
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => weatherController.refreshWeather(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Weather Section
              _buildWeatherSection(weatherController, context),

              const SizedBox(height: 20),

              // Search City Section
              _buildSearchSection(weatherController),

              // const SizedBox(height: 20),

              // Location Button Section
              //  _buildLocationButtonSection(weatherController),
              const SizedBox(height: 20),

              // News Section
              _buildNewsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherSection(
    WeatherController weatherController,
    BuildContext context,
  ) {
    return Obx(() {
      if (weatherController.isLoading.value) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              children: [
                CircularProgressIndicator(),
                const SizedBox(height: 16),
                AppText('Loading weather...', color: textSecondary, size: 14),
              ],
            ),
          ),
        );
      }

      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const WeatherdetailScreen(),
            ),
          );
        },
        child: Column(
          children: [
            // Weather Icon and Temperature
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      weatherController.getWeatherIcon(),
                      color: sunYellow,
                      size: 55,
                    ),
                    if (weatherController.currentWeatherCondition == 'clouds')
                      Positioned(
                        left: 0,
                        bottom: 5,
                        top: 12,
                        child: Icon(
                          Icons.cloud,
                          color: Colors.blue[200],
                          size: 40,
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 8),
                AppText(
                  weatherController.getTemperatureString(),
                  size: 50,
                  weight: FontWeight.w400,
                  color: textPrimary,
                ),
              ],
            ),

            // City Name and Weather Description
            const SizedBox(height: 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_on, color: textSecondary, size: 16),
                const SizedBox(width: 4),
                AppText(
                  weatherController.currentCity.value,
                  size: 16,
                  weight: FontWeight.w600,
                  color: textPrimary,
                ),
              ],
            ),

            // Weather Description
            const SizedBox(height: 5),
            AppText(
              weatherController.getWeatherDescription().toUpperCase(),
              size: 12,
              weight: FontWeight.w400,
              color: textSecondary,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSearchSection(WeatherController weatherController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search city...',
          hintStyle: TextStyle(color: textSecondary),

          prefixIcon: Icon(Icons.search, color: textSecondary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: sunYellow),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        onSubmitted: (city) {
          if (city.trim().isNotEmpty) {
            weatherController.fetchWeatherByCity(city.trim());
          }
        },
      ),
    );
  }

  Widget _buildNewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AppText(
            'News Headlines',
            color: textPrimary,
            size: 18,
            weight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),

        // Featured News
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            decoration: BoxDecoration(
              color: colorWhite,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    'https://picsum.photos/seed/news/400/200',
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 180,
                        color: colorWhite,
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          'Breaking News Headlines',
                          color: textPrimary,
                          size: 16,
                          weight: FontWeight.w600,
                        ),
                        const SizedBox(height: 4),
                        AppText(
                          'Short description of the featured article...',
                          size: 14,
                          color: textSecondary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 8),

        // News List
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 5,
          itemBuilder:
              (context, index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Card(
                  elevation: 1,
                  color: colorWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),

                    leading: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.article, color: Colors.grey),
                    ),
                    title: AppText(
                      'News Headline ${index + 1}',
                      size: 15,
                      weight: FontWeight.w500,
                      color: textPrimary,
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: AppText(
                        'Short description of the article...',
                        size: 13,
                        color: textSecondary,
                      ),
                    ),
                    onTap: () {
                      // Navigate to News Detail
                    },
                  ),
                ),
              ),
        ),
      ],
    );
  }
}
