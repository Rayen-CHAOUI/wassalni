import 'package:covoiturage/BothUsers/CreditCardPage%20.dart';
import 'package:flutter/material.dart';

class PaymentMethod extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Method'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Navigate to CreditCardPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const CreditCardPage();
                  }),
                );
              },
              child: const Text('Pay with Card'),
            ),
            ElevatedButton(
              onPressed: () {
                // Implement payment with cash
                // Add your implementation here
              },
              child: const Text('Pay with Cash'),
            ),
          ],
        ),
      ),
    );
  }
}
