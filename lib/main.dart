import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tf_app/admin/activitylog.dart';
import 'package:tf_app/admin/login.dart';
import 'package:tf_app/user/home/home.dart';
import 'package:tf_app/user/onboarding_login/page1.dart';
import 'package:tf_app/user/onboarding_login/page2.dart';
import 'package:tf_app/user/onboarding_login/reset.dart';
import 'package:tf_app/user/onboarding_login/auth_screen/signin.dart';
import 'package:tf_app/user/onboarding_login/auth_screen/signup.dart';
import 'package:tf_app/user/profile/profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAypV5tJO5ywTPc-7sZR1X3WFi0pLDFcCE",
          authDomain: "cropcure-ec591.firebaseapp.com",
          projectId: "cropcure-ec591",
          storageBucket: "cropcure-ec591.firebasestorage.app",
          messagingSenderId: "160857681854",
          appId: "1:160857681854:web:a1e8f62741ad382fab13ef",
          measurementId: "G-QY8KBFTJJJ"));

  runApp(kIsWeb ? ActivityLogApp() : const MyApp());
  // debugPaintSizeEnabled = true;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Crop Cure',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoadingPage(),
        '/welcome': (context) => const WelcomePage(),
        '/signin': (context) => const LoginPage(),
        '/signup': (context) => const CreateAccountPage(),
        '/forgot': (context) => const ForgotPasswordPage(),
        '/profile': (context) => const ProfilePage(),
        // '/disease': (context) => const PlantDiseasePage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}

class ActivityLogApp extends StatelessWidget {
  const ActivityLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Crop Cure',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const MyLogin(),
        '/activity': (context) => ActivityLogScreen(),
      },
    );
  }
}
