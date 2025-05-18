// ignore_for_file: use_build_context_synchronously, file_names

import 'package:covoiturage/DRIVER/MainPageDriver.dart';
import 'package:flutter/material.dart';



class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key});

  @override
  State<ResetPasswordPage> createState() {
    return _ResetPasswordPageState();
  }
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
    final GlobalKey<FormState> _formKey3 = GlobalKey<FormState>();


  bool _isPasswordObscured = true;
  final TextEditingController _emailController = TextEditingController();
    final TextEditingController _codeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
///////////////////////////////////////////////////////////////////////////////////////
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
              //////////////////////////////////////////////////////////////////////
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: SizedBox(
                      width: 500,
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
                          'Change password',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
//////////////////////////////////////////////////////////////////
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
/////////////////////////////////////////////////////////////
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
                                controller: _codeController,
                                validator: (value2) {
                                  if (value2 == null ||
                                      value2.isEmpty ) {
                                    return 'Code invalide !';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    labelText: 'Confirmation code',
                                    hintText: 'Enter code',
                                    prefixIcon: const Icon(Icons.numbers_outlined),
                                    prefixIconColor: Colors.white,
                                    labelStyle:
                                        const TextStyle(color: Colors.white),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    )
                                    ),
                                style: const TextStyle(fontSize: 25),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

/////////////////////////////////////////////////
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Material(
                      color: Colors.transparent,
                      child: Form(
                        key: _formKey3,
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
                                    labelText: 'New password',
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
//////////////////////////////////////////////////////////////
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
                             

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return const MainPageDriver();
                                  }),
                                );

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
                          child: const Text(
                            'Reset password',
                            style: TextStyle(
                              fontSize: 23,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
//////////////////////////////////////////////////////////////
                    
                  
                  //////////////////////////////////////////////////////
           
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
