// import 'package:best_eshopper_application/screens/register.dart';
// import 'package:best_eshopper_application/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'splash.dart';

//Main Function called that initializes the application and loads Firebase
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

//Class that starts the main application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      //Turn the debugger sticker off for the application
      debugShowCheckedModeBanner: false,
      title: 'Eshopper',
      //what is to be launched at app startup time
      home: Splash(),

      //  StreamBuilder(
      //   stream: AuthService().firebaseAuth.authStateChanges(),
      //   builder: (context, snapshot) {
      //     if (snapshot.hasData) {
      //       return Home();
      //     }
      //     return RegisterScreen();
      //   },
      // ),
    );
  }
}
