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
      backgroundColor: Colors.black,
      appBar: AppBar(
        toolbarHeight: 50,// idk how else to change height else it was too big
        backgroundColor: Colors.deepPurpleAccent, // this might hurt eye but looks good to me
        centerTitle: true,
        title:  Text(
          'Influencer App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.purpleAccent,
            fontSize: 30,
          ),
        ),
      ),
      body: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.center, // i dont like how we cant just give children to allign and have to use this
              children: [
                Text(
                  'Unlock your future',
                  style: TextStyle(
                    fontSize: 36,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 1), //using as buffer cuz spacer is frankly in my opinion bad for not allowing decimal values
                Text(
                  '\nExplore our wide collection of powerful tools meant to aid u in your journey in content creation,social media,etc\n',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  'Discover New Trends',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.purpleAccent,
                  ),
                ),
                Text(
                  '\nUsing our apps unique trend section you can easily infer about the latest trends in ur local area\n',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.grey,

                  ),
                ),
                Text(
                  'Generate Content Ideas',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                Text(
                  '\nUse our AI powered tool to help generate your self content ideas,hastags,captions,post ideas,etc\n',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.grey,
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