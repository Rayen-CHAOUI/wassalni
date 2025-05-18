// ignore_for_file: non_constant_identifier_names

import 'package:covoiturage/DRIVER/MainPageDriver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreditCardPage extends StatefulWidget {
  const CreditCardPage({Key? key}) : super(key: key);

  @override
  State<CreditCardPage> createState() => _CreditCardPageState();
}

class _CreditCardPageState extends State<CreditCardPage> {
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _formKey4 = GlobalKey<FormState>();

  final TextEditingController _cardNumberControle = TextEditingController();
  final TextEditingController _cardHolderControle = TextEditingController();
  final TextEditingController _cvvCodeControle = TextEditingController();
  final TextEditingController _MMYYCodeControle = TextEditingController();

// Define a method to show the payment success dialog
void showPaymentSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Success'),
        content: const Text('Ride booked successfully!'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close AlertDialog
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 1.07,
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
                    const Padding(
                      padding: EdgeInsets.only(top: 25),
                      child: SizedBox(
                        child: DefaultTextStyle(
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                          child: Text(
                            'Payment method',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),

/////////////////////// CREDIT CARD DESIGN CODE //////////////////////////////

                    const SizedBox(height: 30),
                    CreditCardWidget(
                      cardNumber: _cardNumberControle.text,
                      cardHolderName: _cardHolderControle.text,
                      expiryDate :_MMYYCodeControle.text, 
                    ), 

/////////////////////////////// Card Number ////////////////////////////
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Material(
                        color: Colors.transparent,
                        child: Form(
                          key: _formKey1,
                          child: Column(
                            children: [
                              SizedBox(
                                width: 330,
                                child: TextFormField(
                                  inputFormatters: [CardNumberInputFormatter()],
                                  controller: _cardNumberControle,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Fill in the field!';
                                    }
                                    return null;
                                  },
                                  maxLength: 19,
                                  decoration: InputDecoration(
                                    labelText: 'Card Number',
                                    prefixIcon: const Icon(Icons.credit_card),
                                    prefixIconColor: Colors.white,
                                    labelStyle: const TextStyle(color: Colors.white),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

/////////////////////////// Card Holder Name ///////////////////////////////
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Material(
                        color: Colors.transparent,
                        child: Form(
                          key: _formKey2,
                          child: Column(
                            children: [
                              SizedBox(
                                width: 330,
                                child: TextFormField(
                                  controller: _cardHolderControle,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Fill in the field!';
                                    }
                                    return null;
                                  },
                                  maxLength: 35,
                                  decoration: InputDecoration(
                                    labelText: 'Card Holder Name',
                                    prefixIcon: const Icon(Icons.person),
                                    prefixIconColor: Colors.white,
                                    labelStyle: const TextStyle(color: Colors.white),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

///////////////////////////// MM/YY ///////////////////////////////////
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Material(
                            color: Colors.transparent,
                            child: Form(
                              key: _formKey3,
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: 150,
                                    child: TextFormField(
                                      controller: _MMYYCodeControle,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [MMYYInputFormatter()],
                                      maxLength: 5,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Fill in the field!';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'MM/YY ',
                                        prefixIcon: const Icon(Icons.date_range),
                                        prefixIconColor: Colors.white,
                                        labelStyle: const TextStyle(color: Colors.white),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
///////////////////////////////////////////////////////////////////////////////////////////
                        const SizedBox(width: 30),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Material(
                            color: Colors.transparent,
                            child: Form(
                              key: _formKey4,
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: 150,
                                    child: TextFormField(
                                      controller: _cvvCodeControle,
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Fill in the field!';
                                        }
                                        return null;
                                      },
                                      maxLength: 3,
                                      decoration: InputDecoration(
                                        labelText: 'CVV ',
                                        prefixIcon: const Icon(Icons.credit_card_outlined),
                                        prefixIconColor: Colors.white,
                                        labelStyle: const TextStyle(color: Colors.white),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
 
///////////////////////// BOOK NOW BUTTON ////////////////////////////////
            Padding(
                  padding: const EdgeInsets.only(top: 60, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                              ElevatedButton(
                                onPressed: () {
                                  if (_formKey1.currentState!.validate() &
                                      _formKey2.currentState!.validate() &
                                      _formKey3.currentState!.validate() &
                                      _formKey4.currentState!.validate() ) {

                                    // GO TO MainPageDriver 
 
                                        Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(builder: (context) {
                                          return const MainPageDriver();
                                        }),
                                        (route) {
                                          return false;
                                        },
                                      ); 
                                        showPaymentSuccessDialog(context);                             
                                          }
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
                                  'Book Now',
                                  style: TextStyle(fontSize: 30), // Set the font size here
                                ),
                              ),

////////////////////////////// CONTACT BUTTON ///////////////////////////////
                      ElevatedButton(
                        onPressed: () async{
                          {
                                        Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(builder: (context) {
                                          return const MainPageDriver();
                                        }),
                                        (route) {
                                          return false;
                                        },
                                      ); 
                                        showPaymentSuccessDialog(context);                             
                                          }
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
                          'Cash',
                          style: TextStyle(fontSize: 35), // Set the font size here
                        ),
                      ),
                    ],
                  ),
                ),
///////////////////////////
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//////////////////////////////////////////////////////////////////////////
///////////////////////// CreditCardWidget //////////////////////////////

class CreditCardWidget extends StatelessWidget {
  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;

  const CreditCardWidget(
     {super.key, 
    required this.cardNumber,
    required this.expiryDate,
    required this.cardHolderName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 330,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Colors.lightBlue, Colors.purple, Colors.red], // Change colors as needed
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Row(
                  children: [

                    Image.asset(
                      'lib/icon/carteDahabiyaLogo.png',
                      height: 40,
                      width: 60,
                    ),

                    Image.asset(
                      'lib/icon/creditcardLogos.png',
                      height: 40,
                      width: 60,
                    ),

                  ],
                ),

                const Icon(
                  Icons.contactless_outlined,
                  color: Colors.white,
                  size: 40,
                ),

              ],
            ),
          ),
///////////////////////////// CARD NUMBER //////////////////////////////////////
           Center(
             child: Padding(
              padding: const EdgeInsets.only(),
              child: Text(
                cardNumber.isNotEmpty ? cardNumber : 'xxxx xxxx xxxx xxxx', 
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
                     ),
           ),
/////////////////////// expiry date //////////////////////////////////////
          Padding(
            padding: const EdgeInsets.only(top: 20 , left: 200),
            child: Text(
              expiryDate.isNotEmpty ? expiryDate : 'MM/YY', 
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
/////////////////////// cardHolder Name //////////////////////////////////////
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 20),
            child: Text(
              cardHolderName.isNotEmpty ? cardHolderName: 'Card Holder\'s Name', 
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),

/////////////////////////////////////////////////////////////
        ],
      ),
    );
  }
}
///////////////////////////////////////////////////////////////////////////////////
////////////////////// MMYY Input Formatter ///////////////////////////////////////
///
class MMYYInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = _formatInput(newValue.text);
    return newValue.copyWith(
      text: newText,
      selection: _updateCursorPosition(oldValue, newText),
    );
  }

  String _formatInput(String input) {
    input = input.replaceAll(RegExp(r'\D'), ''); // Remove non-digits
    if (input.length > 4) {
      input = input.substring(0, 4); // Limit to MMYY format
    }
    if (input.length >= 3) {
      // Insert a '/' between month and year
      return '${input.substring(0, 2)}/${input.substring(2)}';
    }
    return input;
  }

  TextSelection _updateCursorPosition(
      TextEditingValue oldValue, String newText) {
    final cursorPosition = newText.length;

    // Maintain cursor position if deleting or at the end of the input
    if (oldValue.selection.baseOffset >= newText.length) {
      return TextSelection.fromPosition(
          TextPosition(offset: newText.length));
    }

    return TextSelection.fromPosition(TextPosition(offset: cursorPosition));
  }
}
////////////////////// Card Number Input Formatter ///////////////////////////////////////
class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final cleanText = newValue.text.replaceAll(RegExp(r'\D'), ''); // Remove non-digits
    final formattedText = _formatInput(cleanText);
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }

  String _formatInput(String input) {
    final formatted = input.replaceAllMapped(
        RegExp(r'.{4}'), (match) => '${match.group(0)} ');
    return formatted.trim();
  }
}