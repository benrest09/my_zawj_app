import 'package:flutter/material.dart';
import 'package:zawj_app/screens/chat_screen.dart';
import 'package:zawj_app/screens/home_screen.dart';
import 'package:zawj_app/screens/inbox_screen.dart';
import 'package:zawj_app/screens/profil_screen.dart';
import 'package:zawj_app/screens/serasi_screen.dart';
import 'package:zawj_app/widgets/app_color.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    InboxScreen(),
    SerasiScreen(),
    ChatScreen(),
    ProfileScreen(),
  ];

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onTap,
        selectedItemColor: AppColor.pinktua,
        unselectedItemColor: AppColor.abutua,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            activeIcon: Icon(Icons.add_box),
            label: 'inbox',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border_outlined),
            activeIcon: Icon(Icons.favorite),
            label: 'serasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            activeIcon: Icon(Icons.person),
            label: 'profil',
          ),
        ],
      ),
    );
  }
}
