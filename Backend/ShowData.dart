import 'package:covoiturage/Backend/Mongodatabase.dart';
import 'package:covoiturage/Backend/UserData%20.dart';
import 'package:covoiturage/Backend/UserDataList%20.dart';
import 'package:flutter/material.dart';

class ShowData extends StatelessWidget {
  const ShowData({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('MongoDB DataBase Display Passengers'),
        ),
        body: FutureBuilder(
          future: MongoDataBase.connect(),
          builder: (context, AsyncSnapshot<List<UserData>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // Data is loaded, display it
              return UserDataList(userDataList: snapshot.data!);
            } else {
              // Data is still loading
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}