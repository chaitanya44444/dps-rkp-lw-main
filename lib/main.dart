import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lw/firebase_options.dart';
import 'package:lw/pages/Interests.dart';
import 'package:lw/pages/landingscreen.dart';
import 'package:lw/pages/login.dart';
import 'package:lw/pages/signup.dart';
import 'package:lw/pages/contentgen.dart';
import 'pages/google_trends_rss_page.dart';
import 'services/trends_provider.dart';
import 'package:lw/pages/resources.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => TrendsProvider(),
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LiveWire',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/sign-up',
      routes: {
        '/log-in': (context) => LogIn(),
        '/google-trends-display': (context) => GoogleTrendsRssPage(),
        '/sign-up': (context) => SignUp(),
        '/landingscreen': (context) => LandingScreen(),
        '/interests': (context) => Interests(),
        '/content-gen': (context) => ContentGen(),
        '/resources': (context) => Resourcescreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
