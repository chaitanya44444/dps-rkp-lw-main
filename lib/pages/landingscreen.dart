import 'package:flutter/material.dart';
import 'package:lw/pages/contentgen.dart';
import 'package:lw/pages/google_trends_rss_page.dart';
import 'package:lw/pages/home.dart';
import 'package:lw/pages/profile.dart';
import 'package:lw/pages/resources.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  int _selectedIndex = 0;

  MaterialApp page(dynamic page){ 
    return MaterialApp(
      home: page,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.deepPurpleAccent,
        scaffoldBackgroundColor: Colors.black,
        highlightColor: Colors.purpleAccent,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.deepPurpleAccent,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.purple[100],
            fontSize: 30,
          ),
          toolbarHeight: 50,
        ),
      ),
    );
  }

  static const List<Widget> _widgetOptions = <Widget>[
    Home(),
    GoogleTrendsRssPage(),
    ContentGen(),
    Resourcescreen(),
    Profile()
  ];

  void popAndPushNamedland(String page) {
    Navigator.popAndPushNamed(context, page);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex)
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
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
        elevation: 10,
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.purple[50],
        selectedItemColor: Colors.purple,
        onTap: _onItemTapped,
      ),
    );
  }
}