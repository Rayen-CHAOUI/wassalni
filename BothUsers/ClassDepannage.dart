

class Depannage {
  final String location;
  final Driver driver;


  Depannage({
    required this.location, 
    required this.driver,

    });

  factory Depannage.fromJson(Map<String, dynamic> json) {
    return Depannage(
      location: json['location'],
      driver: Driver.fromJson(json['driver']),

    );
  }
}

class Driver {
  final String familyName;
  final String firstName;
  final String email;
  final String phoneNumber;
  final String profileImage;
  final String yearOfBirth;
  final CarData carData;

  Driver({
    required this.familyName,
    required this.firstName,
    required this.email,
    required this.phoneNumber,
    required this.profileImage,
    required this.yearOfBirth,
    required this.carData,
    });

  Map<String, dynamic> toJson() {
    return {
      'familyName': familyName,
      'firstName': firstName,
      'email': email,
      'phoneNumber': phoneNumber,
      'profileImage': profileImage,
      'yearOfBirth': yearOfBirth,
      'carData': carData.toJson(),
    };
  }

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      familyName: json['familyName'],
      firstName: json['firstName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      profileImage: json['profileImage'],
      yearOfBirth: json['yearOfBirth'],
      carData: CarData.fromJson(json['carData']),
    );
  }
}

class CarData {
  final String carName;
  final String carMarque;
  final String year;
  final String immatric;
  final String carColor;

  CarData({
    required this.carName,
    required this.carMarque,
    required this.year, 
    required this.immatric,
    required this.carColor,
  });

  Map<String, dynamic> toJson() {
    return {
      'carName': carName,
      'carMarque': carMarque,
      'year': year,
      'immatric': immatric,
      'carColor': carColor,
    };
  }

  factory CarData.fromJson(Map<String, dynamic> json) {
    return CarData(
      carName: json['carName'],
      carMarque: json['carMarque'],
      year: json['year'],
      immatric: json['immatric'],
      carColor: json['carColor'],
    );
  }
}