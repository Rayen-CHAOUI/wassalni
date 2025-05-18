import 'package:covoiturage/PASSENGERS/LoginPassenger.dart';
import 'package:covoiturage/PASSENGERS/SignUp1.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';



class WlcmPassenger extends StatefulWidget
{
  const WlcmPassenger({super.key});

  @override
  State<WlcmPassenger> createState()
  {
    return _WlcmPassengerState();
  }
}

class _WlcmPassengerState extends State<WlcmPassenger>
{
  
  @override
  Widget build(BuildContext context)
  {
/////////////////////////////////// WELCOM PASSENGER //////////////////////////////////

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
                            image: AssetImage("lib/icon/shareRide.png"),
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
                            "Find cheapest rides with us !",
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
                                  return const LoginPassenger ();
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
                                text: 'Sign up',
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
                                        return const SignUp1();
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
