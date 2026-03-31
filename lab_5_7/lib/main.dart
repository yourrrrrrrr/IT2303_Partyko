import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
//import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Фотогалерея';

    return const MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    ); // MaterialApp
  }
}

class Photo {
  final String gender;
  final String picture;

  const Photo({required this.gender, required this.picture});

  factory Photo.fromJson(Map<String, dynamic> json) {
    final pictureData = json['picture'] as Map<String, dynamic>;

    return Photo(
      gender: json['gender'] as String,
      picture: pictureData['large'] as String,
    );
  }
}

Future<List<Photo>> fetchPhotos(http.Client client) async {
  final response = await client.get(
    Uri.parse('https://randomuser.me/api/?results=50'),
  );
  return compute(parsePhotos, response.body);
}

List<Photo> parsePhotos(String responseBody) {
  final data = jsonDecode(responseBody) as Map<String, dynamic>;
  final results = data['results'] as List<dynamic>;
  return results
      .map((json) => Photo.fromJson(json as Map<String, dynamic>))
      .toList();
}

class PhotosList extends StatelessWidget {
  const PhotosList({super.key, required this.photos});
  final List<Photo> photos;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      cacheExtent: 1000.0,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return Image.network(
          photos[index].picture,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.broken_image);
          },
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Photo>> futurePhotos;

  @override
  void initState() {
    super.initState();
    futurePhotos = fetchPhotos(http.Client());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: FutureBuilder<List<Photo>>(
        future: futurePhotos,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return PhotosList(photos: snapshot.data!);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
