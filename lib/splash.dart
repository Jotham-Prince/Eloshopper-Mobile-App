//This is the splash screen of the application

//These are the main imports of the application
import 'package:best_eshopper_application/screens/login.dart';
import 'package:flutter/material.dart';

//it starts as a statefulwidget coz its state changes when the app is loaded
class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  //override the initState of the whole application to show the specificed function
  @override
  void initState() {
    super.initState();
    //function called when the splash screen is done loading
    _navigatetohome();
  }

  //async function called when the splash screen is done loading
  _navigatetohome() async {
    //Delay loading by specificed seconds
    await Future.delayed(const Duration(milliseconds: 1500));
    //after the specificed seconds load the home screen
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

//UI of the splash screen with the logo being loaded
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset('assets/images/logo.png')],
          ),
        ),
      ),
    );
  }
}
