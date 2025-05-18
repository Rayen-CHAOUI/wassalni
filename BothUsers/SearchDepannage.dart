// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:covoiturage/Backend/wilaya.dart';
import 'package:covoiturage/Backend/Endpoints.dart';
import 'package:covoiturage/BothUsers/ClassDepannage.dart';
import 'package:covoiturage/BothUsers/DepannagePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SearchDepannagePage extends StatefulWidget {
  const SearchDepannagePage({super.key});

  @override
  _SearchDepannagePageState createState() => _SearchDepannagePageState();
}

class _SearchDepannagePageState extends State<SearchDepannagePage> {
  final TextEditingController _locationController = TextEditingController();
  bool _isLoading = false;
  List<Depannage> _searchResults = [];

  void _onSearchTextChanged(String value) {
    setState(() {});
  }

  void _fillTextField(String value) {
    setState(() {
      _locationController.text = value;
    });
  }

  Future<void> _searchDepannage() async {
    if (_locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the location')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken');

    final response = await http.post(
      Uri.parse(searchDepannage),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $authToken', // Use the actual token
      },
      body: json.encode({
        'location': _locationController.text,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> depannageData = data['depannages'];
      final List<Depannage> depannages = depannageData.map((json) => Depannage.fromJson(json)).toList();

      setState(() {
        _searchResults = depannages;
      });

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return DepannagePage(depannages: _searchResults);
        }),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No towing offer found for the specified location.')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  const Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: DefaultTextStyle(
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                      ),
                      child: Text(
                        "Find the nearest towing offer",
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
                        "With us!",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Material(
                      color: Colors.transparent,
                      child: SizedBox(
                        width: 330,
                        child: TypeAheadField(
                          textFieldConfiguration: TextFieldConfiguration(
                            decoration: InputDecoration(
                              labelText: "Location",
                              hintText: "Enter your location",
                              prefixIcon: const Icon(Icons.circle),
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
                    padding: const EdgeInsets.only(top: 50),
                    child: Center(
                      child: SizedBox(
                        width: 330,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _locationController.text.isNotEmpty && !_isLoading
                              ? _searchDepannage
                              : null,
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
                              ? const CircularProgressIndicator()
                              : const Text(
                                  'Search Towing offer',
                                  style: TextStyle(fontSize: 30),
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

