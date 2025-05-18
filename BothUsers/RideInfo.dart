// ignore_for_file: avoid_print, use_build_context_synchronously, deprecated_member_use


import 'package:covoiturage/BothUsers/ClassRide.dart';
import 'package:covoiturage/BothUsers/CreditCardPage%20.dart';
import 'package:covoiturage/DRIVER/LocationScreen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RideInfo extends StatefulWidget {
  final Ride ride;

  const RideInfo({Key? key, required this.ride}) : super(key: key);

  @override
  State<RideInfo> createState() => _RideInfoState();
}

class _RideInfoState extends State<RideInfo> {
  bool isFavorite = false;

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
  
 Future<void> _showContactOptions(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Contact Options'),
          content: const Text('Choose an option to contact the driver:'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                final Uri callUri = Uri(
                  scheme: 'tel',
                  path: widget.ride.driver.phoneNumber,
                );
                if (await canLaunch(callUri.toString())) {
                  await launch(callUri.toString());
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not launch call')),
                  );
                }
                Navigator.of(context).pop();
              },
              child: const Text('Call via Phone'),
            ),
            TextButton(
              onPressed: () async {
                final Uri messageUri = Uri(
                  scheme: 'sms',
                  path: widget.ride.driver.phoneNumber,
                );
                if (await canLaunch(messageUri.toString())) {
                  await launch(messageUri.toString());
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not launch message')),
                  );
                }
                Navigator.of(context).pop();
              },
              child: const Text('Message'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final driver = widget.ride.driver;
    final age = _calculateAge(driver.yearOfBirth);
//////////////////////////////////////////////////////////////////////////////
 return Scaffold(
      appBar: AppBar(
        title: const Text('Ride Info'),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
                if (isFavorite) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Ride Added to Favorites'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              });
            },
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.grey,
            ),
          ),
        ],
      ),

     body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/icon/background.png'), // Change this to your background image path
              fit: BoxFit.cover,
            ),
          ),

          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage('lib/icon/profile_picture.jpg'),
                      radius: 30,
                      backgroundColor: Colors.transparent,
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${driver.familyName} ${driver.firstName} ' ,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                        const SizedBox(height: 5),
                         const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width: 8),
                            Text(
                              'Join 2024',
                            ),
                            Row(
                              children: [
                               Text('4.5'),
                                Icon(Icons.star, color: Colors.yellow),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
        
                 Padding(
                  padding: const EdgeInsets.only(top:30,bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Driver info",style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold),),
                      const SizedBox(height: 15,),
                      Text('Adresse Email :  ${driver.email}'),
                      const SizedBox(height: 10,),
                      Text('Phone Number :  ${driver.phoneNumber}'),
                      const SizedBox(height: 10,),
                       Text('Age : $age  year old'),
                      const SizedBox(height: 10,),
                      Text("${driver.familyName}'s  car : ${driver.carData.carMarque} ${driver.carData.carName} - ${driver.carData.year}"),
                      const SizedBox(height: 10,),
                       Text("Numéro d'immatriculation :  ${driver.carData.immatric}"),
                       const SizedBox(height: 10,),
                        Text("Color : ${driver.carData.carColor}"),
                    ],
                  ),
                ),
                
///////////////////////////////////////// RIDE DETAILS /////////////////////////////////////////////////////////////////////
                 Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 20),
                    child: Row(
                      children: [
                        const Text(
                          "Ride detail",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),

                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            // Define the action when the clickable text is pressed
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return const LocationScreen();
                                }),
                              );
                          },
                          child: const Text(
                            "view on map",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                Row(
                  children: [
                    const Icon(Icons.my_location, color: Colors.red),
                    const SizedBox(width: 10),
                    Row(
                      children: [
                        const Text("From: ",style: TextStyle(fontSize: 18),),
                        Text(
                          widget.ride.depart,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 150,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.green),
                    const SizedBox(width: 10),
                    Row(
                      children: [
                        const Text("To: ",style: TextStyle(fontSize: 18),),
                        Text(
                          widget.ride.location,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              
//////////////////////////////////////////////////////////////////////////////////////////////////////////
                const Padding(
                  padding: EdgeInsets.only(top: 20,bottom: 10),
                  child: Divider(
                    color: Colors.white,
                    thickness: 1,
                  ),
                ),
        
                Padding(
                  padding: const EdgeInsets.only(bottom: 10,),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Add this line for consistent spacing
                    children: [
                      Column(
                        children: [
                          const Text("Date ",style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold),),
                          const SizedBox(height: 10,),
                          Text('${widget.ride.date}',style: const TextStyle(fontSize: 18),),
                        ],
                      ),
                      Column(
                        children: [
                          const Text("Start time ",style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold),),
                          const SizedBox(height: 10,),
                          Text('${widget.ride.time}',style: const TextStyle(fontSize: 18),),
                        ],
                      ),
                       Column(
                        children: [
                         const Text("Price",style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold),),
                        const  SizedBox(height: 10,),
                          Text('${widget.ride.price} da',style: const TextStyle(fontSize: 18),),
                        ],
                      ),
                    ],
                  ),
                ),
        
                Padding(
                  padding: const EdgeInsets.only(top:40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Meeting point :",style: TextStyle(fontSize: 18 ,fontWeight: FontWeight.bold),),
                      const SizedBox(height: 10,),
                      Text('${widget.ride.meetPlace}'),
                    ],
                  ),
                ),
        
                Padding(
                  padding: const EdgeInsets.only(top:40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Passengers :",style: TextStyle(fontSize: 18 ,fontWeight: FontWeight.bold),),
                      const SizedBox(height: 25,),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            widget.ride.seats,
                            (index) => const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0), // Adjust the horizontal spacing as needed
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: AssetImage('lib/icon/profile_picture.jpg'),
                                    radius: 30,
                                    backgroundColor: Colors.transparent,
                                  ),
                                  Text('Empty'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
        
                Padding(
                  padding: const EdgeInsets.only(top: 60, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [

////////////////////////////// BOOK RIDE BUTTON ///////////////////////////////
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return const CreditCardPage();
                            }),
                          );
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
                          'Book ride',
                          style: TextStyle(fontSize: 35),
                        ),
                      ),

////////////////////////////// CONTACT BUTTON ///////////////////////////////
                      ElevatedButton(
                        onPressed: () async{
                          _showContactOptions(context);
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
                          'Contact',
                          style: TextStyle(fontSize: 35), // Set the font size here
                        ),
                      ),
                    ],
                  ),
                ),
        
        ////////////////////////////////////////////////////////////////////////
        ///////////////////////////////////////////////////////////////////////////
              ],
            ),
          ),
        ),
      ),
    );
  }
}

