// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:covoiturage/Backend/wilaya.dart';
import 'package:covoiturage/Backend/Endpoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddDepannage extends StatefulWidget {
  const AddDepannage({Key? key});

  @override
  _AddDepannageState createState() => _AddDepannageState();
}

class _AddDepannageState extends State<AddDepannage> {
  final TextEditingController _locationController = TextEditingController();
  //final _formKey1 = GlobalKey<FormState>();
  final List<String> _searchResult = [];

  void _onSearchTextChanged(String value) {
    _searchResult.clear();
    if (value.isEmpty) {
      setState(() {});
      return;
    }

    for (var item in wilaya) {
      if (item.toLowerCase().contains(value.toLowerCase())) {
        _searchResult.add(item);
      }
    }

    setState(() {});
  }

  void _fillTextField(String value) {
    setState(() {
      _locationController.text = value;
      _searchResult.clear();
    });
  }

  Future<void> _saveDepannage(BuildContext context) async {
    final url = Uri.parse(addDepannageAPI);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken');
    try {
      await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $authToken',
        },
        body: jsonEncode({
          'location': _locationController.text,
        }),
      );
      print('Depannage data saved successfully!');
      // Show AlertDialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('Depannage added successfully!'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close AlertDialog
                  Navigator.of(context).pop(); // Return to previous page
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      print('Error saving depannage data: $error');
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isButtonEnabled = _locationController.text.isNotEmpty;

    Color buttonColor = isButtonEnabled ? Colors.white : Colors.grey;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
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
                  const DefaultTextStyle(
                    style: TextStyle(
                      fontSize: 34,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        "Add Towing offer",
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Material(
                      color: Colors.transparent,
                      child: SizedBox(
                        width: 340,
                        child: TypeAheadField(
                          textFieldConfiguration: TextFieldConfiguration(
                            decoration: InputDecoration(
                              labelText: "Location",
                              hintText: "Enter the location",
                              prefixIcon: const Icon(Icons.location_on),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _locationController.clear();
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onChanged: (value) {
                              _onSearchTextChanged(value);
                            },
                            controller: _locationController,
                          ),
                          suggestionsCallback: (pattern) {
                            return wilaya.where((item) => item.toLowerCase().contains(pattern.toLowerCase()));
                          },
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              title: Text(suggestion),
                            );
                          },
                          onSuggestionSelected: (suggestion) {
                            _fillTextField(suggestion);
                          },
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 120),
                    child: Center(
                      child: SizedBox(
                        width: 330,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: isButtonEnabled
                              ? () {
                                  _saveDepannage(context);
                                }
                              : null,
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(buttonColor),
                            foregroundColor: MaterialStateProperty.all(Colors.black),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          child: const Text(
                            'Add Towing',
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
