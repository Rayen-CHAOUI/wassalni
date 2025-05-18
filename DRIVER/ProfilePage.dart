// ignore_for_file: use_build_context_synchronously

import 'package:covoiturage/Backend/Endpoints.dart';
import 'package:covoiturage/BothUsers/ConnectPage.dart';
import 'package:covoiturage/BothUsers/FavoriteRides.dart';
import 'package:covoiturage/BothUsers/bookedRide.dart';
import 'package:covoiturage/DRIVER/RequestedRide.dart';
import 'package:covoiturage/DriverPassenger.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'CarInfo.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}
 
class _ProfilePageState extends State<ProfilePage> {
  String familyName = '';
  String firstName = '';
  String phoneNumber = '';
  String profilePictureUrl = '';
  String gender = '';
  String email = '';
  String carName = '';
  String carMarque = '';
  String year = '';
  String immatric = '';
  String carteGrise = '';
  String age = '';

  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Fetch user data when the page initializes
  }

  @override
  void dispose() {
    emailController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> fetchUserData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken');
      print("Token: $authToken");

      if (authToken != null) {
        final response = await http.get(
          Uri.parse(profilePageAPI),
          headers: {'Authorization': 'Bearer $authToken'},
        );

        if (response.statusCode == 200 && authToken.isNotEmpty) {
          final userData = jsonDecode(response.body);
          setState(() {
            print('User data: $userData');
            familyName = userData['familyName'] ?? '';
            firstName = userData['firstName'] ?? '';
            phoneNumber = userData['phoneNumber'] ?? '';
            profilePictureUrl = userData['profileImage'] ?? '';
            gender = userData['gender'] ?? '';
            email = userData['email'] ?? '';
            carMarque = userData['carMarque'] ?? '';
            carName = userData['carName'] ?? '';
            year = userData['year'] ?? '';
            immatric = userData['immatric'] ?? '';
            carteGrise = userData['carteGrise'] ?? '';
            age = _calculateAge(userData['yearOfBirth']);
            });
        } else {
          print('Failed to load user data: ${response.statusCode}');
          print('Error message: ${response.body}');
        }
      } else {
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

  Future<void> updateEmail(String newEmail) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken');

      if (authToken != null) {
        final response = await http.put(
          Uri.parse(updateEmailAPI),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $authToken'
          },
          body: jsonEncode({'email': newEmail}),
        );

        if (response.statusCode == 200) {
          setState(() {
            email = newEmail;
          });
          print('Email updated successfully');
        } else {
          print('Failed to update email: ${response.statusCode}');
          print('Error message: ${response.body}');
        }
      }
    } catch (error) {
      print('Error updating email: $error');
    }
  }

  Future<void> updatePhoneNumber(String newPhoneNumber) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken');

      if (authToken != null) {
        final response = await http.put(
          Uri.parse(updatePhoneNumberAPI),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $authToken'
          },
          body: jsonEncode({'phoneNumber': newPhoneNumber}),
        );

        if (response.statusCode == 200) {
          setState(() {
            phoneNumber = newPhoneNumber;
          });
          print('Phone number updated successfully');
        } else {
          print('Failed to update phone number: ${response.statusCode}');
          print('Error message: ${response.body}');
        }
      }
    } catch (error) {
      print('Error updating phone number: $error');
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
                  Stack(
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage('lib/icon/profile_picture.jpg'),
                        radius: 50,
                        backgroundColor: Colors.transparent,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          onPressed: () {
                            // Add your onPressed logic here
                          },
                          icon: const Icon(Icons.camera_alt),
                          color: Colors.black,
                          iconSize: 30,
                        ),
                      ),
                    ],
                  ),
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
                padding: const EdgeInsets.only(top: 10),
                child: ListTile(
                  title: const Text("Adresse email"),
                  subtitle: Text(email),
                  leading: const Icon(Icons.mail),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      emailController.text = email;
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Edit Email'),
                            content: TextFormField(
                              controller: emailController,
                              decoration: const InputDecoration(
                                hintText: 'Enter new email',
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  final newEmail = emailController.text;
                                  updateEmail(newEmail);
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Save'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),

              ListTile(
                title: const Text("Phone Number"),
                subtitle: Text(phoneNumber),
                leading: const Icon(Icons.phone),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    phoneNumberController.text = phoneNumber;
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Edit Phone Number'),
                          content: TextFormField(
                            controller: phoneNumberController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              hintText: 'Enter new phone number',
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                final newPhoneNumber = phoneNumberController.text;
                                updatePhoneNumber(newPhoneNumber);
                                Navigator.of(context).pop();
                              },
                              child: const Text('Save'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),

              ListTile(         ///////AGE
                title: const Text("Gender"),
                subtitle: Text(gender),
                leading: const Icon(Icons.person_rounded),
              ),

              ListTile(
                title: const Text("Car information"),
                subtitle: Row(
                  children: [
                    Text(carMarque),
                    const SizedBox(width: 5),
                    Text(carName),
                    const SizedBox(width: 10),
                    Text(year),
                  ],
                ),
                leading: const Icon(Icons.car_repair),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return CarInfo( 
                        carName: carName,
                        carMarque: carMarque,
                        year: year,
                        immatric: immatric,
                        carteGrise: carteGrise,
                      );
                    }),
                  );
                },
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
                      return RequestedRide();
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
                      return  bookedRide();
                    }),
                  );
                },
              ),

              ListTile(
                title: const Text("Logout"),
                leading: const Icon(Icons.logout),
                onTap: () async {
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
                              final SharedPreferences prefs = await SharedPreferences.getInstance();
                              await prefs.remove('authToken');
                              print('Token removed, user logged out');

                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return const DriverPassenger();
                                }),
                                (route) => false,
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

