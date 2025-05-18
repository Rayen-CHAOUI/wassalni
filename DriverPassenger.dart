import 'package:covoiturage/DRIVER/WlcmDriver.dart';
import 'package:covoiturage/PASSENGERS/MainPagePassenger.dart';
import 'package:covoiturage/PASSENGERS/WlcmPassenger.dart';
import 'package:flutter/material.dart';



class DriverPassenger extends StatefulWidget
{
  const DriverPassenger({super.key});

  @override
  State<DriverPassenger> createState()
  {
    return _DriverPassengerState();
  }
}

class _DriverPassengerState extends State<DriverPassenger>
{
  
  @override
  Widget build(BuildContext context)
  {
/////////////////////////////////// BACKGROUND IMAGE //////////////////////////////////

    return SingleChildScrollView(
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

//////////////////////////// GUEST ICON /////////////////////////////////
               Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Material(
                      color: Colors.transparent,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return const MainPagePassenger();
                            }),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                        
///////////////////////////////// IMAGE ////////////////////////////////////////
                    
                        const Padding(
                          padding: EdgeInsets.only(),
                          child: Image(
                            image: AssetImage("lib/icon/rideshare.png"),
                           height: 400,
                          ),
                        ),
                      

///////////////////////////////// TEXT /////////////////////////////////////////

                      const DefaultTextStyle(
                        style: TextStyle(
                          fontSize: 34,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(),
                          child: Text(
                            "Hi ! Welcome to Wassalni",
                          ),
                        ),
                      ),

                      const DefaultTextStyle(
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.grey,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            "Sharing Rides, Building Bonds",
                          ),
                        ),
                      ),

//////////////////////////////// PASSSENGER BUTTON ////////////////////////////

                      Padding(
                        padding: const EdgeInsets.only(top: 60),
                        child: Center(
                          child: SizedBox(
                            width: 250,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context, MaterialPageRoute(builder: (context) {
                                  return const WlcmPassenger ();
                                }
                                ),
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.white),
                                foregroundColor: MaterialStateProperty.all(Colors.black),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                              ),

                              child: const Text(
                                'Passenger',
                                style: TextStyle(fontSize: 35), 
                              ),
                            ),
                          ),
                        ),
                      ),

///////////////////////////////// DRIVER BUTTON /////////////////////////////////////////

                    Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Center(
                          child: SizedBox(
                            width: 250,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context, MaterialPageRoute(builder: (context) {
                                  return const WlcmDriver ();
                                }
                                ),
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.white),
                                foregroundColor: MaterialStateProperty.all(Colors.black),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                              ),

                              child: const Text(
                                'Rider',
                                style: TextStyle(fontSize: 35), 
                              ),
                            ),
                          ),
                        ),
                      ),
////////////////////////////////////////////////////////////////////////////////




////////////////////////////////////////////////////////////////////////////////

                    ]
                ),
              ),
            ]
        )
    );
  }
}
