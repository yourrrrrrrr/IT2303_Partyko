import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Этот виджет является корневой папкой вашего приложения.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Лабораторная работа №2',
      home: const MyHomePage(title: 'Общежития КубГАУ'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  //Поля в подклассе Widget всегда помечены как "final".
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PageController _pageController = PageController();

  bool _isLiked = false;

  void _like() {
    setState(() {
      _isLiked = !_isLiked;
    });
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  void _prevPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  void _makePhoneCall() async {
    final Uri mapUri = Uri.parse('https://kubsau.ru/university/contacts/');
    await launchUrl(mapUri, mode: LaunchMode.externalApplication);
  }

  void _openRoute() async {
    final Uri mapUri = Uri.parse('https://yandex.ru/maps/-/CPUtbIP5');
    await launchUrl(mapUri, mode: LaunchMode.externalApplication);
  }

  void _share() async {
    const String text =
        'Посмотри на это общежитие №20 КубГАУ! Краснодар, ул. Калинина, 13.';
    SharePlus.instance.share(
      ShareParams(text: text, subject: 'Общежития КубГАУ'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF4cb050),
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 309,
              child: Stack(
                children: [
                  // 1. Нижний слой: Сами картинки
                  PageView(
                    controller: _pageController,
                    children: [
                      Image.asset('assets/images/img3.jpg', fit: BoxFit.cover),
                      Image.asset('assets/images/img2.jpg', fit: BoxFit.cover),
                      Image.asset('assets/images/img1.jpg', fit: BoxFit.cover),
                    ],
                  ),
                  // Кнопка Влево
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 30,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black.withValues(alpha: 0.3),
                      ),
                      onPressed: _prevPage,
                    ),
                  ),
                  // Кнопка Вправо
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 30,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black.withValues(alpha: 0.3),
                      ),
                      onPressed: _nextPage,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Общежитие №20',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Text(
                        'Краснодар, ул. Калинина, 13',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: _like,
                    icon: Icon(
                      _isLiked ? Icons.favorite : Icons.favorite_border,
                      color: _isLiked ? Colors.red : Colors.grey,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildActionButton(
                    icon: Icons.phone,
                    label: 'ПОЗВОНИТЬ',
                    color: Color(0xFF4cb050),
                    onPressed: _makePhoneCall,
                  ),
                  _buildActionButton(
                    icon: Icons.near_me,
                    label: 'МАРШРУТ',
                    color: Color(0xFF4cb050),
                    onPressed: _openRoute,
                  ),
                  _buildActionButton(
                    icon: Icons.share,
                    label: 'ПОДЕЛИТЬСЯ',
                    color: Color(0xFF4cb050),
                    onPressed: _share,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(30),
              child: const Text(
                'Студенческий городок или так называемый кампус Кубанского ГАУ состоит'
                        'из двадцати общежитий, в которых проживает более 8000 студентов, что составляет 96% от всех нуждающихся. ' +
                    'Студенты первого курса обеспечены местами в общежитии полностью. В соответствии с Положением о студенческих общежитиях' +
                    'университета, при поселении между администрацией и студентами заключается ' +
                    'договор найма жилого помещения. Воспитательная работа в общежитиях направлена на улучшение быта, соблюдение правил внутреннего распорядка, отсутствия' +
                    'асоциальных явлений в молодежной среде. Условия проживания в общежитиях' +
                    'университетского кампуса полностью отвечают санитарным нормам и требованиям: наличие оборудованных кухонь, душевых комнат, прачечных, читальных залов, комнат самоподготовки, помещений для заседаний студенческих советов и' +
                    'наглядной агитации. С целью улучшения условий быта студентов активно работает' +
                    'система студенческого самоуправления - студенческие советы организуют всю работу по самообслуживанию.',
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, color: color),
          iconSize: 30,
          onPressed: onPressed,
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Color(0xFF4cb050))),
      ],
    );
  }
}
