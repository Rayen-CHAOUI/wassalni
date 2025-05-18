// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:covoiturage/DRIVER/MainPageDriver.dart';
import 'package:covoiturage/Backend/Endpoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

  
class AddCar extends StatefulWidget
{
  final String fullName;
  final String idNumber;
  final String email;
  final String phoneNumber;
  final String gender;
  final String imagePath;
  final String password;
  
  const AddCar({
    super.key, 
    required this.fullName,
    required this.idNumber, 
    required this.email,
    required this.phoneNumber,
    required this.gender, 
    required this.imagePath,
    required this.password
      });

  @override
  State<AddCar> createState()
  {
    return _Register3State();
  }
}

class _Register3State extends State<AddCar>
{
  final _formKey1 = GlobalKey<FormState>(); //CAR NAME
  final _formKey2 = GlobalKey<FormState>(); //MARQUE
  final _formKey3 = GlobalKey<FormState>(); //YEAR
  final _formKey4 = GlobalKey<FormState>(); //IMMATRICULATION

  final TextEditingController _carNamerController = TextEditingController();
  final TextEditingController _carMarqueController = TextEditingController();
  final TextEditingController _carYearController = TextEditingController();
  final TextEditingController _immatricController = TextEditingController();
  final TextEditingController _imagePathController = TextEditingController();


/////////////////////////// IMAGE /////////////////////////////////////////

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
/////////////////// DATABASE /////////////////////////////////////////

Future<void> _saveCarData(
      String fullName,
      String idNumber,
      String email,
      String phoneNumber,
      String gender, 
      String imagePath, 
      String password,
      //String JwtToken,
      ) async {
  final url = Uri.parse(register3API);

  // Convert image to base64
  String? base64Image;
  if (_image != null) {
    List<int> imageBytes = await _image!.readAsBytes();
    base64Image = base64Encode(imageBytes); 
  }
  
  try {
    await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        //'Authorization': 'Bearer $JwtToken',
      },
      body: jsonEncode({
        'fullName': fullName,
        'idNumber': idNumber,
        'email': email,
        'phoneNumber': phoneNumber,
        'gender': gender,
        'profileImage': imagePath,
        'password': password,
        'carData': {
          'carName': _carNamerController.text,
          'carMarque': _carMarqueController.text,
          'year': _carYearController.text,
          'immatric': _immatricController.text, 
          'carteGrise': base64Image,
        },
      }),
    );
    // Handle success or show a success message
    print('Driver data saved successfully!');
  } catch (error) {
    // Handle error or show an error message
    print('Error saving driver data: $error');
  }
}
////////////////////////////////////////////////////



  @override
  Widget build(BuildContext context)
  {
/////////////////////////////////// Sign up //////////////////////////////////

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
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
                      padding: EdgeInsets.only(top: 50),
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
                            'Car information',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
             //////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////// CAR NAME  INPUT //////////////////////////////////
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Material(
                      color: Colors.transparent,
                      child: Form(
                        key: _formKey1,
                        child: Column(
                          children: [
                            SizedBox(
                              width: 330, 
                              child: TextFormField(
                               controller: _carNamerController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Fill in the gap !';
                                  }
                                  return null;
                                },
                            maxLength: 35,
                            decoration: InputDecoration(
                            labelText: 'Car Name',
                           // hintText: 'Enter the name',
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
            
///////////////////////////// MARQUE INPUT //////////////////////////////////
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
                               controller: _carMarqueController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Fill in the gap !';
                                  }
                                  return null;
                                },
                            maxLength: 35,
                            decoration: InputDecoration(
                            labelText: 'Car Marque',
                           // hintText: 'Enter the marque',
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
            
            //////////////////////////////// YEAR INPUT /////////////////////////////////////////////////////////
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
                              controller: _carYearController,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ) {
                                  return 'Fill in the gap !';
                                }
                                return null;
                              },
                              maxLength: 10,
                              decoration: InputDecoration(
                                  labelText: 'Year',
                                 // hintText: 'Enter the year',
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
///////////////////////////// IMMATRICULATION INPUT //////////////////////////////
                 Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Material(
                        color: Colors.transparent,
                        child: Form(
                          key: _formKey4,
                          child: Column(
                            children: [
                              SizedBox(
                                width: 330,
                                child: TextFormField(
                                  controller: _immatricController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(11),
                                    _ImmatriculationFormatter(),
                                  ],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Fill in the gap !';
                                    }
                                    return null;
                                  },
                                  maxLength: 12,
                                  decoration: InputDecoration(
                                    labelText: 'Immatriculation',
                                    // hintText: 'XXXXX XXX XX',
                                    prefixIcon: const Icon(Icons.mail),
                                    prefixIconColor: Colors.white,
                                    labelStyle: const TextStyle(color: Colors.white),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  style: const TextStyle(fontSize: 25),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
/////////////////////////// IMAGE ///////////////////////////
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
                          labelText: 'Grey card',
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
/////////////////////////////////// NEXT BUTTON /////////////////////////////
            
                 Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Center(
                        child: SizedBox(
                          width: 200,
                          height: 50,
                          child: ElevatedButton(

                            onPressed: 
                                 () {
                                    if (_formKey1.currentState!.validate() &
                                        _formKey2.currentState!.validate() &
                                        _formKey3.currentState!.validate() &
                                        _formKey4.currentState!.validate()  ) {

                                            _saveCarData(
                                              widget.fullName,
                                               widget.idNumber,
                                               widget.email,
                                               widget.phoneNumber,
                                               widget.gender,
                                               widget.imagePath,
                                               widget.password,
                                            );

                                      // GO TO 2ND PAGE
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) {
                                          return  const MainPageDriver();
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
                              'Add the car',
                              style: TextStyle(fontSize: 30), 
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
        ]
        ),
      )
    );
  }
}


class _ImmatriculationFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text.replaceAll(RegExp(r'\s|\D'), ''); // Remove non-digit characters
    var formattedText = '';

    for (var i = 0; i < newText.length; i++) {
      if (i == 5 || i == 8) {
        formattedText += '-'; // Add dash after the 5th and 8th digits
      }
      formattedText += newText[i];
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}


