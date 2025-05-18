import 'dart:developer';

import 'package:covoiturage/Backend/UserData%20.dart';
import 'package:covoiturage/Backend/constant.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDataBase {
  static var db, userCollection;

  static Future<List<UserData>> connect() async {
    db = await Db.create(mongo_uri);
    await db.open();
    inspect(db);
    userCollection = 'passengerDB';
    userCollection = db.collection(userCollection);

    // Fetch data from MongoDB
    var result = await userCollection.find().toList();

    List<UserData> userDataList = result
        .map<UserData>((doc) => UserData(
              username: doc['username'] ?? '',
              age: doc['age'] as int?,
              id_passages: doc['id_passages'] as int?,
              email: doc['email'] ?? '',

              // Add more fields as needed
            ))
        .toList();

    // Now userDataList contains the data from the MongoDB collection
    return userDataList;
  }
}
