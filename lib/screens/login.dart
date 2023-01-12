//THE LOGIN SCREEN FOR THE APPLICATION
import 'package:best_eshopper_application/screens/home.dart';
import 'package:best_eshopper_application/screens/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //Controllers that get input from the specificed input fields of the login screen
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  //loading state set to false
  //this is for the cicular process indicator
  bool loading = false;

  //UI of the login page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(children: [
        const Divider(
          height: 50,
        ),
        Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 4,
            child: Image.asset(
              'assets/images/logo.png',
              height: 100,
              width: 100,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          "Login Here!",
          textAlign: TextAlign.right,
          style: TextStyle(
              color: Colors.orange,
              height: 1.5,
              fontSize: 30,
              fontFamily: 'Luzern'),
        ),
        Container(
          margin: const EdgeInsets.only(left: 16.0, right: 21.0),
          height: MediaQuery.of(context).size.height / 1.67,
          width: MediaQuery.of(context).size.width,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontFamily: 'Josefin'),
                  controller: emailController,
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                      width: 3,
                      color: Colors.black45,
                    )),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 3,
                        color: Colors.black45,
                      ),
                    ),
                    hintText: "Enter your Email Address",
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff888b91),
                      fontSize: 18,
                    ),
                  ),
                ),
                TextField(
                  style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontFamily: 'Josefin'),
                  controller: passwordController,
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                      width: 3,
                      color: Colors.black45,
                    )),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 3,
                        color: Colors.black45,
                      ),
                    ),
                    hintText: "Enter your password",
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff888b91),
                      fontSize: 18,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        //when the text is clicked, then move onto the register page
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const RegisterScreen()));
                      },
                      child: const Text(
                        "Click here to register for an account.",
                        style: TextStyle(
                          fontFamily: 'Josefin',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    )
                  ],
                ),
                Center(
                  //this is where the circular indicator for loading is placed
                  child: loading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          height: 60,
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                loading = true;
                              });
                              //Validate the imput placed into the fields if null
                              if (emailController.text == "" ||
                                  passwordController.text == "") {
                                //show the snackbar when there is an error
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("All Fields are required!"),
                                  backgroundColor: Colors.red,
                                ));
                              } else {
                                //if the fields are properly entered then send the input
                                //info to the auth_service firebase backend so that we are able to login
                                User? result = await AuthService().login(
                                    emailController.text,
                                    passwordController.text,
                                    context);
                                if (result != null) {
                                  //we are going to log in if the firebase backend returns some info
                                  // to us
                                  // ignore: use_build_context_synchronously
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          //move onto the home page on successfull login
                                          builder: (context) => const Home()),
                                      (route) => false);
                                }
                              }
                              setState(() {
                                //set the loading circular state back to false
                                //after the whole process is done
                                loading = true;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black87,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28.0),
                              ),
                            ),
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                fontFamily: 'Josefin',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                        ),
                ),
                const Divider(),
                const SizedBox(
                  height: 10,
                ),
                loading
                    ? const Center(child: CircularProgressIndicator())
                    : Center(
                        child: SignInButton(Buttons.Google,
                            text: "Continue with Google", onPressed: () async {
                          setState(() {
                            loading = true;
                          });
                          //call the google sign in function
                          await AuthService().signInWithGoogle();
                          setState(() {
                            loading = false;
                          });
                        }),
                      ),
              ]),
        )
      ])),
    );
  }
}
