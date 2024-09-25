// ignore_for_file: file_names, use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:interconnect/Helper/showSnackbar.dart';
import 'package:interconnect/Screens/chatPage.dart';
import 'package:interconnect/components/CustomButton.dart';
import 'package:interconnect/components/customTextFormField.dart';
import 'package:interconnect/constants.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  static const String id = "SignUpPage";

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String? email;
  String? password;
  String? confirmPassword;
  String? firstName;
  String? lastName;
  @override
  void initState() {
    super.initState();
    email = null;
    password = null;
    confirmPassword = null;
    firstName = null;
  }

  GlobalKey<FormState> formKey = GlobalKey();

  bool isLoading = false;

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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    kLogo,
                    width: 100,
                    height: 100,
                    alignment: Alignment.center,
                  ),
                  const Text(
                    'InterConnect',
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: "BaskervvilleSC"),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomTextFormField(
                    validator: (data) {
                      if (data == null || data.isEmpty) {
                        return 'Please enter your first name';
                      }
                      if (!RegExp(r'^[a-zA-Z\u0621-\u064A\s]+$')
                          .hasMatch(data)) {
                        return 'The text should contain letters only (no numbers or symbols)';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      firstName = value;
                    },
                    hint: 'First Name',
                    label: 'First Name',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextFormField(
                    validator: (data) {
                      if (data == null || data.isEmpty) {
                        return 'Please enter your last name';
                      }
                      if (!RegExp(r'^[a-zA-Z\u0621-\u064A\s]+$')
                          .hasMatch(data)) {
                        return 'The text should contain letters only (no numbers or symbols)';
                      }

                      return null;
                    },
                    onSaved: (value) {
                      lastName = value;
                    },
                    hint: 'Last Name',
                    label: 'Last Name',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextFormField(
                    validator: (data) {
                      if (data == null || data.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$')
                          .hasMatch(data)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      email = value;
                    },
                    hint: '@gmail.com',
                    label: 'Email',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextFormField(
                    validator: (data) {
                      if (data == null || data.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (!RegExp(r'[A-Z]').hasMatch(data)) {
                        return 'Password must contain at least one uppercase letter';
                      }

                      if (!RegExp(r'[a-z]').hasMatch(data)) {
                        return 'Password must contain at least one lowercase letter';
                      }

                      if (!RegExp(r'[0-9]').hasMatch(data)) {
                        return 'Password must contain at least one number';
                      }

                      if (!(RegExp(r'[!@#\$&*~_-]').hasMatch(data))) {
                        return 'Password must contain at least one special character (e.g. -!@#\$&*~_)';
                      }

                      if (data.length < 8) {
                        return 'Password must be at least 8 characters long';
                      }
                      formKey.currentState!.save();
                      return null;
                    },
                    onSaved: (value) {
                      password = value;
                    },
                    hint: 'Password',
                    label: 'Password',
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextFormField(
                    validator: (data) {
                      if (data == null || data.isEmpty) {
                        return 'Please confirm your password';
                      }
                      formKey.currentState!.save();
                      if (password != confirmPassword) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      confirmPassword = value;
                    },
                    hint: 'Password',
                    label: 'Confirm Password',
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();

                        setState(() {
                          isLoading = true;
                        });

                        try {
                          await registerUser();
                          await saveUserEmail(email!);
                          showSnackBar(context, 'Registered Successfully.');
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatPage(email: email!)),
                          );
                        } on FirebaseAuthException catch (e) {
                          switch (e.code) {
                            case 'weak-password':
                              showSnackBar(context,
                                  'The password provided is too weak.');
                              break;
                            case 'email-already-in-use':
                              showSnackBar(context,
                                  'The account already exists for that email.');
                              break;
                            case 'network-request-failed':
                              showSnackBar(
                                  context, 'Network error. Please try again.');
                              break;
                            default:
                              showSnackBar(context, e.code);
                              break;
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
                    buttonText: 'Sign Up',
                    underlinedText: 'Sign In',
                    text: "Already have an account?",
                    pageRoute: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> registerUser() async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!);
  }

  Future<void> saveUserEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userEmail', email);
  }
}
