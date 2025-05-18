// ignore_for_file: use_key_in_widget_constructors
 
import 'package:covoiturage/DRIVER/MainPageDriver.dart';
import 'package:covoiturage/DRIVER/Register1.dart';
import 'package:covoiturage/Backend/Endpoints.dart';
import 'package:covoiturage/ResetPasswordPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({Key? key});

  @override
  State<CreateUser> createState() {
    return _CreateUserState();
  }
}

class _CreateUserState extends State<CreateUser> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();

  bool _isPasswordObscured = true;
  bool _isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Function to show an alert dialog
  void _showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Alert"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }



//////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 500,
              height: 834,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.blue[950],
                image: const DecorationImage(
                  image: AssetImage('lib/icon/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
///////////////////////////////////////////////////////////////////////
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: SizedBox(
                      width: 190,
                      height: 50,
                      child: DefaultTextStyle(
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                        child: Text(
                          'Connexion',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
///////////////////////////////////////////////////////////////////
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Material(
                      color: Colors.transparent,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            SizedBox(
                              width: 340,
                              child: TextFormField(
                                controller: _emailController,
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      !RegExp(
                                              r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                                          .hasMatch(value)) {
                                    return 'Enter a valid email!';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    labelText: 'Email Address',
                                    hintText: 'Email address',
                                    prefixIcon: const Icon(Icons.mail),
                                    prefixIconColor:
                                        const Color.fromARGB(255, 255, 255, 255),
                                    labelStyle:
                                        const TextStyle(color: Colors.white),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20))),
                                style: const TextStyle(
                                  fontSize: 25,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
////////////////////////////////////////////////////////////////
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Material(
                      color: Colors.transparent,
                      child: Form(
                        key: _formKey2,
                        child: Column(
                          children: [
                            SizedBox(
                              width: 340,
                              child: TextFormField(
                                controller: _passwordController,
                                obscureText: _isPasswordObscured,
                                validator: (value2) {
                                  if (value2 == null ||
                                      value2.isEmpty ||
                                      !RegExp(r'^.{6,}$').hasMatch(value2)) {
                                    return 'Enter valid Password!';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    labelText: 'Password',
                                    hintText: 'Enter Password',
                                    prefixIcon: const Icon(Icons.lock),
                                    prefixIconColor: Colors.white,
                                    labelStyle:
                                        const TextStyle(color: Colors.white),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isPasswordObscured
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isPasswordObscured =
                                              !_isPasswordObscured;
                                        });
                                      },
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    )),
                                style: const TextStyle(fontSize: 25),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ), 
                  ),
///////////////////////////////////////////////////////////////////
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Center(
                      child: SizedBox( 
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
 
                            if (_formKey.currentState!.validate() &&
                                _formKey2.currentState!.validate()) {

                              setState(() {
                                _isLoading = true;
                              }); 
 
                              await Future.delayed(const Duration(seconds: 2)); // Add delay
                              final response = await http.post(
                                Uri.parse(createUserAPI),
                                headers: {'Content-Type': 'application/json'},
                                body: jsonEncode({
                                  'email': _emailController.text,
                                  'password': _passwordController.text,
                                }),
                              ); 

                              if (response.statusCode == 200) {
                                final responseData = jsonDecode(response.body);
                                final authToken = responseData['token'];

                                // Save the JWT token to shared preferences
                                final SharedPreferences prefs = await SharedPreferences.getInstance();
                                await prefs.setString('authToken', authToken);
                                // Display the stored token
                                print('Stored token: $authToken');
                                
                                // Navigate to the main page after successful login
                                // ignore: use_build_context_synchronously
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return const MainPageDriver();
                                  }),
                                );

                              } else {
                                print('Login failed: ${response.body}');
                                _showAlertDialog("incorrect password or email !");
                              }

                              setState(() {
                                _isLoading = false;
                              });
                            }
                          },

                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.white),
                            foregroundColor: MaterialStateProperty.all(Colors.black),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),

                          child: _isLoading
                              ? const CircularProgressIndicator() // Circular progress indicator
                              : const Text(
                                  'Connect',
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.black,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
////////////////////////////////////////////////////////////////////////////////////
                  DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return const ResetPasswordPage();
                            }),
                          );
                        },
                        child: const Text(
                          "Password forgotten ?",
                        ),
                      ),
                    ),
                  ),
///////////////////////////////////////////////////////////////////////////////
                  const Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 90,
                          height: 50,
                          child: Image(
                            image: AssetImage('lib/icon/twitter.png'),
                          ),
                        ),

                        SizedBox(
                          width: 90,
                          height: 50,
                          child: Image(
                            image: AssetImage('lib/icon/facebook (1).png'),
                          ),
                        ),

                        SizedBox(
                          width: 90,
                          height: 50,
                          child: Image(
                            image: AssetImage('lib/icon/search.png'),
                          ),
                        ),
                      ],
                    ),
                  ),
/////////////////////////////////////////////////////////////////////////
                  const Padding(
                    padding: EdgeInsets.only(top: 150),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [

                                Expanded(
                                  child: Divider(
                                    color: Colors.white,
                                    thickness: 3,
                                  ),
                                ),

                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                                  child: DefaultTextStyle(
                                    style: TextStyle(fontSize: 20),
                                    child: Text('OR'),
                                  ),
                                ),

                                Expanded(
                                  child: Divider(
                                    color: Colors.white,
                                    thickness: 3,
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
/////////////////////////////////////////////////////////////////////////////
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Center(
                      child: SizedBox(
                        width: 250,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return const Register1();
                              }),
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.white),
                            foregroundColor: MaterialStateProperty.all(Colors.black),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          child: const Text(
                            'Create an account',
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
///////////////////////////////////////////////////////////////////////////////
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

