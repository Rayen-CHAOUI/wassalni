// ignore_for_file: avoid_print, non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:covoiturage/DRIVER/Register3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

  
class Register1 extends StatefulWidget
{
  const Register1({super.key});

  @override
  State<Register1> createState()
  {
    return _Register1State();
  }
}  

class _Register1State extends State<Register1>
{
  final _formKey1 = GlobalKey<FormState>(); //FAMILY NAME
  final _formKey6 = GlobalKey<FormState>(); //FIRST NAME
  final _formKey2 = GlobalKey<FormState>(); //NIS
  final _formKey3 = GlobalKey<FormState>(); //EMAIL
  final _formKey4 = GlobalKey<FormState>(); //PASSWORD
  final _formKey5 = GlobalKey<FormState>(); //PHONE

  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _familyNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _NISController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _imagePathController = TextEditingController();

  String _selectedSexe = 'Male'; // Default value
 
  bool _isPasswordObscured = true;
  bool _agreedToTerms = false;
  int _selectedYear = 1950; // Default year
//////////////////////// IMAGE /////////////////////////////////////////
  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      // Convert image to base64
      List<int> imageBytes = await _image!.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      // Print base64 encoded image for debugging
      print('Base64 Image: $base64Image');

        // Assuming you have obtained the image path
      String imagePath = _image!.path;

      // Set the image path to the TextField
      _imagePathController.text = imagePath;
    }
  }

void _showImagePicker(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext bc) {
      return SafeArea(
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                _pickImage(ImageSource.gallery);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Take a Photo'),
              onTap: () {
                try {
                  _pickImage(ImageSource.camera);
                } catch (e) {
                  print('Error opening camera: $e');
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    },
  );
}
/////////////////////////// YEAR LIST //////////////////////////////
      List<int> _getYearList() {
          return List<int>.generate(2024 - 1950 + 1, (index) => 1950 + index);
        }
////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context)
  {
/////////////////////////////////// Sign up //////////////////////////////////

     return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*1.35,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.blue[950],
                  image: const DecorationImage(
                    image: AssetImage('lib/icon/background.png'),
                    fit: BoxFit.cover,
                  ),
                ),
      
                child: Column(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: SizedBox(
                          child: DefaultTextStyle(
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                            child: Text(
                              'Register',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),

          //////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////// FAMILY NAME  INPUT //////////////////////////////////
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Material(
                          color: Colors.transparent,
                          child: Form(
                            key: _formKey1,
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 330, 
                                  child: TextFormField(
                                   controller: _familyNameController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Enter a valid name!';
                                      }
                                      return null;
                                    },
                                maxLength: 10,
                                decoration: InputDecoration(
                                labelText: 'Family Name',
                               // hintText: 'Enter your last name',
                                prefixIcon: const Icon(Icons.person),
                                prefixIconColor: Colors.white,
                                labelStyle: const TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                ),
                                style: const TextStyle(fontSize: 20),
                                ),
                                ),
                        ],
                      ),
                    ),
      
                  ),
                ),

