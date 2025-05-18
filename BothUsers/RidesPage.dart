import 'package:covoiturage/BothUsers/ClassRide.dart';
import 'package:flutter/material.dart';
import 'package:covoiturage/BothUsers/RideInfo.dart'; 
 
class RidesPage extends StatefulWidget {
  final List<Ride> rides;

  const RidesPage({Key? key, required this.rides}) : super(key: key);

  @override
  _RidesPageState createState() => _RidesPageState();
}

class _RidesPageState extends State<RidesPage> {
  // Variables to store the selected state of each option
  bool _option1Selected = false;
  bool _option2Selected = false;
  bool _option3Selected = false;
  bool _option4Selected = false;
  bool _option5Selected = false;
  bool _option6Selected = false;

  // Function to handle opening filter dialog
  void _openFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filter Rides'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CheckboxListTile(
                title: const Text('cheapest price to expensive'),
                value: _option1Selected,
                onChanged: (bool? value) {
                  setState(() {
                    _option1Selected = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('morning only'),
                value: _option2Selected,
                onChanged: (bool? value) {
                  setState(() {
                    _option2Selected = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('evening only'),
                value: _option3Selected,
                onChanged: (bool? value) {
                  setState(() {
                    _option3Selected = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('nearest time'),
                value: _option4Selected,
                onChanged: (bool? value) {
                  setState(() {
                    _option4Selected = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Option 5'),
                value: _option5Selected,
                onChanged: (bool? value) {
                  setState(() {
                    _option5Selected = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Option 6'),
                value: _option6Selected,
                onChanged: (bool? value) {
                  setState(() {
                    _option6Selected = value!;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Apply filtering based on the selected options here
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Rides Available'),
        actions: [
          IconButton(
            onPressed: _openFilterDialog, // Call the function to open filter dialog
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/icon/background.png'), // Change this to your background image path
            fit: BoxFit.cover,
          ),
        ),
        child: widget.rides.isEmpty
            ? const Center(
                child: Text(
                  'oops! No rides available.',
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              )
            : ListView.builder(
                itemCount: widget.rides.length,
                itemBuilder: (context, index) {
                  final ride = widget.rides[index];
                  final driver = ride.driver;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return RideInfo(ride: ride);
                          }),
                        );
                      },
                      child: Container( 
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          title: Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.my_location, color: Colors.blue),
                                  const SizedBox(width: 10),
                                  Row(
                                    children: [
                                      Text(
                                        ride.depart,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.blue),
                                      ),
                                      const SizedBox(
                                        width: 150,
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Text(
                                      ' ${ride.price} Da',
                                      textAlign: TextAlign.end,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 26,
                                          color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, color: Colors.blue),
                                  const SizedBox(width: 10),
                                  Text(
                                    ride.location,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.blue),
                                  ),
                                ],
                              ),
                              const Divider(
                                color: Colors.black,
                                thickness: 1,
                              ),
                            ],
                          ),
                          subtitle: Row(
                            children: [
                              const CircleAvatar(
                                backgroundImage: AssetImage('lib/icon/profile_picture.jpg'),
                                radius: 25,
                                backgroundColor: Colors.transparent,
                              ),
                              const SizedBox(width: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                       ' ${driver.familyName} ${driver.firstName} ',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 40,
                                      ),
                                      Row(
                                        children: List.generate(
                                          ride.seats,
                                          (index) =>
                                              const Icon(Icons.event_seat, color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Text(
                                        '${ride.date}, ${ride.time}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 30,
                                      ),
                                      const Text(
                                        '4.5',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const Icon(Icons.star, color: Colors.yellowAccent),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
