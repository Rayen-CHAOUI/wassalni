import 'package:covoiturage/DriverPassenger.dart';
import 'package:covoiturage/Backend/Endpoints.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; 
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class EditInfo extends StatefulWidget {
  const EditInfo({Key? key}) : super(key: key);

  @override
  _EditInfoState createState() => _EditInfoState();
}

class _EditInfoState extends State<EditInfo> {
  String fullName = '';
  String phoneNumber = '';
  String profilePictureUrl = '';
  String gender = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Fetch user data when the page initializes
  }

Future<void> fetchUserData() async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken');
    print(authToken);
    if (authToken != null) {
      final response = await http.get(
        Uri.parse(profilePageAPI),
        headers: {'Authorization': 'Bearer $authToken'}, 
      );

      if (response.statusCode == 200 && authToken.isNotEmpty) {
        // Successfully fetched user data
        final userData = jsonDecode(response.body);
        setState(() {
          print('User data: $userData'); // print user' data
          fullName = userData['fullName'] ?? 'USER NOT FOUND';
          phoneNumber = userData['phoneNumber'] ?? '';
          profilePictureUrl = userData['profileImage'] ?? ''; 
          gender = userData['gender'] ?? ''; 
          email = userData['email'] ?? '';
        });
      } else {
        // Handle other status codes (e.g., 401 for unauthorized)
        print('Failed to load user data: ${response.statusCode}');
        print('Error message: ${response.body}');
      }
    } else {
      print('JWT token is not available');
    }
  } catch (error) {
    print('Error fetching user data: $error');
  }
}


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
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
        child: Padding(
          padding: const EdgeInsets.only(top: 25),
          child: ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  // Display user profile picture
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('lib/icon/profile_picture.jpg'), ////// Use profile picture URL
                  ),

                  const SizedBox(height: 10),
                  Text(
                     fullName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50),
                
                child: ListTile(
                title: const Text("Adresse email"),
                subtitle: Text(email),
                leading: const Icon(Icons.mail),
                onTap: () {
                  // Handle press
                },
              ),

              ),

              ListTile(
                  title: const Text("Phone Number"),
                  subtitle: Text(phoneNumber),
                  leading: const Icon(Icons.phone),
                ),

              ListTile(
                title: const Text("Personel information"),
                subtitle: const Text("Edit your information"),
                leading: const Icon(Icons.person_pin),
                onTap: () {
                  // Handle press
                },
              ),

              ListTile( ///////////// IF car.isEmpty (passengers) : don't display this ListTitle /////////////
                title: const Text("Car information"),
                subtitle: const Text("Peageot 301 2013"),
                leading: const Icon(Icons.car_repair),
                onTap: () {
                  // Handle press
                },
              ),

              ListTile(
                title: const Text("Favorite Rides"),
                subtitle: const Text("favorite rides"),
                leading: const Icon(Icons.favorite),
                onTap: () {
                  // open favorite rides page
                },
              ),

              ListTile(
            title: const Text("Logout"),
            leading: const Icon(Icons.logout),
            onTap: () async {
              // Show logout confirmation dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirm Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {

                          // Clear JWT token
                          final SharedPreferences prefs = await SharedPreferences.getInstance();
                          await prefs.remove('authToken');
                          print('Token removed , user logged out');

                          // Navigate to login page
                          // ignore: use_build_context_synchronously
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return const DriverPassenger();
                            }),
                            (route) {
                              return false;
                            },
                          );
                        },
                        child: const Text('Logout'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
              
            ],
          ),
        ),
      ),
    );
  }
}
