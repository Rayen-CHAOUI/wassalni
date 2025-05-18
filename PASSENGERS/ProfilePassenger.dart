import 'package:covoiturage/BothUsers/ConnectPage.dart';
import 'package:covoiturage/BothUsers/FavoriteRides.dart';
import 'package:covoiturage/BothUsers/bookedRide.dart';
import 'package:covoiturage/DriverPassenger.dart';
import 'package:covoiturage/Backend/Endpoints.dart';
import 'package:covoiturage/PASSENGERS/RideRequest.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; 
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePassenger extends StatefulWidget {
  const ProfilePassenger({Key? key}) : super(key: key);
 
  @override
  _ProfilePassengerState createState() => _ProfilePassengerState();
}

class _ProfilePassengerState extends State<ProfilePassenger> {
  String familyName = '';
  String firstName = '';
  String phoneNumber = '';
  String profilePictureUrl = '';
  String gender = '';
  String email = '';
  String age = '';

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Fetch user data when the page initializes
  }

  Future<void> fetchUserData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken');
      print("Token: $authToken");

      if (authToken != null) {
        final response = await http.get(
          Uri.parse(profilePageAPI),
          headers: {'Authorization': 'Bearer $authToken'}, // Include the token in the authorization header
        ); 

        if (response.statusCode == 200 && authToken.isNotEmpty) {
          // Successfully fetched user data
          final userData = jsonDecode(response.body);
          setState(() {
            print('User data: $userData'); // print user's data
            familyName = userData['familyName'] ?? '';
            firstName = userData['firstName'] ?? '';
            phoneNumber = userData['phoneNumber'] ?? '';
            profilePictureUrl = userData['profileImage'] ?? ''; 
            gender = userData['gender'] ?? ''; 
            email = userData['email'] ?? '';
            age = _calculateAge(userData['yearOfBirth']);
          });
        } else {
          // Handle other status codes (e.g., 401 for unauthorized)
          print('Failed to load user data: ${response.statusCode}');
          print('Error message: ${response.body}');
        }
      } else {
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return ConnectPage();
          }),
        );
        print('JWT token is not available');
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  String _calculateAge(String yearOfBirth) {
    if (yearOfBirth.isNotEmpty) {
      final int birthYear = int.parse(yearOfBirth);
      final int currentYear = DateTime.now().year;
      final int calculatedAge = currentYear - birthYear;
      return calculatedAge.toString();
    } else {
      return 'Unknown';
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
/////////////////////////// Display user profile picture ///////////////////////////////
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('lib/icon/profile_picture.jpg'), // Use profile picture URL
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          onPressed: () {
                            // Add your onPressed logic here
                          },
                          icon: const Icon(Icons.camera_alt), color: Colors.black, iconSize: 30,
                        ),
                      ),
                    ],
                  ),

////////////////////// USER'S INFO /////////////////////// 
                  const SizedBox(height: 10),
                  Text(
                    '$familyName $firstName',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ListTile(
                  title: const Text("Adresse email"),
                  subtitle: Text(email),
                  leading: const Icon(Icons.mail),
                ),
              ),
              
              ListTile(
                title: const Text("Phone Number"),
                subtitle: Text(phoneNumber),
                leading: const Icon(Icons.phone),
              ),

              ListTile(
                title: const Text("Gender"),
                subtitle: Text(gender),
                leading: const Icon(Icons.person_rounded),
              ),

              ListTile(
                title: const Text("Age"),
                subtitle: Text(age),
                leading: const Icon(Icons.numbers),
              ),

              ListTile(
                title: const Text("Favorite Rides"),
                subtitle: const Text("favorite rides"),
                leading: const Icon(Icons.favorite),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return FavoriteRides();
                    }),
                  );
                },
              ),
   
              ListTile( 
                title: const Text("Requested Rides"),
                subtitle: const Text("requested rides"),
                leading: const Icon(Icons.favorite),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return RideRequest();
                    }),
                  );
                },
              ),

              ListTile(
                title: const Text("Booked Rides"),
                subtitle: const Text("Booked rides"),
                leading: const Icon(Icons.download_done_outlined),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return bookedRide();
                    }),
                  );
                },
              ),

////////////////////////////// Logout /////////////////////////////////////
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
                              print('Token removed, user logged out');

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
              /////////////////////////////////////////////////////////////
            ],
          ),
        ),
      ),
    );
  }
}
