import 'package:email_validator/email_validator.dart';
import 'package:esyearn/dashboard/dashboard.dart';
import 'package:esyearn/lib/firebase_auth.dart';
import 'package:esyearn/login.dart';
import 'package:esyearn/reg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GiveEmail extends StatefulWidget {
  @override
  _GiveEmailState createState() => _GiveEmailState();
}

class _GiveEmailState extends State<GiveEmail> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpCode = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  FirebaseAuthService auth = FirebaseAuthService();
  bool _isLoading = false;
  String _errorMessage = '';

  // Future<bool> checkIfEmailExists(String email) async {
  //   try {
  //     List<String> signInMethods =
  //         await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
  //     return signInMethods.isNotEmpty;
  //   } catch (error) {
  //     print("Error checking email existence: $error");
  //     return false;
  //   }
  // }

  // void checkAndProceed() async {
  //   if (_formKey.currentState!.validate()) {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     bool emailExists = await checkIfEmailExists(_emailController.text);
  //     if (emailExists) {
  //       // Add logic here to handle the case when the email exists
  //     } else {
  //       setState(() {
  //         _isLoading = false;
  //         _errorMessage = "User Email Dose not Exist";
  //       });
  //       // Add logic here to handle the case when the email does not exist
  //     }
  //   }
  // }

  Future<void> sendPasswordResetEmail(
      BuildContext context, String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Password Reset"),
            content: Text("Password reset email has been sent."),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = "No user found for that email.";
      } else {
        errorMessage = "An error occurred: ${e.message}";
      }

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } catch (error) {
      print("Error sending password reset email: $error");
    }
  }

  void _navigateToSignup(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignupPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                // image: DecorationImage(
                //   image: AssetImage('assets/images/welcome_page_02.webp'),
                //   fit: BoxFit.cover,
                // ),
                ),
          ),
          Container(
            color: Color.fromARGB(255, 94, 150, 29).withOpacity(0.5),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(image: AssetImage('assets/images/showcase_01.png')),
                  if (_errorMessage.isNotEmpty)
                    Text(
                      _errorMessage,
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          backgroundColor: Colors.white.withOpacity(0.5)),
                    ),
                  Text(
                    'Forgot Password',
                    style: TextStyle(
                      fontSize: 32,
                      color: const Color.fromARGB(255, 27, 0, 0),
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black.withOpacity(0.5),
                          offset: Offset(3.0, 3.0),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              color: const Color.fromARGB(255, 17, 0, 0),
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  blurRadius: 10.0,
                                  color: Colors.black.withOpacity(0.5),
                                  offset: Offset(3.0, 3.0),
                                ),
                              ],
                            ),
                            filled: true,
                            fillColor: Color.fromARGB(255, 250, 243, 243)
                                .withOpacity(0.3),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.black.withOpacity(0.5),
                                offset: Offset(3.0, 3.0),
                              ),
                            ],
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            } else if (!EmailValidator.validate(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        _isLoading
                            ? CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  String email = _emailController.text.trim();
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  if (email.isNotEmpty) {
                                    sendPasswordResetEmail(context, email);
                                  } else {
                                    setState(() {
                                      _isLoading = false;
                                      _errorMessage =
                                          "User Email Dose not Exist";
                                    });
                                    //print("Please enter an email address.");

                                    // Optionally, show a message to the user
                                  }
                                },
                                child: Text(
                                  'Send Reset Link',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.black.withOpacity(0.5),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  textStyle: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          },
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black.withOpacity(0.5),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 15), // Adjust the padding as needed
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
