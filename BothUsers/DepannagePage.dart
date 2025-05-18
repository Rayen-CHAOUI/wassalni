import 'package:covoiturage/BothUsers/ClassDepannage.dart';
import 'package:covoiturage/BothUsers/DepannageInfo.dart';
import 'package:flutter/material.dart';

class DepannagePage extends StatelessWidget {
  final List<Depannage> depannages;

  const DepannagePage({Key? key, required this.depannages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Depannages Available'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/icon/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: depannages.isEmpty
            ? const Center(
                child: Text(
                  'Oops! No depannages available.',
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ) 
            : ListView.builder(
                itemCount: depannages.length,
                itemBuilder: (context, index) {
                  final depannage = depannages[index];
                  final driver = depannage.driver;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    child: GestureDetector( // Wrap ListTile with GestureDetector to enable tap
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return DepannageInfo(depannage: depannage); // Navigate to DepannageInfo page
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
                                  const Icon(Icons.location_on, color: Colors.blue),
                                  const SizedBox(width: 10),
                                  Text(
                                    depannage.location,
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
