// controllers/news_controller.dart
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:weatherandnewsaggregatorapp/data/model/news_model.dart';

class NewsController extends GetxController {
  static const String _baseUrl = 'https://newsapi.org/v2/everything';
  static const String _apiKey = '1b4ef652b07f4fac8336d9e7f5ebc4ab';
  
  var isLoading = false.obs;
  var newsModel = Rxn<NewsModel>();
  var errorMessage = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    fetchNews();
  }
  
  Future<void> fetchNews({String query = 'technology'}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final today = DateTime.now();
      final yesterday = today.subtract(Duration(days: 1));
      
      final String fromDate = '${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';
      final String toDate = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
      
      final url = '$_baseUrl?q=$query&from=$fromDate&to=$toDate&sortBy=popularity&apiKey=$_apiKey';
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        newsModel.value = NewsModel.fromJson(jsonData);
      } else {
        errorMessage.value = 'Failed to load news: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Error fetching news: $e';
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> refreshNews() async {
    await fetchNews();
  }
  
  Future<void> searchNews(String query) async {
    if (query.trim().isNotEmpty) {
      await fetchNews(query: query.trim());
    }
  }
}