import 'package:best_eshopper_application/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'login.dart';

// ignore: must_be_immutable
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  //Controllers that pick input from the specificed text fields
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  //Boolean for the spinner showing the loading process
  //set to false because no button has been pressed to submit anything
  bool loading = false;

  //UI of the register page
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
          "Register Here!",
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
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    hintText: "Enter your password",
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 127, 130, 135),
                      fontSize: 18,
                    ),
                  ),
                ),
                TextField(
                  style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontFamily: 'Josefin'),
                  controller: confirmPasswordController,
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
                    hintText: "Confirm your password",
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
                      //When someone taps on the text, route to the login page
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const LoginScreen()));
                      },
                      child: const Text(
                        "Click Here to Login",
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
                  //where the loading circular indicator is placed
                  child: loading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          height: 60,
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                //changes to state of the loading indicator to true
                                //so that it is visible
                                loading = true;
                              });
                              //Validate and make sure the text fields are not empty
                              if (emailController.text == "" ||
                                  passwordController.text == "") {
                                //if empty, show snackbar error messages
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("All Fields are required!"),
                                  backgroundColor: Colors.red,
                                ));
                                //check if the passwords in the two fields are matching
                              } else if (passwordController.text !=
                                  confirmPasswordController.text) {
                                //else show the snackbar error message
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("Passwords Don't match!"),
                                  backgroundColor: Colors.red,
                                ));
                              } else {
                                //if all is okay, then send the inputs to the auth_service function
                                //so that it sends the input to the Firebase backend for registration
                                User? result = await AuthService().register(
                                    emailController.text,
                                    passwordController.text,
                                    context);
                                if (result != null) {
                                  //if the response from the Firebase backend is not empty
                                  //it means that our user has been registered successfully
                                  debugPrint("User created successfully");
                                  debugPrint(result.email);
                                }
                              }
                              setState(() {
                                //after the user has been registered successfully
                                //set back the loading state to false and remove the
                                //circular loading process
                                loading = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black87,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28.0),
                              ),
                            ),
                            child: const Text(
                              "Register",
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
