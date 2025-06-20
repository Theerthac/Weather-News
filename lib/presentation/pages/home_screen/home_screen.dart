import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weatherandnewsaggregatorapp/data/colors/colors.dart';
import 'package:weatherandnewsaggregatorapp/data/components/custom_apptext.dart';
import 'package:weatherandnewsaggregatorapp/data/model/news_model.dart';
import 'package:weatherandnewsaggregatorapp/presentation/controllers/weather_controller.dart';
import 'package:weatherandnewsaggregatorapp/presentation/pages/home_screen/components/newsdetails_screen.dart';
import 'package:weatherandnewsaggregatorapp/presentation/pages/home_screen/components/weatherdetail_screen.dart';
import 'package:weatherandnewsaggregatorapp/presentation/controllers/news_controller.dart';
import 'package:weatherandnewsaggregatorapp/presentation/controllers/settings_controller.dart';



class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final WeatherController weatherController = Get.put(WeatherController());
    final NewsController newsController = Get.put(NewsController());
    final SettingsController settingsController = Get.put(SettingsController());

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
          Obx(
            () => IconButton(
              icon: weatherController.isLoading.value
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: textPrimary,
                      ),
                    )
                  : Icon(Icons.my_location, color: textPrimary),
              onPressed: weatherController.isLoading.value
                  ? null
                  : () {
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
                                weatherController.fetchWeatherByCurrentLocation();
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
        onRefresh: () async {
          await Future.wait([
            weatherController.refreshWeather(),
            newsController.refreshNews(),
          ]);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Weather Section
              _buildWeatherSection(
                weatherController,
                settingsController,
                context,
              ),

              const SizedBox(height: 20),

              // Search City Section
              _buildSearchSection(weatherController),

              const SizedBox(height: 20),

              // Weather-Based News Filter Info Section (NEW)
              _buildWeatherNewsFilterInfo(newsController),

              const SizedBox(height: 10),

              // News Section
              _buildNewsSection(newsController, settingsController),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherSection(
    WeatherController weatherController,
    SettingsController settingsController,
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
                Obx(
                  () => AppText(
                    settingsController.convertTemperature(
                      weatherController.currentTemperature.value,
                    ),
                    size: 50,
                    weight: FontWeight.w400,
                    color: textPrimary,
                  ),
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

  // NEW: Weather-Based News Filter Information Widget
  Widget _buildWeatherNewsFilterInfo(NewsController newsController) {
    return Obx(() {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              sunYellow.withOpacity(0.1),
              sunYellow.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: sunYellow.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  newsController.getWeatherMoodIcon(),
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 8),
                AppText(
                  'Weather-Based News Filter',
                  size: 16,
                  weight: FontWeight.w600,
                  color: textPrimary,
                ),
              ],
            ),
            const SizedBox(height: 8),
            AppText(
              newsController.getWeatherMoodDescription(),
              size: 14,
              color: textSecondary,
              maxLines: 2,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: sunYellow.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: AppText(
                'Category: ${newsController.getCurrentWeatherCategory()}',
                size: 12,
                weight: FontWeight.w600,
                color: sunYellow,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildNewsSection(
    NewsController newsController,
    SettingsController settingsController,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              AppText(
                'News Headlines',
                color: textPrimary,
                size: 18,
                weight: FontWeight.w700,
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        Obx(() {
          if (newsController.isLoading.value) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(40.0),
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (newsController.errorMessage.value.isNotEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 8),
                    AppText(
                      newsController.errorMessage.value,
                      color: Colors.red,
                      size: 14,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => newsController.refreshNews(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final articles = newsController.newsModel.value?.articles ?? [];

          if (articles.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(40.0),
                child: AppText(
                  'No news available',
                  color: Colors.grey,
                  size: 16,
                ),
              ),
            );
          }

          return Column(
            children: [
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: articles.length > 1 ? articles.length - 1 : 0,
                itemBuilder: (context, index) => _buildNewsItem(articles[index + 1]),
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildNewsItem(Article article) {
    return GestureDetector(
      onTap: () => Get.to(() => NewsDetailScreen(article: article)),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: colorWhite,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              if (article.urlToImage != null && article.urlToImage!.isNotEmpty)
                Image.network(
                  article.urlToImage!,
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 150,
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                        size: 40,
                      ),
                    );
                  },
                )
              else
                Container(
                  width: double.infinity,
                  height: 150,
                  color: Colors.grey[200],
                  child: const Icon(
                    Icons.article,
                    color: Colors.grey,
                    size: 40,
                  ),
                ),

              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Source and Date
                    Row(
                      children: [
                        if (article.source?.name != null)
                          Expanded(
                            child: AppText(
                              article.source!.name!,
                              size: 12,
                              color: sunYellow,
                              weight: FontWeight.w600,
                            ),
                          ),
                        if (article.publishedAt != null)
                          AppText(
                            _formatDate(article.publishedAt!),
                            size: 12,
                            color: textSecondary,
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Title
                    AppText(
                      article.title ?? 'No Title',
                      color: textPrimary,
                      size: 16,
                      weight: FontWeight.w700,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 8),

                    // Description
                    if (article.description != null && article.description!.isNotEmpty)
                      AppText(
                        article.description!,
                        size: 14,
                        color: textSecondary,
                        maxLines: 2,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  String _formatDate(String dateString) {
    try {
      final DateTime date = DateTime.parse(dateString);
      final DateTime now = DateTime.now();
      final Duration difference = now.difference(date);

      if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return 'Recently';
    }
  }
}
