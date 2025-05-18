import 'package:covoiturage/DRIVER/AddCar.dart';
import 'package:flutter/material.dart';

class CarInfo extends StatefulWidget {
  final String carName;
  final String carMarque;
  final String year;
  final String immatric;
  final String carteGrise;

  const CarInfo({ 
    Key? key,
    required this.carName,
    required this.carMarque,
    required this.year,
    required this.immatric,
    required this.carteGrise,
  }) : super(key: key);

  @override
  State<CarInfo> createState() => _CarInfoState();
}
 
class _CarInfoState extends State<CarInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[950],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Car Information"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: const Text("Model"),
                    subtitle: Text(widget.carName),
                  ),
                  ListTile(
                    title: const Text("Brand"),
                    subtitle: Text(widget.carMarque),
                  ),
                  ListTile(
                    title: const Text("Year"),
                    subtitle: Text(widget.year),
                  ),
                  ListTile(
                    title: const Text("Immatriculation"),
                    subtitle: Text(widget.immatric),
                  ),
                   const ListTile(
                     title: Text("Color"),
                     subtitle: Text("grise"),
                   ),
                ],
              ),
            ),


            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                   Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) {
                                          return   const AddCar(
                                          fullName: '',
                                          idNumber: '',
                                          email: '', 
                                          phoneNumber: '', 
                                          gender: '',
                                          imagePath: '',
                                          password: '',
                                            );
                                        }),
                                      );
                },
                child: const Text("Add new car", style: TextStyle(fontSize: 30),),
              ),
            ),

          ],
        ),
      ),
    );
  }
}