// controllers/news_controller.dart
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:weatherandnewsaggregatorapp/data/model/news_model.dart';
import 'package:weatherandnewsaggregatorapp/presentation/controllers/weather_controller.dart';
import 'package:weatherandnewsaggregatorapp/presentation/controllers/settings_controller.dart';

class NewsController extends GetxController {
  static const String _baseUrl = 'https://newsapi.org/v2/everything';
  static const String _topHeadlinesUrl = 'https://newsapi.org/v2/top-headlines';
  static const String _apiKey = '1b4ef652b07f4fac8336d9e7f5ebc4ab';

  var isLoading = false.obs;
  var newsModel = Rxn<NewsModel>();
  var errorMessage = ''.obs;
  var currentPage = 1.obs;
  var hasMoreNews = true.obs;

  WeatherController get weatherController => Get.find<WeatherController>();
  SettingsController get settingsController => Get.find<SettingsController>();

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(milliseconds: 1000), () {
      fetchWeatherBasedNews();
    });
  }

  Future<void> fetchWeatherBasedNews() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      currentPage.value = 1;

      List<String> weatherKeywords = _getWeatherBasedKeywords();
      List<String> selectedCategories = settingsController.selectedCategories.toList();

      if (selectedCategories.isEmpty) {
        await _fetchNewsByKeywords(weatherKeywords);
      } else {
        await _fetchCombinedNews(weatherKeywords, selectedCategories);
      }
    } catch (e) {
      errorMessage.value = 'Error fetching weather-based news: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Updated weather-based keywords according to task requirements
  List<String> _getWeatherBasedKeywords() {
    if (weatherController.weatherData.value?.main?.temp == null) {
      return ['technology', 'science']; // Default fallback
    }

    double temperature = weatherController.weatherData.value!.main!.temp!;

    // Cold weather (< 15°C): Show depressing and tragedy news
    if (temperature < 15) {
      return [
        'tragedy',
        'depressing', 
        'sad',
        'unfortunate',
        'disaster',
        'crisis',
        'accident',
        'loss',
        'grief',
        'mourning'
      ];
    } 
    // Hot weather (> 30°C): Show fear and danger news
    else if (temperature > 30) {
      return [
        'fear',
        'danger',
        'dangerous',
        'scary',
        'threat',
        'threatening',
        'risk',
        'warning',
        'alert',
        'hazard'
      ];
    } 
    // Warm weather (15-30°C): Show winning, positivity and happiness news
    else {
      return [
        'winning',
        'positivity',
        'happiness',
        'positive',
        'happy',
        'success',
        'achievement',
        'victory',
        'celebration',
        'joy',
        'breakthrough',
        'accomplishment',
        'triumph',
        'good news',
        'inspiring'
      ];
    }
  }

  Future<void> _fetchNewsByKeywords(List<String> keywords) async {
    try {
      List<Article> allArticles = [];

      // Try to get articles for each weather-based keyword
      for (String keyword in keywords) {
        final articles = await _fetchArticlesByKeyword(keyword);
        allArticles.addAll(articles);

        // Stop if we have enough articles
        if (allArticles.length >= 30) break;
      }

      // Remove duplicates
      allArticles = _removeDuplicates(allArticles);

      // If we don't have enough weather-specific articles, supplement with general news
      if (allArticles.length < 10) {
        final generalArticles = await _fetchGeneralNews();
        allArticles.addAll(generalArticles);
        allArticles = _removeDuplicates(allArticles);
      }

      newsModel.value = NewsModel(
        totalResults: allArticles.length,
        articles: allArticles.take(50).toList(),
      );
    } catch (e) {
      throw Exception('Failed to fetch news by keywords: $e');
    }
  }

  Future<void> _fetchCombinedNews(
    List<String> weatherKeywords,
    List<String> categories,
  ) async {
    try {
      List<Article> allArticles = [];

      // Fetch weather-based articles (higher priority)
      for (String keyword in weatherKeywords.take(3)) {
        final articles = await _fetchArticlesByKeyword(keyword);
        allArticles.addAll(articles.take(8));
      }

      // Fetch category-based articles
      for (String category in categories.take(3)) {
        final articles = await _fetchArticlesByCategory(category);
        allArticles.addAll(articles.take(4));
      }

      // Remove duplicates and shuffle
      allArticles = _removeDuplicates(allArticles);
      
      // Sort to prioritize weather-based articles but keep some randomness
      allArticles.shuffle();

      newsModel.value = NewsModel(
        totalResults: allArticles.length,
        articles: allArticles.take(50).toList(),
      );
    } catch (e) {
      throw Exception('Failed to fetch combined news: $e');
    }
  }

  Future<List<Article>> _fetchArticlesByKeyword(String keyword) async {
    try {
      final today = DateTime.now();
      final fromDate = today.subtract(Duration(days: 3)); // Extended date range

      final String from =
          '${fromDate.year}-${fromDate.month.toString().padLeft(2, '0')}-${fromDate.day.toString().padLeft(2, '0')}';
      final String to =
          '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      // Use both title and description search for better results
      final url =
          '$_baseUrl?q="$keyword" OR "$keyword"&from=$from&to=$to&sortBy=popularity&pageSize=15&language=en&apiKey=$_apiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final newsModel = NewsModel.fromJson(jsonData);
        return newsModel.articles ?? [];
      } else {
        print('Error fetching articles for keyword $keyword: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Exception fetching articles for keyword $keyword: $e');
      return [];
    }
  }

  Future<List<Article>> _fetchArticlesByCategory(String category) async {
    try {
      final url = '$_topHeadlinesUrl?category=$category&pageSize=10&language=en&apiKey=$_apiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final newsModel = NewsModel.fromJson(jsonData);
        return newsModel.articles ?? [];
      } else {
        print('Error fetching articles for category $category: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Exception fetching articles for category $category: $e');
      return [];
    }
  }

  // Fetch general news as fallback
  Future<List<Article>> _fetchGeneralNews() async {
    try {
      final url = '$_topHeadlinesUrl?country=us&pageSize=15&language=en&apiKey=$_apiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final newsModel = NewsModel.fromJson(jsonData);
        return newsModel.articles ?? [];
      } else {
        return [];
      }
    } catch (e) {
      print('Exception fetching general news: $e');
      return [];
    }
  }

  List<Article> _removeDuplicates(List<Article> articles) {
    Map<String, Article> uniqueArticles = {};

    for (Article article in articles) {
      String key = article.title?.toLowerCase().trim() ?? '';
      if (key.isNotEmpty && !uniqueArticles.containsKey(key)) {
        uniqueArticles[key] = article;
      }
    }

    return uniqueArticles.values.toList();
  }

  Future<void> loadMoreNews() async {
    if (!hasMoreNews.value || isLoading.value) return;

    try {
      currentPage.value++;

      List<String> weatherKeywords = _getWeatherBasedKeywords();
      String mainKeyword = weatherKeywords.first;

      final today = DateTime.now();
      final fromDate = today.subtract(Duration(days: 3));

      final String from =
          '${fromDate.year}-${fromDate.month.toString().padLeft(2, '0')}-${fromDate.day.toString().padLeft(2, '0')}';
      final String to =
          '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      final url =
          '$_baseUrl?q="$mainKeyword"&from=$from&to=$to&sortBy=popularity&page=${currentPage.value}&pageSize=10&language=en&apiKey=$_apiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final newNewsModel = NewsModel.fromJson(jsonData);

        if (newNewsModel.articles?.isNotEmpty == true) {
          List<Article> currentArticles = newsModel.value?.articles ?? [];
          List<Article> newArticles = newNewsModel.articles!;

          List<Article> combinedArticles = [...currentArticles, ...newArticles];
          combinedArticles = _removeDuplicates(combinedArticles);

          newsModel.value = NewsModel(
            totalResults: combinedArticles.length,
            articles: combinedArticles,
          );
        } else {
          hasMoreNews.value = false;
        }
      }
    } catch (e) {
      print('Error loading more news: $e');
    }
  }

  Future<void> refreshNews() async {
    hasMoreNews.value = true;
    await fetchWeatherBasedNews();
  }

  Future<void> searchNews(String query) async {
    if (query.trim().isEmpty) {
      await fetchWeatherBasedNews();
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Combine user search with weather context
      List<String> weatherKeywords = _getWeatherBasedKeywords();
      String weatherContext = weatherKeywords.first;
      String combinedQuery = '$query AND ($weatherContext OR ${weatherKeywords[1]})';

      final today = DateTime.now();
      final fromDate = today.subtract(Duration(days: 3));

      final String from =
          '${fromDate.year}-${fromDate.month.toString().padLeft(2, '0')}-${fromDate.day.toString().padLeft(2, '0')}';
      final String to =
          '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      final url =
          '$_baseUrl?q=$combinedQuery&from=$from&to=$to&sortBy=popularity&pageSize=20&language=en&apiKey=$_apiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        newsModel.value = NewsModel.fromJson(jsonData);
      } else {
        errorMessage.value = 'Search failed: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Search error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Updated weather mood descriptions according to task requirements
  String getWeatherMoodDescription() {
    if (weatherController.weatherData.value?.main?.temp == null) {
      return 'Balanced news selection';
    }

    double temperature = weatherController.weatherData.value!.main!.temp!;

    if (temperature < 15) {
      return 'Cold weather (${temperature.round()}°C) - Showing depressing & tragedy news';
    } else if (temperature > 30) {
      return 'Hot weather (${temperature.round()}°C) - Showing fear & danger news';
    } else {
      return 'Pleasant weather (${temperature.round()}°C) - Showing positive & winning news';
    }
  }

  String getWeatherMoodIcon() {
    if (weatherController.weatherData.value?.main?.temp == null) {
      return '⚖️';
    }

    double temperature = weatherController.weatherData.value!.main!.temp!;

    if (temperature < 15) {
      return '❄️😢'; // Cold + sad for depressing news
    } else if (temperature > 30) {
      return '🔥😰'; // Hot + fearful for danger news
    } else {
      return '🌟😊'; // Pleasant + happy for positive news
    }
  }

  // Get current weather category for display
  String getCurrentWeatherCategory() {
    if (weatherController.weatherData.value?.main?.temp == null) {
      return 'Neutral';
    }

    double temperature = weatherController.weatherData.value!.main!.temp!;

    if (temperature < 15) {
      return 'Cold';
    } else if (temperature > 30) {
      return 'Hot';
    } else {
      return 'Warm';
    }
  }
}