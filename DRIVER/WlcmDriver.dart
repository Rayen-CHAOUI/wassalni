//import 'package:covoiturage/PASSENGER/MainPage.dart';
import 'package:covoiturage/DRIVER/CreateUser.dart';
import 'package:covoiturage/DRIVER/Register1.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';



class WlcmDriver extends StatefulWidget
{
  const WlcmDriver({super.key});

  @override
  State<WlcmDriver> createState()
  {
    return _WlcmDriverState();
  }
}

class _WlcmDriverState extends State<WlcmDriver>
{
  
  @override
  Widget build(BuildContext context)
  {
/////////////////////////////////// WELCOME DRIVER //////////////////////////////////

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
          /*     Align(
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
                              return const MainPage();
                            }),
                          );
                        },
                      ),
                    ),
                  ),
                ),*/

                        
///////////////////////////////// IMAGE ////////////////////////////////////////
                    
                        const Padding(
                          padding: EdgeInsets.only(top: 80),
                          child: Image(
                            image: AssetImage("lib/icon/driverPreview.png"),
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
                            "Welcome again",
                          ),
                        ),
                      ),

                      const DefaultTextStyle(
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.grey,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text(
                            "Share rides, Earn more money !",
                          ),
                        ),
                      ),

//////////////////////////////// GET STARTED BUTTON ////////////////////////////

                      Padding(
                        padding: const EdgeInsets.only(top: 60),
                        child: Center(
                          child: SizedBox(
                            width: 250,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context, MaterialPageRoute(builder: (context) {
                                  return const CreateUser ();
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
                                'Get Started',
                                style: TextStyle(fontSize: 30), 
                              ),
                            ),
                          ),
                        ),
                      ),
///////////////////////////////// SIGN UP TEXT /////////////////////////////////////////

                      Padding(
                        padding: const EdgeInsets.only(top: 55),
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              const TextSpan(
                                text: " Don't have an account ?  ",
                                style: TextStyle(
                                  fontSize: 19, 
                                ),
                              ),
                              TextSpan(
                                text: 'Register',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  fontSize: 19, 
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return const Register1();
                                      }),
                                    );
                                  },
                              ),
                            ],
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
