import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Resourcescreen extends StatelessWidget {
  const Resourcescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,// idk how else to change height else it was too big
        centerTitle: true,
        title:  Text(
          'Influencer App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
      ),
      body: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // i dont like how we cant just give children to allign and have to use this
            children: [
              Text(
                'Here are some hand-picked platforms to help you',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.purple,
                  height: 1.3,
                    fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40),
              Expanded(
              child: ListView(
                children: [
                Card(
                  color: Colors.grey[900],
                  child: ListTile(
                  title: Text(
                    'Open Access Art (The Met)',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'https://www.metmuseum.org/art/collection',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                  onTap: () => launchUrl(Uri.parse('https://www.metmuseum.org/art/collection')),
                  ),
                ),
                Card(
                  color: Colors.grey[900],
                  child: ListTile(
                  title: Text(
                    'Pexels',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'https://www.pexels.com',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                  onTap: () => launchUrl(Uri.parse('https://www.pexels.com')),
                  ),
                ),
                Card(
                  color: Colors.grey[900],
                  child: ListTile(
                  title: Text(
                    'Unsplash',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'https://www.unsplash.com',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                  onTap: () => launchUrl(Uri.parse('https://www.unsplash.com')),
                  ),
                ),
                Card(
                  color: Colors.grey[900],
                  child: ListTile(
                  title: Text(
                    'Pixabay',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'https://www.pixabay.com',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                  onTap: () => launchUrl(Uri.parse('https://www.pixabay.com')),
                  ),
                ),
                Card(
                  color: Colors.grey[900],
                  child: ListTile(
                  title: Text(
                    'YouTube Audio Library',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'https://studio.youtube.com',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                  onTap: () => launchUrl(Uri.parse('https://studio.youtube.com')),
                  ),
                ),
                Card(
                  color: Colors.grey[900],
                  child: ListTile(
                  title: Text(
                    'Free Music Archive',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'https://freemusicarchive.org',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                  onTap: () => launchUrl(Uri.parse('https://freemusicarchive.org')),
                  ),
                ),
                Card(
                  color: Colors.grey[900],
                  child: ListTile(
                  title: Text(
                    'Bensound',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'https://www.bensound.com',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                  onTap: () => launchUrl(Uri.parse('https://www.bensound.com')),
                  ),
                ),
                Card(
                  color: Colors.grey[900],
                  child: ListTile(
                  title: Text(
                    'Coverr',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'https://www.coverr.co',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                  onTap: () => launchUrl(Uri.parse('https://www.coverr.co')),
                  ),
                ),
                Card(
                  color: Colors.grey[900],
                  child: ListTile(
                  title: Text(
                    'Mixkit',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'https://mixkit.co',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                  onTap: () => launchUrl(Uri.parse('https://mixkit.co')),
                  ),
                ),
                Card(
                  color: Colors.grey[900],
                  child: ListTile(
                  title: Text(
                    'Videvo',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'https://www.videvo.net',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                  onTap: () => launchUrl(Uri.parse('https://www.videvo.net')),
                  ),
                ),
                ],
              ),
              ),
          
            ],
          ),
        ),
      ),
    );
  }
}