import 'dart:convert';
import 'dart:async';
import 'dart:ui';

import 'package:covoiturage/BothUsers/AllRides.dart';
import 'package:covoiturage/BothUsers/ClassRide.dart';
import 'package:covoiturage/BothUsers/RideInfo.dart';
import 'package:covoiturage/BothUsers/SearchRide.dart';
import 'package:covoiturage/BothUsers/ShareRide.dart';
import 'package:covoiturage/Backend/Endpoints.dart';
import 'package:covoiturage/DRIVER/AddDepannage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:covoiturage/DRIVER/ProfilePage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MainPageDriver extends StatefulWidget {
  const MainPageDriver({Key? key}) : super(key: key);

  @override
  State<MainPageDriver> createState() {
    return _MainPageDriverState();
  }
}

class _MainPageDriverState extends State<MainPageDriver> {
  int _currentIndex = 0;
  DateTime? _lastPressed;

  final List<Widget> _pages = [
    const HomePageContent(),
    const SearchRide(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async { 
        final now = DateTime.now();
        if (_lastPressed == null ||
            now.difference(_lastPressed!) > const Duration(seconds: 2)) {
          _lastPressed = now;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Press back again to exit'),
            ),
          );
          return false;  
        }
        // Clear JWT token
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.remove('authToken');
          print('Token removed');
        return true;
      },

      child: Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.blue[900],
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}


////////////////////////////////////////////////////////////////
class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children :[
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
          children: [
    
    ///////////////////////////////////// TEXT /////////////////////////////////////
    
            const Padding(
              padding: EdgeInsets.only(top:20),
              child: DefaultTextStyle(
                style: TextStyle(
                  fontSize: 50,
                ),
                child: Text(
                  "ElAmel Ride",
                ),
              ),
            ),
    
            const DefaultTextStyle(
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
              child: Text(
                "Make it easy",
              ),
            ),
    
    ///////////////////////////////////// SLIDE IMAGES /////////////////////////////
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: SizedBox(
                width: 370,
                height: 150, 
                child: FlutterCarousel(
                  options: CarouselOptions(
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 10),
                    height: 400,
                    showIndicator: true,
                    slideIndicator: const CircularSlideIndicator(indicatorBackgroundColor: Colors.white,currentIndicatorColor: Colors.blue),
                  ),
                  items: [ 
                    'lib/icon/Carpoolpana.png',
                    'lib/icon/Citydrivercuate.png',
                    'lib/icon/Towing-pana.png',
                    'lib/icon/Towing-amico.png',
                    'lib/icon/Order ride-rafiki.png',
                  ].map((imagePath) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width:  MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(50),
                            color: Colors.white24,
                            image: DecorationImage(
                              image: AssetImage(imagePath),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
    
    ///////////////////////////////////// RIDE & DEPANNAGE ///////////////////////////
    
            Padding(
              padding: const EdgeInsets.only(top:40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return  const ShareRide();
                        }),
                      );
                    },
                    child: Container(
                      width: 170,
                      height: 170,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15), // Adjust the radius as needed
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: AssetImage('lib/icon/help me.png'),
                            height: 130,
                            width: 130,
                          ),
                          SizedBox(height: 10.0), // Spacer between image and text
                          Text(
                            'Share a Ride',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 16), 
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return  const AddDepannage();
                        }),
                      );
                    },
                    child: Container(
                      width: 170,
                      height: 170,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15), // Adjust the radius as needed
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: AssetImage('lib/icon/TowingBro.png'),
                            height: 130,
                            width: 130,
                          ),
                          SizedBox(height: 10.0), // Spacer between image and text
                          Text(
                            'Towing offer',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    
    ////////////////////////// RANDOM RIDES //////////////////////////////////////
        
                  Padding(
                    padding: const EdgeInsets.only(top: 20, right: 30),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return AllRides();
                            }),
                          );
                        },
                        child: const DefaultTextStyle(
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.white70,
                            decoration: TextDecoration.underline,
                          ),
                          child: Text("View all rides"),
                        ),
                      ),
                    ),
                  ),
    
         Padding(
            padding: const EdgeInsets.only(top:15,left:20,right: 20),
            child: FutureBuilder(
              future: fetchRandomRides(),
              builder: (context, AsyncSnapshot<List<Ride>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'No rides available.',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                } else {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: snapshot.data!.map((ride) {
                        return SizedBox(
                          width: 300,
                          height: 180,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                  MaterialPageRoute(builder: (context) {
                                    return  RideInfo(ride: ride);
                                        }),
                                     );
                            },
    
                            child: Card(
                              elevation: 0, // No shadow from the Card
                              margin: const EdgeInsets.all(12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: Colors.transparent, // Set card color to transparent
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent, // Transparent background
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.4), // Adjust the color and opacity of the shadow
                                      blurRadius: 10,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 50 , sigmaY: 50), // Apply blur effect
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.transparent, // Semi-transparent white color
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('${ride.depart} -> ${ride.location}', style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18, color: Colors.lightBlueAccent)),
                                            Text('${ride.time} | ${ride.date}', style: const TextStyle(color: Colors.white)),
                                            Text('Driver: ${ride.driver.familyName} ${ride.driver.firstName}', style: const TextStyle(color: Colors.white)),
                                            Text('Phone Number: ${ride.driver.phoneNumber}', style: const TextStyle(color: Colors.white)),
                                            Text('Remaining Seats: ${ride.seats.toString()}', style: const TextStyle(color: Colors.white)),
                                            Text('Meeting Point: ${ride.meetPlace}', style: const TextStyle(color: Colors.white)),
                                            Text('Price: ${ride.price.toString()}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        );
                       }
                      ).toList(),
                    ),
                  );
                }
              },
            ),
          ),
          
    ///////////////////////////////////// REPORT US ! //////////////////////////////
    
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: SizedBox(
                width: 370,
                height: 85,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return const ReportUs();
                      }),
                    );
                  },
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(10),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    foregroundColor: MaterialStateProperty.all(Colors.blue[800]),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Report us!',
                          style: TextStyle(fontSize: 35),
                        ),
                        Image(
                          image: AssetImage('lib/icon/report us.png'),
                          height: 200,
                          width: 100,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    ////////////////////////////////////////////////////////////////////////////////
    
    
    ////////////////////////////////////////////////////////////////////////////////
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////

Future<List<Ride>> fetchRandomRides() async {
  final response = await http.get(Uri.parse(randomRides));
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body)['randomRides'];
    return data.map((rideData) {
      return Ride( 
        depart: rideData['depart'],
        location: rideData['location'],
        date: rideData['date'],
        seats: rideData['seats'],
        price: rideData['price'],
        time: rideData['time'],
        meetPlace: rideData['meetPlace'],
        driver: Driver(
          familyName: rideData['driver']['familyName'],
          firstName: rideData['driver']['firstName'],
          email: rideData['driver']['email'],
          phoneNumber: rideData['driver']['phoneNumber'],
          profileImage: rideData['driver']['profileImage'],
          yearOfBirth:rideData['driver']['yearOfBirth'],
          carData: CarData(
            carName: rideData['driver']['carData']['carName'],
            carMarque: rideData['driver']['carData']['carMarque'],
            year: rideData['driver']['carData']['year'],
            immatric: rideData['driver']['carData']['immatric'],
            carColor: rideData['driver']['carData']['carColor'],
          ),
        ),
      );
    }).toList();
  } else {
    throw Exception('Failed to load random rides');
  }
}

