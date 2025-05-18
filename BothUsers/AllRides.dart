import 'dart:convert';
import 'package:covoiturage/Backend/Endpoints.dart';
import 'package:covoiturage/BothUsers/RideInfo.dart';
import 'package:covoiturage/BothUsers/SearchRide.dart';
import 'package:http/http.dart' as http;

import 'package:covoiturage/BothUsers/ClassRide.dart';
import 'package:flutter/material.dart';

class AllRides extends StatefulWidget {
  @override
  _AllRidesState createState() => _AllRidesState();
}

class _AllRidesState extends State<AllRides> {
  late Future<List<Ride>> futureRides;
  bool _option1Selected = false;
  bool _option2Selected = false;
  bool _option3Selected = false;
  bool _option4Selected = false;
  bool _option5Selected = false;
  bool _option6Selected = false;

  @override
  void initState() {
    super.initState();
    futureRides = RideService.fetchRides();
  }

  void _applyFilters() {
    setState(() {
      futureRides = RideService.fetchRides(
        cheapest: _option1Selected,
        morningOnly: _option2Selected,
        eveningOnly: _option3Selected,
        nearestTime: _option4Selected,
      );
    });
  }

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
                title: const Text('Cheapest price to expensive'),
                value: _option1Selected,
                onChanged: (bool? value) {
                  setState(() {
                    _option1Selected = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Morning only'),
                value: _option2Selected,
                onChanged: (bool? value) {
                  setState(() {
                    _option2Selected = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Evening only'),
                value: _option3Selected,
                onChanged: (bool? value) {
                  setState(() {
                    _option3Selected = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Nearest time'),
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
                _applyFilters();  // Apply filters and refetch the rides
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
        title: const Text('All Available Rides'),
        actions: [
               IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return const SearchRide();
                    }),
                  );
                },
                icon: const Icon(Icons.search),
              ),
          IconButton(
            onPressed: _openFilterDialog,
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/icon/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<List<Ride>>(
          future: futureRides,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'Oops! No rides available.',
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final ride = snapshot.data![index];
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
                          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                                      const SizedBox(width: 150),
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
                                        '${driver.familyName} ${driver.firstName}',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(width: 40),
                                      Row(
                                        children: List.generate(
                                          ride.seats,
                                          (index) => const Icon(Icons.event_seat, color: Colors.black),
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
                                      const SizedBox(width: 30),
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
              );
            }
          },
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////
class RideService {

  static Future<List<Ride>> fetchRides({
    bool? cheapest,
    bool? morningOnly,
    bool? eveningOnly,
    bool? nearestTime,
  }) async {
    final response = await http.get(Uri.parse(allRidesAPI));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Ride> rides = body.map((dynamic item) => Ride.fromJson(item)).toList();

      // Apply filtering on the client side
      if (cheapest != null && cheapest) {
        rides.sort((a, b) => a.price.compareTo(b.price));
      }

      if (morningOnly != null && morningOnly) {
        rides = rides.where((ride) {
          final time = DateTime.parse(ride.time ?? '00:00');
          return time.hour < 12;
        }).toList();
      }

      if (eveningOnly != null && eveningOnly) {
        rides = rides.where((ride) {
          final time = DateTime.parse(ride.time ?? '00:00');
          return time.hour >= 18;
        }).toList();
      }

      if (nearestTime != null && nearestTime) {
        rides.sort((a, b) {
          final timeA = DateTime.parse(a.time ?? '00:00' );
          final timeB = DateTime.parse(b.time ?? '00:00');
          return timeA.compareTo(timeB);
        });
      }

      return rides;
    } else {
      throw Exception('Failed to load rides');
    }
  }
}

