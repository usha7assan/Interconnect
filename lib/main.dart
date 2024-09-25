import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:interconnect/Screens/SplashPage.dart';
import 'package:interconnect/Screens/chatPage.dart';
import 'package:interconnect/Screens/signInPage.dart';
import 'package:interconnect/Screens/signUpPage.dart';
import 'package:interconnect/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  String? email = await getUserEmail();

  runApp(MyApp(
    email: email,
  ));
}

Future<String?> getUserEmail() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('userEmail');
}

class MyApp extends StatelessWidget {
  final String? email;

  const MyApp({super.key, this.email});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        SignInPage.id: (context) => const SignInPage(),
        SignUpPage.id: (context) => const SignUpPage(),
        ChatPage.id: (context) => ChatPage(email: email ?? ''),
      },
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.id,
    );
  }
}
