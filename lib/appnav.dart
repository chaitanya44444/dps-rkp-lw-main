import 'package:flutter/material.dart';
import 'package:lw/pages/landingscreen.dart';

class AppNav extends StatefulWidget {
  @override
  _AppNavState createState() => _AppNavState();
}

class _AppNavState extends State<AppNav> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeView(),
    SearchView(),
    ProfileView(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child:ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LandingScreen()),
          );
        },
        child: Text("data"),
      ),
    );
  }
}

class SearchView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Search View'),
    );
  }
}

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Profile View'),
    );
  }
}