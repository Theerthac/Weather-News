// data/models/news_model.dart
import 'dart:convert';

NewsModel newsModelFromJson(String str) => NewsModel.fromJson(json.decode(str));
String newsModelToJson(NewsModel data) => json.encode(data.toJson());

class NewsModel {
  int? totalResults;
  List<Article>? articles;

  NewsModel({this.totalResults, this.articles});

  factory NewsModel.fromJson(Map<String, dynamic> json) => NewsModel(
        totalResults: json["totalResults"],
        articles: (json["articles"] as List?)?.map((x) => Article.fromJson(x)).toList(),
      );

  Map<String, dynamic> toJson() => {
        "totalResults": totalResults,
        "articles": articles?.map((x) => x.toJson()).toList(),
      };
}

class Article {
  Source? source;
  String? author;
  String? title;
  String? description;
  String? url;
  String? urlToImage;
  String? publishedAt;
  String? content;

  Article({
    this.source,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        source: json["source"] != null ? Source.fromJson(json["source"]) : null,
        author: json["author"],
        title: json["title"],
        description: json["description"],
        url: json["url"],
        urlToImage: json["urlToImage"],
        publishedAt: json["publishedAt"],
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "source": source?.toJson(),
        "author": author,
        "title": title,
        "description": description,
        "url": url,
        "urlToImage": urlToImage,
        "publishedAt": publishedAt,
        "content": content,
      };
}

class Source {
  String? id;
  String? name;

  Source({this.id, this.name});

  factory Source.fromJson(Map<String, dynamic> json) => Source(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}