// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:covoiturage/Backend/wilaya.dart';
import 'package:covoiturage/Backend/Endpoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class ShareRide extends StatefulWidget {
  const ShareRide({Key? key});

  @override
  _ShareRideState createState() => _ShareRideState();
}

class _ShareRideState extends State<ShareRide> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _secondSearchController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();

  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  DateTime? _selectedDate;
  int _selectedSeats = 0;
  TimeOfDay? _selectedTime;

Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  } 
 
  Future<void> _saveRide(BuildContext context) async {
  final url = Uri.parse(shareRidesAPI);
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
        'depart': _searchController.text,
        'location': _secondSearchController.text,
        'date': _selectedDate != null ? DateFormat('dd-MM-yyyy').format(_selectedDate!) : null,
        'seats': _selectedSeats,
        'price': _priceController.text,
        'time': _selectedTime != null ? '${_selectedTime!.hour}:${_selectedTime!.minute}' : null,
        'meetPlace': _placeController.text,
      }),
    );
    print('RIDE data saved successfully!');
    // Show AlertDialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Ride shared successfully!'),
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
    print('Error saving RIDE data: $error');
  }
}

  final List<String> _searchResult1 = [];
  final List<String> _searchResult2 = [];

  void _onSearchTextChanged(String value) {
    _searchResult1.clear();
    if (value.isEmpty) {
      setState(() {});
      return;
    }

    for (var item in wilaya) {
      if (item.toLowerCase().contains(value.toLowerCase())) {
        _searchResult1.add(item);
      }
    }

    setState(() {});
  }

  void _onSecondSearchTextChanged(String value) {
    _searchResult2.clear();
    if (value.isEmpty) {
      setState(() {});
      return;
    }

    for (var item in wilaya) {
      if (item.toLowerCase().contains(value.toLowerCase())) {
        _searchResult2.add(item);
      }
    }

    setState(() {});
  }

  void _fillFirstTextField(String value) {
    setState(() {
      _searchController.text = value;
      _searchResult1.clear();
    });
  }

  void _fillSecondTextField(String value) {
    setState(() {
      _secondSearchController.text = value;
      _searchResult2.clear();
    });
  }
///////////////////////////////////////////////////////////
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    } 
  }
/////////////////////////////////////////////////////////////////////////////////////////////
  @override 
  Widget build(BuildContext context) {
    bool isButtonEnabled = _searchController.text.isNotEmpty &&
        _secondSearchController.text.isNotEmpty &&
        _selectedDate != null &&
        _selectedSeats > 0;

    Color buttonColor = isButtonEnabled ? Colors.white : Colors.grey;

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

///////////////////////// TEXT ////////////////////////////////////////
                  const DefaultTextStyle(
                    style: TextStyle(
                      fontSize: 34,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Text(
                        "Share a Ride",
                      ),
                    ),
                  ),
////////////////////////////////////////// DEPART //////////////////////////////////////////
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Material(
                      color: Colors.transparent,
                      child: SizedBox(
                        width: 340,
                        child: TypeAheadField(
                          textFieldConfiguration: TextFieldConfiguration(
                            decoration: InputDecoration(
                              labelText: "Départ",
                              hintText: "Enter your localisation",
                              prefixIcon: const Icon(Icons.directions),
                              suffixIcon: IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        _searchController.clear();
                                      },
                                    ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onChanged: (value) {
                              _onSearchTextChanged(value);
                            },
                            controller: _searchController,
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
                            _fillFirstTextField(suggestion);
                          },
                        ),
                      ),
                    ),
                  ), 
////////////////////////////////////// DESTINATION ////////////////////////////////////////////////                 
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Material(
                      color: Colors.transparent,
                      child: SizedBox(
                        width: 340,
                        child: TypeAheadField(
                          textFieldConfiguration: TextFieldConfiguration(
                            decoration: InputDecoration(
                              labelText: "Destination",
                              hintText: "Enter your destination",
                              prefixIcon: const Icon(Icons.directions),
                              suffixIcon: IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        _secondSearchController.clear();
                                      },
                                    ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onChanged: (value) {
                              _onSecondSearchTextChanged(value);
                            },
                            controller: _secondSearchController,
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
                            _fillSecondTextField(suggestion);
                          },
                        ),
                      ),
                    ),
                  ),
//////////////////////////////////// DATE ///////////////////////////////////////////////////                  
                  Padding(
                    padding: const EdgeInsets.only(top: 50, left: 40, right: 30),
                    child: Row(
                      children: [
                        Expanded(
                          child: Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(25.0),
                            child: TextField(
                              readOnly: true,
                              controller: TextEditingController(
                                text: _selectedDate == null
                                    ? ''
                                    : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
                              decoration: InputDecoration(
                                labelText: "Date",
                                hintText: "Choose date",
                                prefixIcon: const Icon(Icons.date_range),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: IconButton(
                            onPressed: () => _selectDate(context),
                            icon: const Icon(Icons.calendar_today),
                          ),
                        ),
////////////////////////// TIME /////////////////////////////////                        
                        const SizedBox(width: 15),
                        SizedBox(
                          width: 135,
                          child:  Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _selectTime(context),
                            child: IgnorePointer(
                              child: SizedBox( 
                                width: 330, // Set desired width here
                                child: TextFormField(
                                  controller: TextEditingController(
                                    text: _selectedTime == null
                                        ? ''
                                        : '${_selectedTime!.hour}:${_selectedTime!.minute}'),
                                  decoration: InputDecoration(
                                    labelText: "Time",
                                    hintText: "Choose time",
                                    prefixIcon: const Icon(Icons.access_time),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ), 
                        ),
                      ],
                    ),
                  ),

//////////////////////////////// SEATS //////////////////////////////////////////////////
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Material(
                            color: Colors.transparent,
                            child: SizedBox(
                              width: 340,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedSeats = int.tryParse(value) ?? 0;
                                  });
                                },
                                decoration: const InputDecoration(
                                  labelText: "Seats",
                                  hintText: "Number of passengers",
                                  prefixIcon: Icon(Icons.person),
                                  
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ),

//////////////////////////////// PRICE //////////////////////////////////////////////////
                    Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Material(
                      color: Colors.transparent,
                      child: Form(
                        key: _formKey1,
                        child: Column(
                          children: [
                            SizedBox(
                              width: 330,
                              child: TextFormField(
                                controller: _priceController,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Fill the field !';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    labelText: 'Price (da)',
                                    hintText: 'Price of the Ride',
                                    prefixIcon: const Icon(Icons.attach_money),
                                     suffixIcon: IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        _priceController.clear();
                                      },
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20))),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ), 

////////////////////////////// DEPARTURE POINT //////////////////////////////////
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Material(
                      color: Colors.transparent,
                      child: Form(
                        key: _formKey2,
                        child: Column(
                          children: [
                            SizedBox(
                              width: 330,
                              child: TextFormField(
                                controller: _placeController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Fill the field !';
                                  }
                                  return null;
                                },
                                   maxLength: 150,
                                    maxLines: 4,
                                decoration: InputDecoration(
                                    labelText: 'Meeting Point',
                                    hintText: 'Departure Point',
                                    prefixIcon: const Icon(Icons.place),
                                     suffixIcon: IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        _placeController.clear();
                                      },
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20))),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ), 

////////////////////////  SHARE THE RIDE /////////////////////////////////////////                  
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Center(
                      child: SizedBox(
                        width: 330,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: isButtonEnabled
                              ? () {
                                  _saveRide(context);
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
                            'Share the Ride',
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
