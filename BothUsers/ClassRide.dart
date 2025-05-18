
 

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

class Ride {
  final Driver driver;
  final String depart;
  final String location;
  final String? date;
  final int seats;
  final int price;
  final String? time;
  final String? meetPlace;

  Ride({
    required this.driver,
    required this.depart,
    required this.location,
    this.date,
    required this.seats,
    required this.price,
    this.time,
    required this.meetPlace,
  });

  Map<String, dynamic> toJson() {
    return {
      'driver': driver.toJson(),
      'depart': depart,
      'location': location,
      'date': date,
      'seats': seats,
      'price': price,
      'time': time,
      'meetPlace': meetPlace,
    };
  }

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      driver: Driver.fromJson(json['driver']),
      depart: json['depart'],
      location: json['location'],
      date: json['date'],
      seats: json['seats'],
      price: json['price'],
      time: json['time'],
      meetPlace: json['meetPlace'],
    );
  }
}
