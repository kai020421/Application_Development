// PART A
/*

class Address { // profile ke liye jo click ho kar aaye
  final String street;
  final String suite;
  final String city;

  const Address({ 
    required this.street,
    required this.suite,
    required this.city,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address( // json decode kafrke adress banado
        street: json['street'] ?? '',
        suite: json['suite'] ?? '',
        city: json['city'] ?? '',
      );

  String get fullAddress => '$street, $suite, $city'; 
}

class Company { // company ke liye jo click ho kar aaye
  final String name;

  const Company({required this.name}); 

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        name: json['name'] ?? '',
      );
}

class User { // user model se jo data molay api se
  final int id;
  final String name;
  final String email;
  final String phone;
  final Address address;
  final Company company;
  bool isFavorite;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.company,
    this.isFavorite = false,
  });

  factory User.fromJson(Map<String, dynamic> json) => User( //json decode phir user detail
        id: json['id'] as int,
        name: json['name'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String,
        address: Address.fromJson(json['address'] ?? {}),
        company: Company.fromJson(json['company'] ?? {}),
      );

  String get initials { // user ke initials ko return kare
    List<String> names = name.trim().split(' '); //name split karke list mains store
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase(); //case sentive name first letter of first and last name
    }
    return name.isNotEmpty ? name[0].toUpperCase() : ''; // first letter ko upper case
  }
}
*/

//PART B
// Address ka sub model
class Address {
  final String street;
  final String city;

  Address({required this.street, required this.city}); // constructor jo street aur city ko pass karta hai

  factory Address.fromJson(Map<String, dynamic> json) { 
    return Address(
      street: json['street'] ?? '', // steet null so empty return
      city: json['city'] ?? '',
    );
  }
}

// Company ka submodel
class Company {
  final String name;

  Company({required this.name});

  factory Company.fromJson(Map<String, dynamic> json) { // fac constru jo json ko comp model comv
    return Company(
      name: json['name'] ?? '',
    );
  }
}

// Main User Model
class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final Address address;
  final Company company;
  bool isFavorite;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.company,
    this.isFavorite = false,
  });

  String get initials {
    List<String> names = name.split(" ");
    if (names.length >= 2) {
      return "${names[0][0]}${names[1][0]}".toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : "";
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: Address.fromJson(json['address'] ?? {}), // address ko Address model me convert kar ke storee
      company: Company.fromJson(json['company'] ?? {}), // company ko Company model me convert kar ke store 
    );
  }
}