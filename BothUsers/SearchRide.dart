// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:covoiturage/Backend/wilaya.dart';
import 'package:covoiturage/BothUsers/ClassRide.dart';
import 'package:covoiturage/BothUsers/RidesPage.dart';
import 'package:covoiturage/Backend/Endpoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class SearchRide extends StatefulWidget {
  const SearchRide({Key? key});

  @override
  _SearchRideState createState() { 
    return _SearchRideState();
  }
}

class _SearchRideState extends State<SearchRide> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _secondSearchController = TextEditingController();
  DateTime? _selectedDate;
  int _selectedSeats = 0;
  bool _isLoading = false;
  List<Ride> searchedRides = [];


  final List<String> _searchResult1 = [];
  final List<String> _searchResult2 = [];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: _scaffoldKey.currentContext!,
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
/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    bool isButtonEnabled =
        _searchController.text.isNotEmpty &&
        _secondSearchController.text.isNotEmpty &&
        _selectedDate != null &&
        _selectedSeats > 0;

    Color buttonColor = isButtonEnabled ? Colors.white : Colors.grey;

    return Scaffold(
      key: _scaffoldKey,
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

////////////////////////// TEXT ///////////////////////////////////////////////
              const Padding(
                  padding: EdgeInsets.only(top:50),
                  child: DefaultTextStyle(
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                    child: Text(
                      "Find your ideal Ride",
                    ),
                  ),
                ),

                  const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: DefaultTextStyle(
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.grey,
                    ),
                    child: Text(
                      "With us !",
                    ),
                  ),
                ),
                
////////////////////////// DEPART ///////////////////////////////////////////////
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Material(
                      color: Colors.transparent,
                      child: SizedBox(
                        width: 330,
                        child: TypeAheadField(
                          textFieldConfiguration: TextFieldConfiguration(
                            decoration: InputDecoration(
                              labelText: "Départ",
                              hintText: "Enter your localisation",
                              prefixIcon: const Icon(Icons.circle),
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

///////////////////////// DESTINATION ////////////////////////////////////
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Material(
                      color: Colors.transparent,
                      child: SizedBox(
                        width: 330,
                        child: TypeAheadField(
                          textFieldConfiguration: TextFieldConfiguration(
                            decoration: InputDecoration(
                              labelText: "Destination",
                              hintText: "Enter your destination",
                              prefixIcon: const Icon(Icons.circle),
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

////////////////////////////////// DATE ///////////////////////////////////////
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
                            onPressed: () => _selectDate(),
                            icon: const Icon(Icons.calendar_today),
                          ),
                        ),

//////////////////////////////// SEATS ///////////////////////////////////////////
                        const SizedBox(width: 15),
                        SizedBox(
                          width: 120,
                          child: Material(
                            color: Colors.transparent,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  _selectedSeats = int.tryParse(value) ?? 0;
                                });
                              },
                              decoration: const InputDecoration(
                                labelText: "Seats",
                               // hintText: "passengers",
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

////////////////////////////////////// SEARCH BUTTON ////////////////////////////////////////
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Center(
                      child: SizedBox(
                        width: 330,
                        height: 50,  
                        child: 
                      ElevatedButton(
                    onPressed: isButtonEnabled
                        ? () async {
                          setState(() {
                            _isLoading = true;
                          });
                            final response = await http.post(
                              Uri.parse(searchRidesAPI),
                              headers: {
                                'Content-Type': 'application/json',
                              },
                              body: jsonEncode({
                                'depart': _searchController.text,
                                'location': _secondSearchController.text,
                                'seats': _selectedSeats, 
                                'date': _selectedDate != null ? DateFormat('dd-MM-yyyy').format(_selectedDate!) : null,
                                'include_greater_seats': true, //  include rides with greater seats
                              }),
                            );
                if (response.statusCode == 200) {
                  print('Rides: ${response.body}');
                  final List<dynamic> ridesData = jsonDecode(response.body)['rides'];
                  final List<Ride> searchedRides =
                      ridesData.map((data) => Ride.fromJson(data)).toList();

                  setState(() {
                    this.searchedRides = searchedRides;
                  });

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return RidesPage(rides: searchedRides);
                    }),
                  );
                  print('Rides: ${response.body}');
                } else {
                  // Handle error
                  print('Error: ${response.body}');
                }
                setState(() {
                  _isLoading = false;
                });
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

                   child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                            'Search Rides',
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

/////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
