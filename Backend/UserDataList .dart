import 'package:covoiturage/Backend/UserData%20.dart';
import 'package:flutter/material.dart';

class UserDataList extends StatelessWidget {
  final List<UserData> userDataList;

  const UserDataList({super.key, required this.userDataList}); 

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: userDataList.length,
      itemBuilder: (context, index) {
        var userData = userDataList[index];
        return ListTile(
          title: Text(userData.username ?? 'Unknown'), // Provide a default value if 'username' is null
          subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Age: ${userData.age ?? 'Unknown'}'),
              Text('id_passages: ${userData.id_passages ?? 'Unknown'}'),
              Text('email adresse: ${userData.email ?? 'Unknown'}'),
              const Text(".\n.\n."),
            ],
          ), // Provide a default value if 'age' is null
          // Customize as needed
        );
      },
    );
  }
}




