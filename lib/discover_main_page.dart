import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'effects_discover_page.dart';

@RoutePage()
class DiscoverMainPage extends StatefulWidget {
  const DiscoverMainPage({super.key});

  @override
  State<DiscoverMainPage> createState() => _DiscoverMainPageState();
}

class _DiscoverMainPageState extends State<DiscoverMainPage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const EffectsDiscoverPage(type: 'video'),
    const EffectsDiscoverPage(type: 'image'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1018),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: const Color(0xFF1B1F2B),
        selectedItemColor: const Color(0xFFA855F7),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library_rounded),
            label: 'Video',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.image_rounded),
            label: 'Image',
          ),
        ],
      ),
    );
  }
}
