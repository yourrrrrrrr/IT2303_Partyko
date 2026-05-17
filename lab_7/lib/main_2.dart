import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io'; // ← Для HttpOverrides
import 'package:intl/intl.dart';
//import 'package:flutter/foundation.dart';

void main() {
  // ← Игнорируем SSL сертификат
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

// ← Класс для обхода SSL
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Лента новостей КубГАУ',
      theme: ThemeData(
        primarySwatch: Colors.green, // Зелёная тема
        scaffoldBackgroundColor: Colors.green[50],
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF4CAF50), // Тёмно-зелёный
          foregroundColor: Colors.white,
        ),
        cardTheme: CardThemeData(
          // ← CardThemeData вместо CardTheme!
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: const NewsHomePage(),
    );
  }
}

// Модель новости
class NewsItem {
  final String title;
  final String content;
  final String date;
  final String imageUrl;

  const NewsItem({
    required this.title,
    required this.content,
    required this.date,
    required this.imageUrl,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    // Убираем HTML теги
    final cleanTitle = Bidi.stripHtmlIfNeeded(json['title'] ?? '');
    final cleanContent = Bidi.stripHtmlIfNeeded(json['content'] ?? '');

    return NewsItem(
      title: cleanTitle,
      content: cleanContent.length > 150
          ? '${cleanContent.substring(0, 150)}...'
          : cleanContent,
      date: json['date'] ?? '',
      imageUrl: json['image'] ?? '',
    );
  }
}

Future<List<NewsItem>> fetchKubsauNews(http.Client client) async {
  final response = await client.get(
    Uri.parse(
      'https://kubsau.ru/api/getNews.php?key=6df2f5d38d4e16b5a923a6d4873e2ee295d0ac90',
    ),
  );

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => NewsItem.fromJson(json)).toList();
  } else {
    throw Exception('Ошибка загрузки новостей: ${response.statusCode}');
  }
}

class NewsHomePage extends StatefulWidget {
  const NewsHomePage({super.key});

  @override
  State<NewsHomePage> createState() => _NewsHomePageState();
}

class _NewsHomePageState extends State<NewsHomePage> {
  late Future<List<NewsItem>> futureNews;

  @override
  void initState() {
    super.initState();
    futureNews = fetchKubsauNews(http.Client());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Лента новостей КубГАУ'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<NewsItem>>(
        future: futureNews,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.green[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Ошибка загрузки новостей',
                    style: TextStyle(color: Colors.green[700], fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text('${snapshot.error}', textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => setState(
                      () => futureNews = fetchKubsauNews(http.Client()),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                    ),
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final news = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Заголовок
                        Text(
                          news.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        // Дата
                        Text(
                          news.date,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.green[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Контент
                        Text(
                          news.content,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                            height: 1.4,
                          ),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        // Кнопка "Читать дальше"
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // TODO: Открыть полную новость
                            },
                            child: Text(
                              'Читать дальше',
                              style: TextStyle(color: Colors.green[700]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(color: Colors.green),
            );
          }
        },
      ),
    );
  }
}
