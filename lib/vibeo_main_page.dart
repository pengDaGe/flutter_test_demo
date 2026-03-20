import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'create_video_page.dart';

@RoutePage()
class VibeoMainPage extends StatefulWidget {
  const VibeoMainPage({super.key});

  @override
  State<VibeoMainPage> createState() => _VibeoMainPageState();
}

class _VibeoMainPageState extends State<VibeoMainPage> {
  int _currentIndex = 1; // Default to 'Tools'

  final List<Widget> _pages = [
    const Center(child: Text('Image Feed', style: TextStyle(color: Colors.white))),
    const CreateVideoPage(),
    const Center(child: Text('Gallery', style: TextStyle(color: Colors.white))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: Colors.black,
        selectedItemColor: const Color(0xFFA855F7),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: 'Image',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_fix_high),
            label: 'Tools',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_open),
            label: 'Gallery',
          ),
        ],
      ),
    );
  }
}