////////////////////////////////////////////////////////////////////////////////
              /////////////////////// BOTTOM NAV BAR CLASSES /////////////////////////////////
////////////////////////////////////////////////////////////////////////////////




///////////////////////////////////////////////////////////////////////////
////////////////////////    REPORT   ///////////////////////////////////
////////////////////////////////////////////////////////////////////

class ReportUs extends StatefulWidget
{
  const ReportUs({super.key});

  @override
  State<ReportUs> createState()
  {
    return _ReportUsState();
  }
}

class _ReportUsState extends State<ReportUs>
{
  final _formKey1 = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context)
  {
/////////////////////////////////// REPORT US  //////////////////////////////////

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
                children :[
                  Container(
                    width: 500,
                    height: 834,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.blue[950],
                      image: const DecorationImage(
                        image: AssetImage('lib/icon/background.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    
                    child: Stack(
                        children: [
                          const Positioned(
                            left: 50,
                            top: 10,
                            child: SizedBox(
                              width: 330,
                              height: 330,
                              child: Image(
                                image: AssetImage("lib/icon/Duplicate-cuate.png"),
      
                              ),
                            ),
                          ),
      
      ///////////////////////////// TEXT FIELD AREA //////////////////////////////////
      
                          Padding(
                            padding: const EdgeInsets.only(left: 45, top: 470),
                            child: Material(
                              color: Colors.transparent,
                              child: Form(
                                key: _formKey1,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: 330,
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your opinions in the field !';
                                          }
                                          return null;
                                        },
                                        maxLength: 350,
                                        maxLines: 5,
                                        decoration: InputDecoration(
                                            labelText: 'Feedback ',
                                            prefixIconColor: Colors.white,
                                            labelStyle: const TextStyle(color: Colors.white),
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10)
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
      
      ///////////////////////////// SEND REPORT //////////////////////////////////////
      
                          Padding(
                            padding: const EdgeInsets.only(top: 600),
                            child: Center(
                              child: SizedBox(
                                width: 200,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey1.currentState!.validate() )
                                    {

                                      // SEND  DATA TO SERVER HERE


                                      Navigator.of(context).pop(); // return to MainPageDriver 
                                      showPaymentSuccessDialog(context); 

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
                                    'Send',
                                    style: TextStyle(fontSize: 30), // Set the font size here
                                  ),
                                ),
                              ),
                            ),
                          ),
      
      ///////////////////////////    TEXT   //////////////////////////////////////////
      
                          const DefaultTextStyle(
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 150),
                              child: Center(
                                child: Text(
                                  "Report us",
                                ),
                              ),
                            ),
                          ),
      
                          const DefaultTextStyle(
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(top: 380, left: 50),
                              child: Text(
                                "We always work to provide you with the best \n   services and improve them based on your \n                 opinions and interactions.",
                              ),
                            ),
                          ),
      
      
                          const DefaultTextStyle(
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(top: 815),
                              child: Center(
                                child: Text(
                                  "elamel_ride.algérie@gmail.com",
                                ),
                              ),
                            ),
                          ),
      
      ////////////////////////////////////////////////////////////////////////////////
      
                        ]
                    ),
                  ),
                ]
            )
        ),
      ),
    );
  }
  
////////////////// Define a method to show the payment success dialog ////////////////////////////////
            void showPaymentSuccessDialog(BuildContext context) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Success'),
                    content: const Text('Feedback sent successfully!'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close AlertDialog
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }

}
