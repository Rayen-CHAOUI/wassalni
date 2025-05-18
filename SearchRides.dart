import 'package:covoiturage/Backend/UserData%20.dart';
import 'package:flutter/material.dart';
import 'package:covoiturage/Backend/MongoDataBase.dart';
 
class SearchRides extends StatefulWidget {
  @override
  _SearchRidesState createState() => _SearchRidesState();
}

class _SearchRidesState extends State<SearchRides> {
  String? _searchTerm = '';
  List<UserData> _results = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Search Riders'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchTerm = value;
                });
              },
              decoration: const InputDecoration(
                labelText: "Enter rider's name",
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              setState(() {
                _isLoading = true;
              });

              try {
                var results = await MongoDataBase.connect();

                if (results.isNotEmpty) {
                  setState(() {
                    _results = results
                        .where((user) => user.username!.toLowerCase().contains(_searchTerm!.toLowerCase()))
                        .toList();
                  });
                } else {
                  // Handle case where results is null or empty
                  print('No results found.');
                }
              } catch (e) {
                // Handle connection errors
                print('Error connecting to the database: $e');
                // You may want to show a snackbar or dialog to inform the user about the error.
              } finally {
                setState(() {
                  _isLoading = false;
                });
              }
            },
            child: const Text('Search'),
          ),

          _isLoading
              ? const CircularProgressIndicator() // Show a loading indicator while searching

              : Expanded(
                  child: _results.isEmpty
                      ? const Center(
                          child: Text('No results found.'),
                        )

                      : ListView.builder(
                        itemCount: _results.length,
                        itemBuilder: (context, index) {

                          return Card(
                            margin: const EdgeInsets.all(10),
                            elevation: 2.0,

                          child: ListTile(
                              leading: const CircleAvatar(
                                radius: 30,
                                backgroundImage: AssetImage('lib/icon/profile_picture.jpg'),
                                ),

                              title: Text(_results[index].username ?? ''),
                              subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Text('Email: ${_results[index].email ?? ''}'),
                                    Text('Age: ${_results[index].age ?? ''}'),
                                    Text('ID_passages: ${_results[index].id_passages ?? ''}'),

                                  ],
                                ),

                                trailing: ElevatedButton(
                                  onPressed: () {
                                    // Handle the accept button click here
                                    print('Accept button clicked for index $index');
                                  },
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                                    ),  

                                 child: const Text('Accept'),
                                 
                                ),
                              ),
                            );
                          },
                        )
                ),
        ],
      ),
    );
  }
}

