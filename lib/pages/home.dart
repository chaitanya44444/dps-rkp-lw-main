import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text(
              'Welcome to Influencer App',
              style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.3,
              ),
              ),
              SizedBox(height: 10),
              Text(
              'Your ultimate companion for content creation and social media growth.',
              style: TextStyle(
              fontSize: 22,
              color: Colors.grey,
              ),
              ),
              SizedBox(height: 20),
              Text(
              'Key Features:',
              style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.purpleAccent,
              ),
              ),
              SizedBox(height: 10),
              Text(
              '1. Discover Trends:',
              style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
              ),
              ),
              Text(
              'Stay updated with the latest trends in your local area and beyond.',
              style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
              ),
              ),
              SizedBox(height: 10),
              Text(
              '2. AI-Powered Content Ideas:',
              style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.greenAccent,
              ),
              ),
              Text(
              'Generate creative content ideas, hashtags, captions, and more with our AI tools.',
              style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
              ),
              ),
              SizedBox(height: 20),
              Text(
              'Start your journey with us today and unlock your full potential!',
              style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              ),
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}