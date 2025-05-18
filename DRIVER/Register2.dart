import 'package:covoiturage/DRIVER/MainPageDriver.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class Register2 extends StatefulWidget {
  const Register2({Key? key, }) : super(key: key);

  @override
  State<Register2> createState() { 
    return _Register2State();
  }
} 
 
class _Register2State extends State<Register2> {

  final _formKey1 = GlobalKey<FormState>(); //CODE
  
  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
/////////////////////////////////// Sign up2 //////////////////////////////////

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
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
              children: <Widget>[
///////////////////////////////// IMAGE ////////////////////////////////////////

                const Padding(
                  padding: EdgeInsets.only(),
                  child: Image(
                    image: AssetImage("lib/icon/pngwing.png"),
                    height: 400,
                  ),
                ),

///////////////////////////// TEXT //////////////////////////////////

                const Center(
                  child: DefaultTextStyle(
                    style: TextStyle(
                      fontSize: 40,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(),
                      child: Text(
                        "OTP verification",
                      ),
                    ),
                  ),
                ),

                const Center(
                  child: DefaultTextStyle(
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        "Enter the 6 degit verification code",
                      ),
                    ),
                  ),
                ),

/////////////////////////////// CONFIRMATION CODE //////////////////////////////
  
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Material(
                    color: Colors.transparent,
                    child: Form(
                      key: _formKey1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 300,
                            child: PinCodeTextField(
                              appContext: context,
                              length: 6,
                              obscureText: false,
                              animationType: AnimationType.fade,
                              pinTheme: PinTheme(
                                shape: PinCodeFieldShape.underline,
                                activeFillColor: Colors.white,
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {},
                              controller: _codeController,
                              validator: (value) {
                                if (value!.isEmpty || value.length != 6) {
                                  return 'Enter a valid 6-digit code';
                                }
                                return null;
                              },
                            ),
                          ),
                          //SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),

/////////////////////////////////// NEXT BUTTON /////////////////////////////

                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Center(
                    child: SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey1.currentState!.validate()) {
                            // GO TO 2ND PAGE
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return const MainPageDriver();
                              }),
                            );
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.black),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        child: const Text(
                          'CREATE',
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }
}
