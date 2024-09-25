// ignore_for_file: file_names, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:interconnect/Helper/showSnackbar.dart';
import 'package:interconnect/Screens/chatPage.dart';
import 'package:interconnect/Screens/signUpPage.dart';
import 'package:interconnect/components/CustomButton.dart';
import 'package:interconnect/components/customTextFormField.dart';
import 'package:interconnect/constants.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});
  static const String id = "SignInPage";

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String? email;
  String? password;

  GlobalKey<FormState> formKey = GlobalKey();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    email = null;
    password = null;
    checkUserLoggedIn();
  }

  void checkUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('userEmail');

    if (email != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ChatPage(email: email)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Form(
              autovalidateMode: AutovalidateMode.disabled,
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Center(child: Image.asset(kLogo, width: 100, height: 100)),
                  const Center(
                    child: Text(
                      'InterConnect',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomTextFormField(
                    validator: (data) => data == null || data.isEmpty
                        ? 'Please enter your email'
                        : null,
                    onSaved: (value) => email = value,
                    hint: '@gmail.com',
                    label: 'Email',
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          validator: (data) => data == null || data.isEmpty
                              ? 'Please enter your password'
                              : null,
                          onSaved: (value) => password = value,
                          hint: 'Password',
                          label: 'Password',
                          obscureText: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    hoverColor: Colors.transparent,
                    onTap: () async {
                      formKey.currentState!.save();
                      email!.trim();
                      if (email != null && email!.isNotEmpty) {
                        try {
                          await FirebaseAuth.instance
                              .sendPasswordResetEmail(email: email!);
                          showSnackBar(context,
                              "Password reset email sent to $email.\nplease check your email");
                        } on FirebaseAuthException catch (e) {
                          // Handle specific Firebase exceptions
                          showSnackBar(context, 'Error: ${e.message}');
                        } catch (e) {
                          showSnackBar(
                              context, 'Unexpected error: ${e.toString()}');
                        }
                      } else {
                        showSnackBar(context, 'Please enter your email.');
                      }
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white60,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white60,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        setState(() => isLoading = true);
                        try {
                          await loginUser();
                          await saveUserEmail(email!);
                          showSnackBar(context, 'Logged In Successfully.',
                              duration: 300);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatPage(email: email!)),
                          );
                        } on FirebaseAuthException catch (e) {
                          switch (e.code) {
                            case 'user-not-found':
                              showSnackBar(
                                  context, 'No user found for that email.');
                              break;
                            case 'wrong-password':
                              showSnackBar(context, 'Wrong password provided.');
                              break;
                            case 'invalid-email':
                              showSnackBar(
                                  context, 'The email address is not valid.');
                              break;
                            case 'network-request-failed':
                              showSnackBar(
                                  context, 'Network error. Please try again.');
                              break;
                            default:
                              showSnackBar(context, 'Error: ${e.message}');
                          }
                        } catch (e) {
                          showSnackBar(context, e.toString());
                        } finally {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      }
                    },
                    buttonText: 'Sign In',
                    underlinedText: 'Sign Up',
                    text: "Don't have an account?",
                    pageRoute: () {
                      Navigator.pushNamed(context, SignUpPage.id);
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loginUser() async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
  }

  Future<void> saveUserEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userEmail', email);
  }
}
