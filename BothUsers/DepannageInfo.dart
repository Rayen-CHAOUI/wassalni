// ignore_for_file: deprecated_member_use, use_build_context_synchronously, library_private_types_in_public_api

import 'package:covoiturage/BothUsers/ClassDepannage.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DepannageInfo extends StatefulWidget {
  final Depannage depannage;

  const DepannageInfo({Key? key, required this.depannage}) : super(key: key);

  @override
  _DepannageInfoState createState() => _DepannageInfoState();
}

class _DepannageInfoState extends State<DepannageInfo> {
  bool isFavorite = false;

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
                  path: widget.depannage.driver.phoneNumber,
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
                  path: widget.depannage.driver.phoneNumber,
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
    final driver = widget.depannage.driver;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Depannage Info'),
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
                      title: const Text('Depannage Added to Favorites'),
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
              image: AssetImage('lib/icon/background.png'), 
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
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(top:30,bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Driver info",style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold),),
                      const SizedBox(height: 15,),
                      Text('Email:  ${driver.email}'),
                      const SizedBox(height: 10,),
                      Text('Phone Number:  ${driver.phoneNumber}'),
                      const SizedBox(height: 10,),
                      const Text("Car info"),
                      const SizedBox(height: 10,),
                      Text("Car: ${driver.carData.carMarque} ${driver.carData.carName} - ${driver.carData.year}"),
                      const SizedBox(height: 10,),
                      Text("Registration Number: ${driver.carData.immatric}"),
                      const SizedBox(height: 10,),
                      Text("Color: ${driver.carData.carColor}"),
                    ],
                  ),
                ),

                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 60, bottom: 20),
                    child: ElevatedButton(
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
