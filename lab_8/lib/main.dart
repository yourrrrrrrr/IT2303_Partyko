import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io'; // ← Для HttpOverrides
//import 'package:intl/intl.dart';
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

class NewsItem {
  final String id;
  final String title;
  final String previewText;
  final String imageUrl;
  final String detailUrl;
  final String date;
  final String detailText;

  const NewsItem({
    required this.id,
    required this.title,
    required this.previewText,
    required this.imageUrl,
    required this.detailUrl,
    required this.date,
    required this.detailText,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    // Очистка HTML (заменяем \u003C, \u003E и т.д.)
    String cleanText(String text) {
      return text
          .replaceAll(RegExp(r'<[^>]*>'), '') // Удаляем HTML теги
          .replaceAll(RegExp(r'\\u003C'), '<') // Unicode HTML
          .replaceAll(RegExp(r'\\u003E'), '>')
          .replaceAll(RegExp(r'\\u003Ci\u003E'), '')
          .replaceAll(RegExp(r'\\u003C/i\u003E'), '')
          .replaceAll('\r\n\r\n\r\n', '\n') // Много переносов
          .replaceAll('\t', ' ') // Табы
          .trim();
    }

    return NewsItem(
      id: json['ID'] ?? '',
      title: cleanText(json['TITLE'] ?? ''),
      previewText: cleanText(json['PREVIEW_TEXT'] ?? ''),
      imageUrl: json['PREVIEW_PICTURE_SRC'] ?? '',
      detailUrl: json['DETAIL_PAGE_URL'] ?? '',
      date: json['ACTIVE_FROM']?.split(' ')[0] ?? '', // Только дата
      detailText: cleanText(json['DETAIL_TEXT'] ?? ''),
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
    throw Exception('Ошибка: ${response.statusCode}');
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
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      // Открыть полную новость
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   SnackBar(content: Text('Открыть: ${news.title}')),
                      // );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Картинка
                          if (news.imageUrl.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                news.imageUrl,
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      height: 120,
                                      color: Colors.grey[300],
                                      child: Icon(
                                        Icons.image_not_supported,
                                        size: 40,
                                      ),
                                    ),
                              ),
                            ),
                          const SizedBox(height: 12),

                          // Заголовок
                          Text(
                            news.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),

                          // Дата
                          Text(
                            news.date,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Превью текст
                          Text(
                            news.previewText.isNotEmpty
                                ? news.previewText
                                : news.detailText,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black54,
                              height: 1.4,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
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
