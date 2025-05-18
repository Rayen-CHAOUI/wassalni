import 'package:flutter/material.dart';
import 'package:covoiturage/BothUsers/ClassRide.dart'; 

class bookedRide extends StatefulWidget {
  @override
  _bookedRideState createState() => _bookedRideState();
}

class _bookedRideState extends State<bookedRide> {
  List<Ride> rides = [
    Ride(
      driver: Driver(
        familyName: 'Chaoui ',
        firstName: 'Rayen',
        email: 'chairn@gmail.com',
        phoneNumber: '+0698797314',
        profileImage: 'lib/icon/profile_picture.jpg',
        yearOfBirth:'2002',
        carData: CarData(
          carName: '301',
          carMarque: 'Peageout',
          year: '2013',
          immatric: '01645-113-14',
          carColor: 'Grisse',
        ),
      ),
      depart: '14-Tiaret',
      location: '31-Oran',
      date: '2024-06-25',
      seats: 3,
      price: 350,
      time: '06:00 AM',
      meetPlace: 'Meetup Location 1',
    ),

    Ride(
      driver: Driver(
        familyName: 'Boumaza',
        firstName: 'Youcef',
        email: 'boazaucef@gmail.com',
        phoneNumber: '254678963214',
        profileImage: 'lib/icon/profile_picture.jpg',
        yearOfBirth:'2003',
        carData: CarData(
          carName: 'Honda Civic',
          carMarque: 'Honda',
          year: '2020',
          immatric: '32560-120-31',
          carColor: 'White',
        ),
      ),
      depart: '31-Oran',
      location: '16-Alger',
      date: '2024-06-27',
      seats: 2,
      price: 650,
      time: '05:30 AM',
      meetPlace: 'Meetup Location 2',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Booked Rides'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/icon/background.png'), // Change this to your background image path
            fit: BoxFit.cover,
          ),
        ),
        child: rides.isEmpty
            ? const Center(
                child: Text(
                  'Oops! No booked rides.',
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              )
            : ListView.builder(
                itemCount: rides.length,
                itemBuilder: (context, index) {
                  final ride = rides[index];
                  final driver = ride.driver;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    child: GestureDetector(
                      onTap: () {
                      ///////////////////////
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
                                    child: Column(
                                      children: [
                                        Text(
                                          ' ${ride.price} Da',
                                          textAlign: TextAlign.end,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 26,
                                              color: Colors.black),
                                        ),


                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, color: Colors.blue),
                                  const SizedBox(width: 10),
                                  Row(
                                    children: [
                                      Text(
                                        ride.location,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.blue),
                                      ),
                                      const SizedBox(width: 170,),
                                      ElevatedButton(
                                            onPressed: () {},
                                            style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all(Colors.red),
                                              foregroundColor: MaterialStateProperty.all(Colors.white),
                                              shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(15),
                                                ),
                                              ),
                                            ),
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(fontSize: 20), 
                                            ),
                                          ),
                                    ],
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${driver.familyName} ${driver.firstName}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '${ride.date}, ${ride.time}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),

                                      const SizedBox(width: 30,),
                                        ElevatedButton(
                                            onPressed: () {},
                                            style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all(Colors.blue),
                                              foregroundColor: MaterialStateProperty.all(Colors.white),
                                              shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(15),
                                                ),
                                              ),
                                            ),
                                            child: const Text(
                                              'SOS',
                                              style: TextStyle(fontSize: 25), 
                                            ),
                                          ),

                              const SizedBox(width: 20,),
                                        ElevatedButton(
                                            onPressed: () {},
                                            style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all(Colors.green),
                                              foregroundColor: MaterialStateProperty.all(Colors.white),
                                              shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(15),
                                                ),
                                              ),
                                            ),
                                            child: const Text(
                                              'Track',
                                              style: TextStyle(fontSize: 25), 
                                            ),
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