///////////////////////////////// FIRST NAME  INPUT //////////////////////////////////
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Material(
                          color: Colors.transparent,
                          child: Form(
                            key: _formKey6,
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 330, 
                                  child: TextFormField(
                                   controller: _firstNameController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Enter a valid name!';
                                      }
                                      return null;
                                    },
                                maxLength: 20,
                                decoration: InputDecoration(
                                labelText: 'First Name',
                               // hintText: 'Enter your last name',
                                prefixIcon: const Icon(Icons.person),
                                prefixIconColor: Colors.white,
                                labelStyle: const TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                ),
                                style: const TextStyle(fontSize: 20),
                                ),
                                ),
                        ],
                      ),
                    ),
      
                  ),
                ),
                ///////////////////////////// NIS INPUT //////////////////////////////////
                
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Material(
                          color: Colors.transparent,
                          child: Form(
                            key: _formKey2,
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 330,
                                  child: TextFormField(
                                    controller: _NISController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(18),
                                    ],
                                    validator: (value) {
                                      if ( value == null || value.isEmpty || !RegExp(r'^\d{10}').hasMatch(value) )
                                      {
                                        return 'Enter a valid NIS !';
                                      }
                                      return null;
                                    },
                                    maxLength: 18,
                                    decoration: InputDecoration(
                                      labelText: 'NIS',
                                     // hintText: "numéro d'ID national ",
                                      prefixIcon: const Icon(Icons.numbers),
                                      prefixIconColor: Colors.white,
                                      labelStyle: const TextStyle( color: Colors.white),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(20)
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
      //////////////////////////////// PHONE NUMBER INPUT /////////////////////////////////////////////////////////
      
                Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Material(
                        color: Colors.transparent, // Set the color to transparent
                        child: Form(
                          key: _formKey5,
                          child: Column(
                            children: [
                              SizedBox(
                                width: 330,
                                child: TextFormField(
                                  controller: _phoneNumberController,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        !RegExp(r'^(05|06|07)\d{8}$').hasMatch(value)) {
                                      return 'Enter a valid Phone number!';
                                    }
                                    return null;
                                  },
                                  maxLength: 10,
                                  decoration: InputDecoration(
                                      labelText: 'Phone number',
                                     // hintText: 'Enter your number',
                                      prefixIcon: const Icon(Icons.phone),
                                      prefixIconColor: Colors.white,
                                      labelStyle: const TextStyle(color: Colors.white),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20))),
                                  style: const TextStyle(fontSize: 25),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
///////////////////////////// EMAIL ADDRESS INPUT //////////////////////////////
                
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                          child: Material(
                            color: Colors.transparent,
                        child: Form(
                          key: _formKey3,
                          child: Column(
                            children: [
                              SizedBox(
                                width: 330,
                                child: TextFormField(
                                  controller: _emailController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty || !RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(value))
                                    {
                                      return 'Enter a valid email !';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Email Address',
                                   // hintText: 'exemple@exemple.com',
                                    prefixIcon: const Icon(Icons.mail),
                                    prefixIconColor: Colors.white,
                                    labelStyle: const TextStyle( color: Colors.white),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20)
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

////////////////////////////// PASSWORD INPUT///////////////////////////////////
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                          child: Material(
                            color: Colors.transparent,
                        child: Form(
                          key: _formKey4,
                          child: Column(
                            children: [
                              SizedBox(
                                width: 330,
                                child: TextFormField(
                                  controller: _passwordController,
                                  obscureText: _isPasswordObscured,
                                  validator: (value) {
                                    if (value == null || value.isEmpty || !RegExp(r'^.{6,}$').hasMatch(value))
                                    {
                                      return 'more than 6 digits required !';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                   // hintText: 'Enter Password',
                                    prefixIcon: const Icon(Icons.lock),
                                    prefixIconColor: Colors.white,
                                    labelStyle: const TextStyle( color: Colors.white),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isPasswordObscured ? Icons.visibility : Icons.visibility_off,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isPasswordObscured = !_isPasswordObscured;
                                          }
                                        );
                                      },
                                    ),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20)
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

////////////////////////////// YEAR OF BIRTH INPUT /////////////////////////////////////////////////////////
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Material(
                        color: Colors.transparent,
                        child: Column(
                          children: [
                            SizedBox(
                              width: 330,
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                ),
                                child: DropdownButtonFormField<int>(
                                  value: _selectedYear,
                                  items: _getYearList().map((int year) {
                                    return DropdownMenuItem<int>(
                                      value: year,
                                      child: Text(year.toString()),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedYear = value!;
                                    });
                                  },
                                  decoration: const InputDecoration.collapsed(hintText: ''),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

/////////////////////////////////// GENDER /////////////////////////////
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Material(
                                color: Colors.transparent,
                                child: Form(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Sexe :',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                            ),
                                          ),
                                          Radio(
                                            value: 'Male',
                                            groupValue: _selectedSexe,
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedSexe = value.toString();
                                              });
                                            },
                                          ),
                                          const Text(
                                            'Male',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          Radio(
                                            value: 'Female',
                                            groupValue: _selectedSexe,
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedSexe = value.toString();
                                              });
                                            },
                                          ),
                                          const Text(
                                            'Female',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ), 
      
/////////////////////////////// IMAGE PICKER ////////////////////////////
             Padding(
                padding: const EdgeInsets.only(top: 20, left: 40, right: 40),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _showImagePicker(context);
                      },
                      child: const Text('Pick Image'),
                    ),
                    
                    const SizedBox(width: 15), // Add space between button and text field
                    Expanded(
                      child: TextField(
                        controller: _imagePathController,
                        enabled: false, 
                        decoration: InputDecoration(
                          labelText: 'Driving licence',
                          prefixIcon: const Icon(Icons.photo),
                          prefixIconColor: Colors.white,
                          labelStyle: const TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),

/////////////////////////////////// CHECKBOX /////////////////////////////
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Material( 
                      color: Colors.transparent,
                      child: Row(        
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: _agreedToTerms,
                          onChanged: (bool? value) {
                            setState(() {
                              _agreedToTerms = value!;
                            });
                          },
                        ),
                        
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              _agreedToTerms = !_agreedToTerms;
                            });
                          },
                          child: const Row(
                            children: [
                              Text(
                                'I promise that ',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                'the information is correct',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ), 
      
/////////////////////////////////// NEXT BUTTON /////////////////////////////
                     Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Center(
                            child: SizedBox(
                              width: 200,
                              height: 50,
                              child: ElevatedButton(
      
                                onPressed: _agreedToTerms
                                    ? () {
                                        if (_formKey1.currentState!.validate() &
                                            _formKey2.currentState!.validate() &
                                            _formKey3.currentState!.validate() &
                                            _formKey4.currentState!.validate() &
                                            _formKey5.currentState!.validate() &
                                            _formKey6.currentState!.validate()  ) {
            
                                          // GO TO 2ND PAGE
                                         Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Register3(
                                                familyName: _familyNameController.text,
                                                firstName: _firstNameController.text,
                                                NIS: _NISController.text,
                                                email: _emailController.text,
                                                phoneNumber: _phoneNumberController.text,
                                                password: _passwordController.text,
                                                gender: _selectedSexe,
                                                yearOfBirth: _selectedYear.toString(),
                                                imagePath: _imagePathController.text,
                                              ),
                                            ),
                                          );

                                        }
                                      }
                                    : null,
      
                                style: ButtonStyle(
                                  backgroundColor: _agreedToTerms
                                      ? MaterialStateProperty.all(Colors.white)
                                      : MaterialStateProperty.all(Colors.grey), // Change the background color when checkbox is unchecked
                                  foregroundColor: MaterialStateProperty.all(Colors.black),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  'NEXT',
                                  style: TextStyle(fontSize: 30), // Set the font size here
                                ),
                              ),
                            ),
                          ),
                        ),
      
                
                
////////////////////////////////////////////////////////////////////////////////
                
                
                
                
////////////////////////////////////////////////////////////////////////////////
                    ]
                ),
              ),
            ],
          )
        ),
      )
    );
  }
}
