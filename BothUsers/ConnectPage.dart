import 'package:covoiturage/DriverPassenger.dart';
import 'package:flutter/material.dart';

class ConnectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You are not logged in.',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to DriverPassenger page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const DriverPassenger();
                  }),
                );
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
