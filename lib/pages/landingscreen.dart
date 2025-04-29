import 'package:flutter/material.dart';
import 'package:lw/pages/contentgen.dart';
import 'package:lw/pages/google_trends_rss_page.dart';
import 'package:lw/pages/home.dart';
import 'package:lw/pages/resources.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  int _selectedIndex = 1;

  static const List<Widget> _widgetOptions = <Widget>[
    MaterialApp(home: Home()),
    MaterialApp(home: GoogleTrendsRssPage()),
    MaterialApp(home: ContentGen()),
    MaterialApp(home: Resourcescreen()),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: "Trends",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome),
            label: "Ideas",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: "Resources",
          ),
        ],
        elevation: 10,
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}