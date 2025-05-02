import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:provider/provider.dart';
import 'package:lw/services/database_services.dart';
import 'package:lw/services/trends_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ContentGen extends StatefulWidget {
  const ContentGen({Key? key}) : super(key: key);

  @override
  _ContentGenState createState() => _ContentGenState();
}

class _ContentGenState extends State<ContentGen> {
  final TextEditingController _promptController = TextEditingController();
  String _output = '';
  bool _loading = false;
  List<String> interests = [];

  final String apiKey = 'AIzaSyDdsaZ7VsRNAzm0xvG-Qt_ldlh_y_mmFPU';
  late GenerativeModel _model;

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> _getUserInterests() async {
    try {
      final snapshot = await DatabaseService().getDocSnapshot(auth.currentUser!.uid);
      if (snapshot.exists) {
        setState(() {
          interests = List<String>.from((snapshot.data() as Map<String, dynamic>)['interests'] ?? []);
          print(interests);
        });
      } else {
        setState(() {
          interests = [];
        });
      }
    } catch (e) {
      setState(() {
        interests = [];
      });
      debugPrint('Error fetching user interests: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey,
    );
  }

  Future<void> _generateContent(List<String> at, List<String> lt) async {
    _getUserInterests();

    setState(() => _loading = true);

    String i = _promptController.text;

    final userInterests = interests.isNotEmpty ? interests.join(', ') : "[Click 'Give Ideas' again if you have interests]";
    final likedTrends = lt.isNotEmpty ? lt.join(', ') : "[Click 'Give Ideas' again if you have likedtrends]";
    final allTrends = at.isNotEmpty ? at.join(', ') : 'popular trends';
    final prompt = 'Based on the user\'s interests: [$userInterests], Popular Trends: [$allTrends] and liked trends: [$likedTrends], suggest a list of creative and high-performing content ideas for social media posts. Keep this in mind: [$i].';

    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      setState(() => _output = ("Your Interests: " + userInterests + "\nYour Liked Trends: " + likedTrends + "\nPopular Trends: " + allTrends + "\n\n") + response.text.toString());
    } catch (e) {
      setState(() => _output = 'Error generating content: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {

    final trendsProvider = context.watch<TrendsProvider>();

    final List<String> allTrends = trendsProvider.trends.map((trend) => trend.title).toList();
    final List<String> likedTrends = trendsProvider.likedTrends.map((trend) => trend.title).toList();


    return Scaffold(
      appBar: AppBar(title: Text('Content Generator')),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _promptController,
              decoration: InputDecoration(
                hintText: 'Enter prompt for the AI bot of influencers dream',
                border: OutlineInputBorder(),
              ),
              minLines: 2,
              maxLines: 5,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : () => _generateContent(allTrends, likedTrends),
              child: Text('Give Ideas'),
            ),
            SizedBox(height: 20),
            if (_loading)
              Center(
                child: CircularProgressIndicator(),
              )
            else
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _output,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                'Content is AI-generated. Review for accuracy before use.',
              style: TextStyle(fontSize: 14, color: Colors.white),
              textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
